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

	init(searchText: Driver<Easy<String>>) {

		searchText
			.gg_flatMap { text -> Driver<Easy<Results<ArticleInfoObject>>> in
				do {
					let realm = try Realm()
					let predicate = NSPredicate(format: "title CONTAINS %@", text)
					let list = realm.objects(ArticleInfoObject.self).filter(predicate)
//					return Driver.gg_just(EasyResult.Success(list))
                    return Driver.just(Easy(result: EasyResult.Success(list)))
				} catch {
//					Error("\(error)")
                    return Driver.just(Easy(result: EasyResult.Failure(error)))
				}
            }
			.gg_map { EasyResult.Success($0.map { $0 }) }
            .gg_drive(elements)
            .addDisposableTo(disposeBag)
	}
}
