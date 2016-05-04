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
    
    dynamic var id: Int = 0
    dynamic var login: String = ""
    dynamic var avatar_url: String = ""
    dynamic var url: String = ""
    dynamic var blog: String?
    dynamic var email: String?
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
