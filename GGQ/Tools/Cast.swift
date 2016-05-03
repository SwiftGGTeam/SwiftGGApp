//
//  Cast.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/14.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation

func castOrFatalError<T>(value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(value) to \(T.self)")
    }
    return result
}

func castOrFatalError<T>(value: AnyObject!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(value) to \(T.self)")
    }
    return result
}

extension NSObject {

    func gg_castOrFatalError<T>(type: T.Type) -> T {
        guard let result = self as? T else {
            fatalError("Failure converting from \(self) to \(T.self)")
        }
        return result
    }
}
