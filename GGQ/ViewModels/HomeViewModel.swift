//
//  HomeViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift
import SwiftyJSON
import CoreSpotlight
import MobileCoreServices

typealias HomeArticleInfoItem = (id: Int, title: NSAttributedString, time: NSDate, info: String, description: NSAttributedString, url: NSURL)

final class HomeViewModel {

    let elements = Variable<[HomeArticleInfoItem]>([])

    let hasNextPage = Variable(true)

    let currentPage = Variable(1)

    let isLoading = Variable(false)

    let isRequestLatest = Variable(false)
    
    let isRefreshing = Variable(false)

    private let disposeBag = DisposeBag()

    init(input: (loadMoreTrigger: Observable<Void>, refreshTrigger: Observable<Void>), provider: RxMoyaXProvider = GGProvider) {

        let realm = try! Realm()
        let predicate = NSPredicate(format: "loadFromHome == %@", true)
        let articlesShare = realm.objects(ArticleInfoObject)
            .filter(predicate).sorted("submitDate", ascending: false)
            .asObservableArray()
            .shareReplay(1)
        
        
        articlesShare.map { articles -> [HomeArticleInfoItem] in
            articles.map { article in
                
                let paragraphContentStyle = NSMutableParagraphStyle()
                paragraphContentStyle.paragraphSpacing = 3

                let titleAttributes: [String: AnyObject] = [
                    NSFontAttributeName: UIFont.systemFontOfSize(21),
                    NSParagraphStyleAttributeName: paragraphContentStyle
                ]
                
                let title = NSAttributedString(string: article.title, attributes: titleAttributes)
                
                let articleDescriptionAttributes: [String: AnyObject] = [
                    NSFontAttributeName: UIFont.systemFontOfSize(17),
                    NSParagraphStyleAttributeName: paragraphContentStyle
                ]
                
                let articleDescription = NSAttributedString(string: mdRender(markdown: article.articleDescription).string, attributes: articleDescriptionAttributes)
                
                let time = article.submitDate.toDateFromISO8601()!
                
                let info = article.typeName + " " + article.translator
                
                return HomeArticleInfoItem(id: article.id, title: title, time: time, info: info, description: articleDescription, url: article.convertURL())
                }
            }
            .subscribeNext { [unowned self] objects in
                Info("Count: \(objects.count)")
                self.elements.value = objects
                self.isLoading.value = false
                self.currentPage.value = self.elements.value.count / GGConfig.Home.pageSize + 1
            }
            .addDisposableTo(disposeBag)
        
        let refreshRequest = input.refreshTrigger.map { 1 }.shareReplay(1)

        let loadMoreRequest = input.loadMoreTrigger.withLatestFrom(currentPage.asObservable()).shareReplay(1)
        
        let refreshResponse = refreshRequest
            .flatMapLatest { provider.v2_requestGGJSON(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)) }
            .shareReplay(1)

        let loadMoreResponse = loadMoreRequest
            .flatMap { provider.v2_requestGGJSON(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)) }
            .shareReplay(1)
        
        [loadMoreResponse, refreshResponse].toObservable().merge()
            .observeOn(TScheduler.Serial(.Background))
            .subscribeNext { result in
                switch result {
                case .Success(let jsons):
                    let realm = try! Realm()
                    try! realm.write {
                        for json in jsons.arrayValue {
                            var object = json.dictionaryObject!
                            object["loadFromHome"] = true
                            realm.create(ArticleInfoObject.self, value: object, update: true)
                        }
                    }
                case .Failure(let error):
                    // TODO: -
                    Error("\(error)")
                }
            }
            .addDisposableTo(disposeBag)

        provider
            .v2_requestGGJSON(GGAPI.Articles(pageIndex: 1, pageSize: GGConfig.Home.pageSize))
            .observeOn(.Serial(.Background))
            .subscribeNext { result in
                switch result {
                case .Success(let json):
                    let realm = try! Realm()
                    try! realm.write {
                        for object in json.arrayObject! {
                            realm.create(ArticleInfoObject.self, value: object, update: true)
                        }
                    }
                case .Failure(let error):
                    // TODO: -
                    Error("\(error)")
                }
            }
            .addDisposableTo(disposeBag)
        
        [loadMoreRequest.map { _ in true }, loadMoreResponse.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isLoading)
            .addDisposableTo(disposeBag)
        
        [refreshRequest.map { _ in true }, refreshResponse.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isRefreshing)
            .addDisposableTo(disposeBag)

        Observable.combineLatest(articlesShare, SyncService.articlesNumber(realm)) { $0.count < $1 - 1 }
            .distinctUntilChanged()
            .bindTo(hasNextPage)
            .addDisposableTo(disposeBag)
        
        provider
            .v2_requestGGJSON(GGAPI.ServerInfo)
            .observeOn(TScheduler.Serial(.Background))
            .subscribeNext { result in
                let realm = try! Realm()
                try! realm.write {
                    result
                        .success { realm.create(ServerInfoModel.self, value: $0.object, update: true) }
                }
            }
            .addDisposableTo(disposeBag)
        
        articlesShare
            .map { articles -> [CSSearchableItem] in
                return articles.map {
                    let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                    searchableItemAttributeSet.title = $0.title
                    searchableItemAttributeSet.contentDescription = $0.articleDescription
                    let searchableItem = CSSearchableItem(uniqueIdentifier: $0.contentUrl, domainIdentifier: "article", attributeSet: searchableItemAttributeSet)
                    return searchableItem
                }
            }
            .observeOn(TScheduler.Serial(.Utility))
            .subscribeNext {
                
                let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                searchableItemAttributeSet.title = "GGGGGGGGGGGGGGGG"
                searchableItemAttributeSet.contentDescription = "GGGGGGGGGGGGGGGG"
                
                let searchableItem = CSSearchableItem(uniqueIdentifier: "nil", domainIdentifier: "article", attributeSet: searchableItemAttributeSet)
                
                CSSearchableIndex.defaultSearchableIndex()
                    .indexSearchableItems($0 + [searchableItem]) { error in
                    if let error = error {
                        Error("\(error)")
                    }
                }
            }
            .addDisposableTo(disposeBag)

    }
}
