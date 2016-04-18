//
//  ArticleInfoModel.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Realm
import RealmSwift

class ArticleInfoObject: Object {

	dynamic var id: Int = 0
	dynamic var typeId: Int = 0
	dynamic var typeName: String = ""
	dynamic var coverUrl: String = ""
	dynamic var authoerImageUrl: String = ""
	dynamic var submitDate: String = ""
	dynamic var title: String = ""
	dynamic var articleUrl: String = ""
	dynamic var translator: String = ""
	dynamic var articleDescription: String = ""
	dynamic var starsNumber: Int = 0
	dynamic var commentsNumber: Int = 0
	dynamic var updateDate: String = ""

	override static func primaryKey() -> String? {
		return "id"
	}
}

extension ArticleInfoObject: Hashable { }

func == (lhs: ArticleInfoObject, rhs: ArticleInfoObject) -> Bool {
	return lhs.id == rhs.id
}

struct ArticleInfoModel {

	let id: Int
	let typeId: Int
	let typeName: String
	let coverUrl: String
	let authoerImageUrl: String
	let submitDate: String
	let title: String
	let articleUrl: String
	let translator: String
	let articleDescription: String
	let starsNumber: Int
	let commentsNumber: Int
	let updateDate: String
}

//extension ArticleInfoModel: Hashable { }
//
//func == (lhs: ArticleInfoModel, rhs: ArticleInfoModel) -> Bool {
//	return lhs.id == rhs.id
//}