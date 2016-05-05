//
//  RxDataSourceExt.swift
//  GGQ
//
//  Created by 宋宋 on 16/5/5.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxDataSources

extension String: IdentifiableType {
    public var identity: String {
        return self
    }
}

extension Int: IdentifiableType {
    public var identity: Int {
        return self
    }
}

extension NSAttributedString: IdentifiableType {
    public var identity: Int {
        return hashValue
    }
}