//
//  UserSingleton.swift
//  SwiftGG
//
//  Created by TangJR on 2/28/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import Foundation

class UserSingleton {
    static let shareInstence = UserSingleton()
    private init() {}
    
    var userModel: UserModel?
}