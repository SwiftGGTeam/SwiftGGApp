//
//  SGArticleDetailInfo.swift
//  MBArticleViewForSwiftGGApp
//
//  Created by Perry on 16/1/25.
//  Copyright © 2016年 MmoaaY. All rights reserved.
//

import Foundation

struct SGArticleDetailInfo {
    var url:String!
    var title:String!
    
    init(title:String, url:String) {
        self.url = url
        self.title = title
    }
}
