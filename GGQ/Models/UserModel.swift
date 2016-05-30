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
    dynamic var login: String? // Version 1002
    dynamic var avatar_url: String? // Version 1002 GitHub
    dynamic var avatar_hd: String? // Version 1002 Weibo
    dynamic var url: String? // Version 1002
    dynamic var blog: String? // Version 0
    dynamic var email: String? // Version 0
    dynamic var name: String = "" // Version 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension UserModel {
    var avatarURL: NSURL? {
        if let avatar_url = avatar_url {
            return NSURL(string: avatar_url)
        } else if let avatar_hd = avatar_hd {
            return NSURL(string: avatar_hd)
        } else {
            return nil
        }
    }
}
