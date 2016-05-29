//
//  SearchViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift

enum SearchResultType {
    case All(title: String, content: String, url: NSURL)
    case Title(title: String, url: NSURL)
    case Content(content: String, url: NSURL)
}

extension SearchResultType {
    var openURL: NSURL {
        switch self {
        case .All(let info):
            return info.url
        case .Content(let detail):
            return detail.url
        case .Title(let info):
            return info.url
        }
    }
}

enum SearchType: Int {
    case All = 0
    case Title = 1
    case Content = 2
}

final class SearchViewModel {

	let elements = Variable<[SearchResultType]>([])

	private let disposeBag = DisposeBag()

    init(search: (text: Observable<String>, type: Observable<SearchType>)) {
        
        let realm = try! Realm()
        
        Observable.combineLatest(search.text, search.type) { (text: $0, type: $1) }
            .subscribeNext { text, type in
                switch type {
                case .All:
                    let predicate = NSPredicate(format: "title CONTAINS %@ or articleDescription CONTAINS %@", text, text)
                    let list = realm.objects(ArticleInfoObject.self).filter(predicate)
                    self.elements.value = list.map { SearchResultType.All(title: $0.title, content: $0.articleDescription, url: $0.convertURL()) }
                case .Content:
                    let predicate = NSPredicate(format: "content CONTAINS %@", text)
                    let list = realm.objects(ArticleDetailModel.self).filter(predicate)
                    self.elements.value = list.map { SearchResultType.Content(content: $0.content, url: $0.convertURL()) }
                case .Title:
                    let predicate = NSPredicate(format: "title CONTAINS %@", text)
                    let list = realm.objects(ArticleInfoObject.self).filter(predicate)
                    self.elements.value = list.map { SearchResultType.Title(title: $0.title, url: $0.convertURL()) }
                }
            }
            .addDisposableTo(disposeBag)

	}
}
