//
//  GGSyncService.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/19.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa
import MoyaX
import RealmSwift
import SwiftyJSON

class SyncService {
    
    static func sync() -> Observable<Void> {
        return GGProvider
            .request(GGAPI.ServerInfo)
            .gg_storeObject(ServerInfoModel)
            .shareReplay(1)
    }
    
    static func articlesNumber(realm: Realm) -> Observable<Int> {
        return realm.objects(ServerInfoModel)
            .asObservable()
            .map { $0.first?.articlesSum }
            .filterNil()
            .shareReplay(1)
    }
}