//
//  HomeViewCellModel.swift
//  SwiftGG
//
//  Created by Jack on 16/1/24.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import Foundation

class HomeViewCellModel {
    var title: String!
    var description: String!
    var category: String!
    var translator: String!
    var commentCount: Int!
    var likeCount: Int!
    var avatarUrl: String!
    var author: String!
    var date: String!
    
    init(dict: [String: AnyObject]) {
        title = dict["title"] as! String
        description = dict["description"] as! String
        category = dict["category"] as! String
        translator = dict["translator"] as! String
        commentCount = dict["commentCount"] as! Int
        likeCount = dict["likeCount"] as! Int
        avatarUrl = dict["avatarUrl"] as! String
        author = dict["author"] as! String
        date = dict["date"] as! String

    }
}