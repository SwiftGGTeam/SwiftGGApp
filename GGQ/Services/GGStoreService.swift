//
//  GGStoreService.swift
//  GGQ
//
//  Created by 宋宋 on 5/29/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation


class GGStoreService {

    static var directory: String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths[0] as String
    }
    
    static func storeArticleContent(contentID: Int, content: NSAttributedString) {
        Warning(directory)
        NSKeyedArchiver.archiveRootObject(content, toFile: directory + "/\(contentID)")
    }
    
    static func getArticleContent(contentID: Int) -> NSAttributedString? {
        Warning(directory)
        return  NSKeyedUnarchiver.unarchiveObjectWithFile(directory + "/\(contentID)") as? NSMutableAttributedString
    }
    
}