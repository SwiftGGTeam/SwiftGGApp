//
//  RxObject.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/19.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift

extension Object {
    var rx_didUpdate: Observable<Object?> {
        return Observable.create { observer in
            var realmNotificationToken: NotificationToken?
            if let realm = self.realm {
                realmNotificationToken = realm.addNotificationBlock { [weak self] notification, realm in
                    observer.onNext(self)
                }
            } else {
                observer.onCompleted()
            }
            
            return AnonymousDisposable {
                realmNotificationToken?.stop()
            }
            
        }
    }
}
