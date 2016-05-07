//
//  Routerable.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/22.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Routerable {
    var routerIdentifier: String{get}
    
    func post(url: NSURL, sender: JSON?)
    
    func get(url: NSURL, sender: JSON?)
}

extension Routerable {
    func post(url: NSURL, sender: JSON?) {
        Warning("未实现 POST")
    }
    
    func get(url: NSURL, sender: JSON?) {
        Warning("未实现 GET")
    }
}