//
//  SettingViewModel.swift
//  GGQ
//
//  Created by 宋宋 on 5/6/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class SettingViewModel {
    
    let articlesNumber: Observable<Int>
    
    let offlineArticlesNumber: Observable<Int>
    
    init() {
        let realm = try! Realm()
        let info = realm.objects(ArticleDetailModel)
            .asObservable()
            .shareReplay(1)
        
        offlineArticlesNumber = info.map { $0.count }
        
        articlesNumber = SyncService.sharedInstance.articleNumber
        
        SyncService.sharedInstance.sync()
    }
    
}
