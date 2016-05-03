//
//  RxDriver+GG.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/18.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa

enum GGResult<T> {
    case Result(T)
    case Error(ErrorType)
}

extension Observable {
    func asResultDriver() -> Driver<GGResult<E>> {
        return map { GGResult.Result($0) }
            .asDriver { Driver.just(GGResult.Error($0)) }
    }
}
