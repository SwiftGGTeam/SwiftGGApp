//
//  Observable+ObjectMapper.swift
//  SwiftGGQing
//
//  Created by DianQK on 16/2/4.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RealmSwift
import MoyaX
import SwiftyJSON
// TODO: - 错误处理
extension ObservableType where E == Response {
    
    func mapJSON() -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            let json = JSON(data: response.data)
            if let error = json.error {
                return Observable.error(error)
            }
            if json.type == .Null {
                return Observable.empty()
            }
            return Observable.just(json)
        }
    }

    func gg_mapJSON() -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            let json = JSON(data: response.data)
            if let error = json.error {
                return Observable.error(error)
            }
            if json.type == .Null {
                return Observable.empty()
            }
            return Observable.just(json["data"])
        }
    }

    func gg_storeArray<T: Object>(type: T.Type) -> Observable<Void> {
        return flatMap { response -> Observable<Void> in
            let json = JSON(data: response.data)
            if let error = json.error {
                return Observable.error(error)
            }
            if json.type == .Null {
                return Observable.empty()
            }
            guard let data = json["data"].arrayObject else { return Observable.empty() }
            let update = T.primaryKey() != nil
            return Realm.rx_create(type, values: data, update: update)
        }
    }

    func gg_storeObject<T: Object>(type: T.Type) -> Observable<Void> {
        return flatMap { response -> Observable<Void> in
            let json = JSON(data: response.data)
            if let error = json.error {
                return Observable.error(error)
            }
            if json.type == .Null {
                return Observable.empty()
            }
            let update = T.primaryKey() != nil
            return Realm.rx_create(type, value: json["data"].object, update: update)
        }
    }
}

//{
//    "ret" : -1206,
//    "errMsg" : "文章id为空"
//}