//
//  GGWebProvider.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import MoyaX

let GGWebProvider = RxMoyaXProvider()
enum GGWebAPI {
    case Page(Int)
    case ListPath(String)
    case Article(path: String)
}

extension GGWebAPI: Target {

    var baseURL: NSURL { return NSURL(string: "https://raw.githubusercontent.com/DianQK/Biu/master")! }

    var path: String {
        switch self {
        case .Page(let page):
            return "/api/list/list-\(page).json"
        case .ListPath(let path):
            return path
        case .Article(let path):
            return path
        }
    }

    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }

    var parameters: [String: AnyObject]? {
        return nil
    }

    var method: HTTPMethod {
        return .GET
    }
    // TODO: - 添加参数
    var sampleData: NSData {
        return stubbedResponse("")
    }
}
