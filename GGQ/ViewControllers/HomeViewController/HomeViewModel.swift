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
//import RxRealm

final class HomeViewModel {

    let elements = Variable<[ArticleInfoObject]>([])

    let hasNextPage = Variable(true)

    let currentPage = Variable(1)

    let isLoading = Variable(false)
    
    let isRequestLatest = Variable(false)

    let disposeBag = DisposeBag()

    init(loadMoreTrigger: Observable<Void>) {

        let realm = try! Realm()
        realm.objects(ArticleInfoObject).asObservable().subscribeNext { [unowned self] objects in
            self.elements.value = objects.map { $0 }
            self.isLoading.value = false
            self.currentPage.value = self.elements.value.count / GGConfig.Home.pageSize + 1
        }.addDisposableTo(disposeBag)

        let loadMoreRequest = loadMoreTrigger.withLatestFrom(currentPage.asObservable()).shareReplay(1)

        let loadMoreResult = loadMoreRequest
            .flatMapLatest { GGProvider.request(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)) }
            .gg_storeArray(ArticleInfoObject)
            .shareReplay(1)
        
        let requestLatest = SyncService.sharedInstance.articlesUpdated
            .map { _ in }.shareReplay(1)
            
        let responseLatest = requestLatest
            .flatMapLatest { GGProvider.request(GGAPI.Articles(pageIndex: 1, pageSize: GGConfig.Home.pageSize)).retry(3) }
            .gg_storeArray(ArticleInfoObject)

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
