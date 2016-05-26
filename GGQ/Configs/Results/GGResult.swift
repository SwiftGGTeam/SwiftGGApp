//
//  GGResult.swift
//  GGQ
//
//  Created by 宋宋 on 5/24/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation

enum GGResult<T> {
    case Success(T)
    case Failure(ErrorType)
}

extension GGResult {
    
    var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    func success(@noescape callback: T -> Void) {
        switch self {
        case .Success(let data):
            callback(data)
        case .Failure(let error):
            Error("\(error)")
        }
    }
}

struct GGError {
    enum JSON: ErrorType {
        case Null
        case NoData
        
        var _code: Int {
            switch self {
            case .Null:
                return 10100
            case .NoData:
                return 10101
            }
        }
    }
    
    enum Authorize: ErrorType {
        case Unknown
        
        var _code: Int {
            switch self {
            case .Unknown:
                return 10200
            }
        }
    }
}




