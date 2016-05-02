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

    let disposeBag = DisposeBag()

    private var realmNotificationToken: NotificationToken?

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
        // TODO: - 在这里加判断，是否需要更新 Model
            .gg_storeArray(ArticleInfoObject)
            .shareReplay(1)

        [loadMoreRequest.map { _ in true }, loadMoreResult.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isLoading)
            .addDisposableTo(disposeBag)

        loadMoreResult
            .observeOn(.Main)
            .subscribeNext { [unowned self] result in
//                self.currentPage.value += 1
//                self.elements.value = result
        }
            .addDisposableTo(disposeBag)
    }
}
