//
//  UserModel.swift
//  GGQ
//
//  Created by 宋宋 on 5/1/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    
    dynamic var id: Int = 0 // Version 0
    dynamic var login: String = "" // Version 0
    dynamic var avatar_url: String = "" // Version 0
    dynamic var url: String = "" // Version 0
    dynamic var blog: String? // Version 0
    dynamic var email: String? // Version 0
    dynamic var name: String = "" // Version 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
