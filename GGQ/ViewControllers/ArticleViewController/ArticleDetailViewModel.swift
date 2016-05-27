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
    
    let isLoading = Variable(false)
    
    private let disposeBag = DisposeBag()
    
    init(articleInfo: ArticleInfoObject, provider: RxMoyaXProvider = GGProvider) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", argumentArray: [articleInfo.id])
        
        let articleObject = realm.objects(ArticleDetailModel).filter(predicate)
            .asObservable()
            .map { $0.first }
            .filterNil()
            .shareReplay(1)
        
        articleObject
            .map { $0.content }
            .observeOn(.Serial(.Background))
            .map { $0
                .stringByReplacingOccurrencesOfString("<center>", withString: "")
                .stringByReplacingOccurrencesOfString("</center>", withString: "")
                .stringByReplacingOccurrencesOfString("http://swift.gg/20", withString: "swiftgg://swift.gg/20")
            }
            .map { mdRender(markdown: $0) }
            .bindTo(contentAttributeText)
            .addDisposableTo(disposeBag)
        
        provider
            .v2_requestGGJSON(GGAPI.ArticleDetail(articleId: articleInfo.id))
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
        
    }
    
}