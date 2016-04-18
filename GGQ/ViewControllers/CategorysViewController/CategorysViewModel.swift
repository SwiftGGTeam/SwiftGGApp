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
import RxOptional

final class CategorysViewModel {

    let elements = Variable<[CategoryObject]>([])

    let isLoading = Variable(true)
    
    private var realmNotificationToken: NotificationToken?

    private let disposeBag = DisposeBag()

    init() {

        if let realm = try? Realm() {
            let list = realm.objects(CategoryObject.self)
            realmNotificationToken = list.realm?.addNotificationBlock { [weak self] notification, realm in
                if let strongSelf = self {
                    strongSelf.elements.value = list.map { $0 }
                    strongSelf.isLoading.value = false
                }
            }
        }

        GGProvider.request(GGAPI.CategoryList)
            .gg_storeArray(CategoryObject).debug("储存完毕")
            .subscribeNext {
                
            }.addDisposableTo(disposeBag)
//            .flatMapLatest { Realm.rx_objects(CategoryObject) }.debug("读取结果")
//            .map { $0.map { $0 } }.debug("转换结果")
//            .observeOn(.Main)
//            .bindTo(elements).addDisposableTo(disposeBag)
    }
}
