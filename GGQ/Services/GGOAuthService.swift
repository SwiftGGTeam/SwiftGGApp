//
//  GGOAuthService.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/21.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import MoyaX

protocol OAuthServiceType {
    
    static var client_id: String{get}
    static var client_secret: String{get}
    static var callback_url: String{get}
    static var authorize_url: String{get}
    static var accessToken_url: String{get}

}

func generateStateWithLength (len : Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomString : NSMutableString = NSMutableString(capacity: len)
    for _ in 0..<len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    return randomString as String
}

class OAuthService {
    
}


#if DEBUG
//let GGProvider = RxMoyaXProvider(middlewares: [LoggerMiddleware()])
#else
//let GGProvider = RxMoyaXProvider()
#endif

enum GitHubOAuthAPI {
    case Authorize
    case AccessToken(code: String)
}

extension GitHubOAuthAPI: Target {
    private static let client_id = "742321c546e7cc39e53c"
    private static let client_secret = "dfc142761f571be5abd0368dfd6e7864fd56c943"
    private static let redirect_uri = "swiftgg://swift.gg/oauth/github"
    private static let authorize_path = "https://github.com/login/oauth/authorize"
    private static let accessToken_path = "https://github.com/login/oauth/access_token"
    private static let scope = "user,repo"
    private static let response_type = "code"
    private static let grant_type = "authorization_code"
    
    var baseURL: NSURL { return NSURL(string: "https://github.com")! }
    
    var path: String {
        switch self {
        case .Authorize:
            return "/login/oauth/authorize"
        case .AccessToken:
            return "/login/oauth/access_token"
        }
    }
    
    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }
    
    
    var parameters: [String: AnyObject] {
        switch self {
        case .Authorize:
            return ["client_id": GitHubOAuthAPI.client_id,
                    "redirect_uri": GitHubOAuthAPI.redirect_uri,
                    "scope": GitHubOAuthAPI.scope,
                    "response_type": GitHubOAuthAPI.response_type,
                    "state": generateStateWithLength(20)]
            
        case .AccessToken(let code):
            return ["client_id": GitHubOAuthAPI.client_id,
                    "client_secret": GitHubOAuthAPI.client_secret,
                    "grant_type": GitHubOAuthAPI.grant_type,
                    "redirect_uri": GitHubOAuthAPI.redirect_uri,
                    "code": code]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .Authorize:
            return .GET
        case .AccessToken:
            return .POST
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return .URL // GET
    }
    
    var sampleData: NSData {
        fatalError("都比你忘了写 Mock")
    }
}

enum GitHubAPI {
    case User
}

extension GitHubAPI: Target {
    
    var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case User:
            return "/user"
        }
    }
    
    var headerFields: [String: String] {
        var header = ["Accept": "application/json"]
        if let token = KeychainService.read(.GitHub) {
            header["Authorization"] = "token \(token)"
        }
        return header
    }
    
    
    var parameters: [String: AnyObject] {
        return [:]
    }
    
    var method: HTTPMethod {
        switch self {
        case .User:
            return .GET
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return .URL // GET
    }
    
    var sampleData: NSData {
        fatalError("都比你忘了写 Mock")
    }
}