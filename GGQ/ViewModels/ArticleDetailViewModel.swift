//
//  ArticleDetailViewModel.swift
//  GGQ
//
//  Created by 宋宋 on 5/27/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import SwiftyJSON

class ArticleDetailViewModel {
    
    let contentAttributeText = Variable(NSAttributedString(string: ""))
    
    let isLoading = Variable(true)
    
    private let disposeBag = DisposeBag()
    
    init(articleInfo: ArticleInfoObject, provider: RxMoyaXProvider = GGProvider) {
        
        contentAttributeText.asObservable().skip(1).map { _ in false }.bindTo(isLoading).addDisposableTo(disposeBag)
        
        let articleInfoID = articleInfo.id
        
        if let cache = articleCache[articleInfoID] as? NSAttributedString {
            contentAttributeText.value = cache
            return
        }
//        else if let content = GGStoreService.getArticleContent(articleInfoID) {
//            contentAttributeText.value = content
//            articleCache[articleInfoID] = content
//            return
//        }
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", argumentArray: [articleInfoID])

        let articleObject = realm.objects(ArticleDetailModel).filter(predicate)
            .asObservable()
            .map { $0.first }
            .filterNil()
            .shareReplay(1)
        
        articleObject
            .map { "# " + articleInfo.title + "\n" + $0.content }
            .observeOn(.Serial(.Background))
            .map { $0
                .stringByReplacingOccurrencesOfString("<center>", withString: "")
                .stringByReplacingOccurrencesOfString("</center>", withString: "")
                .stringByReplacingOccurrencesOfString("http://swift.gg/20", withString: "swiftgg://swift.gg/20")
            }
            .map { mdRender(markdown: $0) }
            .bindTo(contentAttributeText)
            .addDisposableTo(disposeBag)
        
        let request = provider
            .v2_requestGGJSON(GGAPI.ArticleDetail(articleId: articleInfoID))
            .shareReplay(1)

        request
            .subscribeNext { result in
                switch result {
                case .Success(let json):
                    let realm = try! Realm()
                    try! realm.write {
                        realm.create(ArticleDetailModel.self, value: json.object, update: true)
                    }
                case .Failure(let error):
                    Error("\(error)")
                }
            }
            .addDisposableTo(disposeBag)
        
        contentAttributeText.asObservable().skip(1)
            .subscribeNext {
                articleCache[articleInfoID] = $0
//                GGStoreService.storeArticleContent(articleInfoID, content: $0)
            }
            .addDisposableTo(disposeBag)

//        [contentAttributeText.asObservable().skip(1).map { _ in false }, Observable.just(true)]
//            .toObservable()
//            .merge()
        
    }

}