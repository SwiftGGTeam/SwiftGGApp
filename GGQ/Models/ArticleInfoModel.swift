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
    let readItLater = RealmOptional<Bool>() // Version 1000

	override static func primaryKey() -> String? {
		return "id"
	}
}

extension ArticleInfoObject: IdentifiableType {
    var identity: Int {
        return id
    }
}