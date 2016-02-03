//
//  SwiftGGAPI.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/1/15.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import Foundation
import Moya

enum SGError: String, ErrorType {
    case TimeOut = "请求超时"
    case Failure = "请求失败"
}

let endpointClosure = { (target: SwiftGGAPI) -> Endpoint<SwiftGGAPI> in
    let endpoint: Endpoint<SwiftGGAPI> = Endpoint<SwiftGGAPI>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: .JSON)
    return endpoint
}

let stubClosure = { (target: SwiftGGAPI) -> StubBehavior in
    return .Never
}

let SwiftGGProvider = MoyaProvider<SwiftGGAPI>(endpointClosure: endpointClosure, stubClosure: stubClosure )

enum SwiftGGAPI {
    case CategoryListings
    case Login(String, String)
    case Register(String, String)
}

extension SwiftGGAPI: TargetType {
    var base: String { return "http://123.57.250.194/" }
    var baseURL: NSURL { return NSURL(string: base)! }
    
    var path: String {
        switch self {
        case .CategoryListings:
            return "v1/article/getCategoryList"
        case .Login:
            return "v1/user/userLogin"
        case .Register:
            return "v1/user/userRegister"
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Login(let username, let password):
            return ["userName": username, "password": password]
        case .Register(let username, let password):
            return ["userName": username, "password": password]
        default:
            return nil
        }
    }
    
    var method: Moya.Method {
        return .POST
    }
    
    var sampleData: NSData {
        switch self {
        case .CategoryListings:
            return stubbedResponse("CategoryList")
        case .Login:
            return stubbedResponse("Login")
        case .Register:
            return stubbedResponse("Register")
        }
    }
}

// MARK: - Provider support
func stubbedResponse(filename: String) -> NSData! {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource(filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}