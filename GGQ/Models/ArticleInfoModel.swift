//
//  ArticleInfoModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class ArticleInfoObject: Object {

	dynamic var id: Int = 0 // Version 0
	dynamic var typeId: Int = 0 // Version 0
	dynamic var typeName: String = "" // Version 0
	dynamic var coverUrl: String = "" // Version
	dynamic var authoerImageUrl: String = "" // Version 0
	dynamic var submitDate: String = "" // Version 0
	dynamic var title: String = "" // Version 0
    dynamic var contentUrl: String = "" // Version 1000
	dynamic var articleUrl: String = "" // Version 0
	dynamic var translator: String = "" // Version 0
	dynamic var articleDescription: String = "" // Version 0
	dynamic var starsNumber: Int = 0 // Version 0
	dynamic var commentsNumber: Int = 0 // Version 0
	dynamic var updateDate: String = "" // Version 0
    /// 稍后阅读
    let readItLater = RealmOptional<Bool>() // Version 1000
    /// 是否从首页加载
    let loadFromHome = RealmOptional<Bool>() // Version 1000
    /// 是否已经读完
    let hasBeenRead = RealmOptional<Bool>() // Version 1000
    /// 已收藏
    let isFavorite = RealmOptional<Bool>() // Version 1000
    /// 是否在读
    let isReading = RealmOptional<Bool>() // Version 1000
    
    let readOffset = RealmOptional<Float>() // Version 1003
    
	override static func primaryKey() -> String? {
		return "id"
	}
}

extension ArticleInfoObject {
    
    func convertStr() -> String {
        return contentUrl.stringByReplacingOccurrencesOfString("http://", withString: "swiftgg://")
    }
    
    func convertURL() -> NSURL {
        let urlStr = contentUrl.stringByReplacingOccurrencesOfString("http://", withString: "swiftgg://")
        return NSURL(string: urlStr)!
    }
    
    func praseMDArticleDescription() -> String {
        return mdRender(markdown: articleDescription).string
    }
}

extension ArticleInfoObject {
    var readStatus: String {
        if hasBeenRead.value == true {
            return "已读完"
        } else if isReading.value == true {
            return "在阅读"
        } else {
            return "未阅读"
        }
    }
}

extension ArticleInfoObject: IdentifiableType {
    var identity: Int {
        return id
    }
}