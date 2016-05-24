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
