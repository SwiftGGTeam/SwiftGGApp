//
//  Version.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation

class Version {

    static var currentVersion: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }

    static var buildVersion: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
    }
}
