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
    var title = ""
    var url = ""
    var offset = 0.0
    var height = 0.0
    
    func getOffset()->String! {
        return String(offset)
    }
}
