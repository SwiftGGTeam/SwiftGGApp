//
//  CategoryObject.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/14.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import RealmSwift

/// 真实的分类 Model
class CategoryObject: Object {

	dynamic var id = 0
	dynamic var name = ""
	dynamic var coverUrl = ""
	dynamic var sum = 0

	override static func primaryKey() -> String? {
		return "id"
	}
}
