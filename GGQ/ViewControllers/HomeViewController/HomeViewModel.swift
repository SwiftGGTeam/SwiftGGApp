//
//  HomeViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import SwiftyJSON

final class HomeViewModel {

    let elements = Variable<[ArticleInfoObject]>([])

    let hasNextPage = Variable(true)

    let currentPage = Variable(1)

    let isLoading = Variable(false)
    
    let isRequestLatest = Variable(false)

    private let disposeBag = DisposeBag()

    init(loadMoreTrigger: Observable<Void>) {

        let realm = try! Realm()
        realm.objects(ArticleInfoObject).asObservableArray()
            .subscribeNext { [unowned self] objects in
                self.elements.value = objects
                self.isLoading.value = false
                self.currentPage.value = self.elements.value.count / GGConfig.Home.pageSize + 1
            }
            .addDisposableTo(disposeBag)
        
        func convert(json: JSON) -> [AnyObject] {
            return json.arrayValue
                .map { (j: JSON) -> AnyObject in
                    var nj = j
                    nj["loadFromHome"].bool = true
                    return nj.object
            }
        }

        let loadMoreRequest = loadMoreTrigger.withLatestFrom(currentPage.asObservable()).shareReplay(1)

        let loadMoreResult = loadMoreRequest
            .flatMapLatest { GGProvider.request(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)) }
            .gg_mapJSON()
            .map(convert)
            .flatMapLatest { Realm.rx_create(ArticleInfoObject.self, values: $0, update: true) }
            .shareReplay(1)
        
        let requestLatest = SyncService.sharedInstance.articlesUpdated
            .map { _ in 1 }.shareReplay(1)
            
        let responseLatest = requestLatest
            .flatMapLatest { GGProvider.request(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)).retry(3) }
            .gg_mapJSON()
            .map(convert)
            .flatMapLatest { Realm.rx_create(ArticleInfoObject.self, values: $0, update: true) }
            .shareReplay(1)

        [loadMoreRequest.map { _ in true }, loadMoreResult.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isLoading)
            .addDisposableTo(disposeBag)
        
        [requestLatest.map { _ in true }, responseLatest.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isRequestLatest)
            .addDisposableTo(disposeBag)
        
    }
}
