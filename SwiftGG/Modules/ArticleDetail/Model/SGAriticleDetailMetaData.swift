//
//  SGAriticleDetailMetaData.swift
//  SwiftGG
//
//  Created by Perry on 16/2/1.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import RealmSwift

class SGAriticleDetailMetaData: Object {
    dynamic var id = ""
    dynamic var url = ""
    dynamic var title = ""
    dynamic var offset = 0.0
    dynamic var height = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getSGArticleDetailInfo()->SGArticleDetailInfo {
        return SGArticleDetailInfo(id: id, title: title, url: url, offset: offset, height: height)
    }
    
    func setSGArticleDetailInfo(articleDetailInfo:SGArticleDetailInfo) {
        id = articleDetailInfo.id
        url = articleDetailInfo.url
        title = articleDetailInfo.title
        offset = articleDetailInfo.offset
    }
}
