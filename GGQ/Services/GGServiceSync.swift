//
//  GGServiceSync.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/19.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa

extension ServiceSync {
    /// 文章是否有更新
    var articlesUpdated: Observable<Bool> {
        return _articlesUpdated.asObservable().skip(1)
    }
    /// 分类是否有变化
    var categoriesUpdated: Observable<Bool> {
        return _categoriesUpdated.asObservable().skip(1)
    }
    ///  最新消息
    var message: Observable<String> {
        return _message.asObservable().skip(1)
    }
    /// 当前文章数量
    var articleNumber: Observable<Int> {
        return _articleNumber.asObservable().skip(1)
    }
    
}

class ServiceSync {
    
    static let sharedInstance = ServiceSync()
    
    private init() {}
    
    private let _articlesUpdated = Variable(false)
    
    private let _categoriesUpdated = Variable(false)
    
    private let _message = Variable("")
    
    private let _articleNumber = Variable(0)
}