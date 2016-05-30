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

    dynamic var id: Int = 0 // Version 0
    dynamic var typeId: Int = 0 // Version 0
    dynamic var typeName: String = "" // Version 0
//    dynamic var tags: RLMArray = RLMArray(objectClassName: "String")
    dynamic var coverUrl: String = "" // Version 0
    dynamic var contentUrl: String = "" // Version 0
    dynamic var translator: String = "" // Version 0
    dynamic var proofreader: String = "" // Version 0
    dynamic var finalization: String = "" // Version 0
    dynamic var author: String = "" // Version 0
    dynamic var authorImageUrl: String = "" // Version 0
    dynamic var originalDate: String = "" // Version 0
    dynamic var originalUrl: String = "" // Version 0
//    dynamic var description: String = ""
    dynamic var clickedNumber: Int = 0 // Version 0
    dynamic var submitDate: String = "" // Version 0
    dynamic var starsNumber: Int = 0 // Version 0
    dynamic var commentsNumber: Int = 0 // Version 0
    dynamic var content: String = "" // Version 0
//    dynamic var comments: RLMArray = RLMArray(objectClassName: "String")
    dynamic var updateDate: String = "" // Version 0
//    dynamic var cacheData: NSData? // Version 0
//    let pagerTotal = RealmOptional<Int>() // Version 0
//    let currentPage = RealmOptional<Int>() // Version 0
//    dynamic var

    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension ArticleDetailModel {
    
    func convertStr() -> String {
        return contentUrl.stringByReplacingOccurrencesOfString("http://", withString: "swiftgg://")
    }
    
    func convertURL() -> NSURL {
        let urlStr = contentUrl.stringByReplacingOccurrencesOfString("http://", withString: "swiftgg://")
        return NSURL(string: urlStr)!
    }
}
