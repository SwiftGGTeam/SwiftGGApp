//
//  ServerInfoModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import RealmSwift

class ServerInfoModel: Object {

    dynamic var appVersion: String = ""
    dynamic var categoriesVersion: String = ""
    dynamic var articlesVersion: String = ""
    dynamic var articlesSum: Int = 0
    dynamic var message: String = ""

// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
