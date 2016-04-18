//
//  CategoryViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Realm
import RealmSwift
import RxOptional

final class CategoryViewModel {

	let elements = Variable<[ArticleInfoObject]>([])

	let isLoading = Variable(true)

	private let disposeBag = DisposeBag()

	init(category: CategoryObject) {

		// TODO: - 这里还没做呢
		Realm.rx_objects(ArticleInfoObject)
			.map { $0.map { $0 } }.bindTo(elements).addDisposableTo(disposeBag)
        
//        if let 
	}
}
