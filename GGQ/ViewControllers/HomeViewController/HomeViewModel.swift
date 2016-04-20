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

final class HomeViewModel {

    let elements = Variable<[ArticleInfoObject]>([])

    let hasNextPage = Variable(true)

    let currentPage = Variable(1)

    let isLoading = Variable(false)

    let disposeBag = DisposeBag()

    private var realmNotificationToken: NotificationToken?

    init(loadMoreTrigger: Observable<Void>) {

        if let realm = try? Realm() {
            let list = realm.objects(ArticleInfoObject)
            realmNotificationToken = list.realm?.addNotificationBlock { [weak self] notification, realm in
                if let strongSelf = self {
                    strongSelf.elements.value = list.map { $0 }
                    strongSelf.isLoading.value = false
                    strongSelf.currentPage.value = strongSelf.elements.value.count / GGConfig.Home.pageSize + 1
                }
            }
        }

        let loadMoreRequest = loadMoreTrigger.withLatestFrom(currentPage.asObservable()).shareReplay(1)

        let loadMoreResult = loadMoreRequest
            .flatMapLatest { GGProvider.request(GGAPI.Articles(pageIndex: $0, pageSize: GGConfig.Home.pageSize)) }
        // TODO: - 在这里加判断，是否需要更新 Model
            .gg_storeArray(ArticleInfoObject)
            .flatMapLatest { Realm.rx_objects(ArticleInfoObject) }
            .map { $0.map { $0 } }
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
