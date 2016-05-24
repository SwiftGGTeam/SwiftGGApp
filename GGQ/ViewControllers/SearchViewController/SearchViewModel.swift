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

final class SearchViewModel {

	let elements = Variable<[ArticleInfoObject]>([])

	private let disposeBag = DisposeBag()

	init(searchText: Observable<String>) {

		searchText
			.flatMap { text -> Observable<[ArticleInfoObject]> in
				do {
					let realm = try Realm()
					let predicate = NSPredicate(format: "title CONTAINS %@", text)
                    let list = realm.objects(ArticleInfoObject.self).filter(predicate).map { $0 }
                    return Observable.just(list)
				} catch {
//                    return Driver.just(Easy(result: EasyResult.Failure(error)))
                    fatalError()
				}
            }
            .bindTo(elements)
            .addDisposableTo(disposeBag)
	}
}
