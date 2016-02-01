//
//  SGArticleDetailInfo.swift
//  MBArticleViewForSwiftGGApp
//
//  Created by Perry on 16/1/25.
//  Copyright © 2016年 MmoaaY. All rights reserved.
//

import Foundation

struct SGArticleDetailInfo {
    var id:String = ""
    var url = ""
    var title = ""
    var offset = 0.0
    var height = 0.0
    
    func getOffset()->String! {
        return String(offset)
    }
    
    init(id:String, title:String, url:String, offset:Double, height:Double) {
        self.id = id
        self.url = url
        self.title = title
        self.offset = offset
        self.height = height
    }
}
