//
//  ArticleDetailModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import RealmSwift
/// 文章详情 *。*
class ArticleDetailModel: Object {

    dynamic var id: Int = 0
    dynamic var typeId: Int = 0
    dynamic var typeName: String = ""
//    dynamic var tags: RLMArray = RLMArray(objectClassName: "String")
    dynamic var coverUrl: String = ""
    dynamic var contentUrl: String = ""
    dynamic var translator: String = ""
    dynamic var proofreader: String = ""
    dynamic var finalization: String = ""
    dynamic var author: String = ""
    dynamic var authorImageUrl: String = ""
    dynamic var originalDate: String = ""
    dynamic var originalUrl: String = ""
//    dynamic var description: String = ""
    dynamic var clickedNumber: Int = 0
    dynamic var submitDate: String = ""
    dynamic var starsNumber: Int = 0
    dynamic var commentsNumber: Int = 0
    dynamic var content: String = ""
//    dynamic var comments: RLMArray = RLMArray(objectClassName: "String")
    dynamic var updateDate: String = "" // 通过 updateDate 判断是否是最新版本文章
    dynamic var cacheData: NSData?
    let pagerTotal = RealmOptional<Int>()
    let currentPage = RealmOptional<Int>()
//    dynamic var 

    override static func primaryKey() -> String? {
        return "id"
    }
    
}
