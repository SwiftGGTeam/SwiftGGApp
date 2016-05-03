//
//  GGSwiftWeeklyService.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/23.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import MoyaX

typealias Email = String

enum SwiftWeekly {
    case Subscribe(email: Email)
}

extension SwiftWeekly: Target {
    
    var baseURL: NSURL { return NSURL(string: "http://ggchecker.githuber.info")! }
    
    var path: String {
        switch self {
        case .Subscribe(let email):
            return "/addemail/" + email
        }
    }
    
    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }
    
    var parameters: [String: AnyObject] {
        return [:]
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameterEncoding: ParameterEncoding {
        return .URL
    }
    
    var sampleData: NSData {
        switch self {
        case .Subscribe:
            return "{\"success:\"\"success\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}