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

extension SyncService {
	/// 文章是否有更新
	var articlesUpdated: Observable<Bool> {
		return _articlesUpdated.asObservable().skip(1)
	}
	/// 分类是否有变化
	var categoriesUpdated: Observable<Bool> {
		return _categoriesUpdated.asObservable().skip(1)
	}
	/// 最新消息
	var message: Observable<String> {
		return _message.asObservable().skip(1)
	}
	/// 当前文章数量
	var articleNumber: Observable<Int> {
		return _articleNumber.asObservable().skip(1)
	}
}

class SyncService {
	static let sharedInstance = SyncService()
    
    private init() {}

	private let disposeBag = DisposeBag()

	private let _articlesUpdated = Variable(false)

	private let _categoriesUpdated = Variable(false)

	private let _message = Variable("")

	private let _articleNumber = Variable(0)
    
    private let provider = RxMoyaXProvider()
    
    func sync() {
        
        typealias Compare = (app: Object, json: JSON)
        func compare(value: String) -> Compare -> Observable<Bool> {
            return { app, json in
                if app.valueForKey(value)!.integerValue < json[value].intValue {
                    return Observable.just(true)
                } else {
                    return Observable.empty()
                }
            }
        }
        
        let realm = try! Realm()
        let app = realm.objects(ServerInfoModel).sorted("appVersion").asObservable()
            .map { $0.first }.filterNil()
        let latest = provider.request(GGAPI.ServerInfo).retry(3).gg_mapJSON()
                /// FIXME: - == 写错了
        let com = Observable.combineLatest(app, latest) { Compare(app: $0, json: $1) }.shareReplay(1)
        
        com.flatMap(compare("categoriesVersion"))
            .bindTo(_categoriesUpdated)
            .addDisposableTo(disposeBag)
        
        com.flatMap(compare("articlesVersion"))
            .bindTo(_articlesUpdated)
            .addDisposableTo(disposeBag)
        
    }
}