//
//  GGKeychainService.swift
//  GGQ
//
//  Created by 宋宋 on 5/2/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import Locksmith

typealias Token = String

enum TokenType {
    case GitHub
    case Weibo
}

extension TokenType {
    var userAccount: String {
        switch self {
        case .GitHub:
            return "gg.swift.github"
        case .Weibo:
            return "gg.swift.weibo"
        }
    }
}

class KeychainService {
    
    static func save(type: TokenType, token: Token) {
        try! Locksmith.updateData(["token": token], forUserAccount: type.userAccount)
    }
    
    static func read(type: TokenType) -> Token? {
        let data = Locksmith.loadDataForUserAccount(type.userAccount)
        return data?["token"] as? Token
    }
    
    static func exist(type: TokenType) -> Bool {
        return Locksmith.loadDataForUserAccount(type.userAccount) != nil
    }
    
    static func delete(type: TokenType) throws {
         try Locksmith.deleteDataForUserAccount(type.userAccount)
    }
    
}

