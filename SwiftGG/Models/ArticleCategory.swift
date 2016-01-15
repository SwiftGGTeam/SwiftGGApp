//
//  ArticleCategory.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/1/15.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import Foundation

class ArticleCategory {
    var id: String!
    var name: String!
    var coverUrl: String!
    var articlesCount: Int!
    
    init(dict: [String: AnyObject]) {
        id = dict["id"] as! String
        name = dict["name"] as! String
        coverUrl = dict["coverUrl"] as! String
        articlesCount = dict["sum"] as! Int
    }
}
