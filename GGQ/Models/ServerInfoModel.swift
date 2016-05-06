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

    dynamic var appVersion: String = "" // Version 0
    dynamic var categoriesVersion: String = "" // Version 0
    dynamic var articlesVersion: String = "" // Version 0
    dynamic var articlesSum: Int = 0 // Version 0
    dynamic var message: String = "" // Version 0

    override static func primaryKey() -> String? {
        return "appVersion"
    }
    
}
