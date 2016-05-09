//
//  HomeViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift
import SwiftyJSON
import CoreSpotlight
import MobileCoreServices

final class HomeViewModel {

    let elements = Variable<[ArticleInfoObject]>([])

    let hasNextPage = Variable(true)

    let currentPage = Variable(1)

    let isLoading = Variable(false)

    let isRequestLatest = Variable(false)

    private let disposeBag = DisposeBag()

    init(loadMoreTrigger: Observable<Void>) {

        let realm = try! Realm()
        let predicate = NSPredicate(format: "loadFromHome == %@", true)
        let articlesShare = realm.objects(ArticleInfoObject).filter(predicate)
            .asObservableArray()
            .shareReplay(1)

        articlesShare
            .subscribeNext { objects in
                Info("Count: \(objects.count)")
                self.elements.value = objects
                self.isLoading.value = false
                self.currentPage.value = self.elements.value.count / GGConfig.Home.pageSize + 1
        }.addDisposableTo(disposeBag)

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
            .flatMap { GGProvider.request(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)) }
            .gg_mapJSON()
            .map(convert)
            .flatMap { Realm.rx_create(ArticleInfoObject.self, values: $0, update: true) }
            .shareReplay(1)

        GGProvider
            .request(GGAPI.Articles(pageIndex: 1, pageSize: GGConfig.Home.pageSize))
            .retry(3)
            .gg_mapJSON()
            .map(convert)
            .flatMap { Realm.rx_create(ArticleInfoObject.self, values: $0, update: true) }
            .shareReplay(1).subscribe().addDisposableTo(disposeBag)
        [loadMoreRequest.map { _ in true }, loadMoreResult.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isLoading)
            .addDisposableTo(disposeBag)

//        loadMoreResult
//            .subscribeError { error in
//                log.warning("\(error)")
//                self.hasNextPage.value = false
//            }
//            .addDisposableTo(disposeBag)

//        [requestLatest.map { _ in true }, responseLatest.map { _ in false }]
//            .toObservable()
//            .merge()
//            .bindTo(isRequestLatest)
//            .addDisposableTo(disposeBag)

        Observable.combineLatest(articlesShare, SyncService.articlesNumber(realm)) { $0.count < $1 - 1 }
            .distinctUntilChanged()
            .bindTo(hasNextPage)
            .addDisposableTo(disposeBag)

        realm.objects(ServerInfoModel).asObservable().subscribeNext {
            Warning("\($0)")
        }.addDisposableTo(disposeBag)

        GGProvider.request(GGAPI.ServerInfo)
            .gg_storeObject(ServerInfoModel)
            .subscribe()
            .addDisposableTo(disposeBag)
        
        articlesShare.map { articles -> [CSSearchableItem] in
            return articles.map {
                let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                searchableItemAttributeSet.title = $0.title
                searchableItemAttributeSet.contentDescription = $0.articleDescription
                let searchableItem = CSSearchableItem(uniqueIdentifier: $0.contentUrl, domainIdentifier: "article", attributeSet: searchableItemAttributeSet)
                return searchableItem
            }
            }.subscribeNext {
                
                let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                searchableItemAttributeSet.title = "GGGGGGGGGGGGGGGG"
                searchableItemAttributeSet.contentDescription = "GGGGGGGGGGGGGGGG"
                
                let searchableItem = CSSearchableItem(uniqueIdentifier: "nil", domainIdentifier: "article", attributeSet: searchableItemAttributeSet)
                
                CSSearchableIndex.defaultSearchableIndex().indexSearchableItems($0 + [searchableItem]) { error in
                    if let error = error {
                        Error("\(error)")
                    }
                }
        }.addDisposableTo(disposeBag)

    }
}
