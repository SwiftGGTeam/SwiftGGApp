//
//  UserModel.swift
//  SwiftGG
//
//  Created by TangJR on 2/3/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import Foundation

class UserModel {
    var userId: String!
    
    init(jsonDict: [String: AnyObject]) {
        userId = jsonDict["userId"] as! String
    }
}