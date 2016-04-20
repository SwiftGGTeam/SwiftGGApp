//
//  CategorysViewModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/12.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift

final class CategorysViewModel {
	let elements = Variable<[CategoryObject]>([])

	let errorMessage = Variable<ErrorType?>(nil)

	let isRefreshing = Variable(true)

	private var realmNotificationToken: NotificationToken?

	private let disposeBag = DisposeBag()

	init(refreshTrigger: Driver<Void>) {
		if let realm = try? Realm() {
			let list = realm.objects(CategoryObject.self)
			elements.value = list.map { $0 }
			realm
				.rx_notification
				.withLatestFrom(Observable.just(list))
				.map { $0.map { $0 } }
				.bindTo(elements)
				.addDisposableTo(disposeBag)
		}

		let refreshResult = [refreshTrigger, Driver.just(())].toObservable()
		// TODO: - 换一个合适的位置
		.merge()
			.asDriver(onErrorJustReturn: ())
			.flatMapLatest { GGProvider.request(GGAPI.CategoryList)
					.gg_storeArray(CategoryObject)
					.asResultDriver() }

		refreshResult
			.driveNext { [unowned self] result in
				switch result {
				case .Result:
					break
//                    self.isRefreshing.value = false
				case .Error(let error):
//                    self.isRefreshing.value = false
					self.errorMessage.value = error
				}
		}
			.addDisposableTo(disposeBag)
		[refreshTrigger.map { _ in true }, refreshResult.map { _ in false }].toObservable().merge().bindTo(isRefreshing).addDisposableTo(disposeBag)
	}
}
