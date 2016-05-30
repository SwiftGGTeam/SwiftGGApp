//
//  GGOAuthService.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/21.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import MoyaX

class GGOAuthService {
    
    enum OAuthType {
        case Weibo(appID: String, appKey: String, redirectURL: String)
    }
    
    class func oauth(type: OAuthType, scope: String? = nil) {

        switch type {
        case let .Weibo(appID, appKey, redirectURL):
            let scope = scope ?? "all"
            let uuIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil))
            let authData = [
                ["transferObject": NSKeyedArchiver.archivedDataWithRootObject(["__class": "WBAuthorizeRequest", "redirectURI": redirectURL, "requestID":uuIDString, "scope": scope])
                ],
                ["userInfo": NSKeyedArchiver.archivedDataWithRootObject(["mykey": "as you like", "SSO_From": "SendMessageToWeiboViewController"])],
                ["app": NSKeyedArchiver.archivedDataWithRootObject(["appKey": appID, "bundleID": NSBundle.mainBundle().monkeyking_bundleID ?? "", "name": NSBundle.mainBundle().monkeyking_displayName ?? ""])]
            ]
            
            UIPasteboard.generalPasteboard().items = authData
            let url = NSURL(string: "weibosdk://request?id=\(uuIDString)&sdkversion=003013000")!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
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

enum GitHubOAuthAPI {
    case Authorize
    case AccessToken(code: String)
}

extension GitHubOAuthAPI: Target {
    private static let client_id = GGConfig.OAuth.GitHub.client_id
    private static let client_secret = GGConfig.OAuth.GitHub.client_secret
    private static let redirect_uri = GGConfig.OAuth.GitHub.callback_url
//    private static let authorize_path = GGConfig.OAuth.GitHub.authorize_url
//    private static let accessToken_path = GGConfig.OAuth.GitHub.accessToken_url
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

enum WeiboWeiOAuthAPI {
    case Authorize
    case AccessToken(code: String)
}

extension WeiboWeiOAuthAPI: Target {
    private static let client_id = GGConfig.OAuth.Weibo.client_id
    private static let client_secret = GGConfig.OAuth.Weibo.client_secret
    private static let redirect_uri = GGConfig.OAuth.Weibo.callback_url
    private static let scope = "user,repo"
    private static let response_type = "code"
    private static let grant_type = "authorization_code"
    
    var baseURL: NSURL { return NSURL(string: "https://open.weibo.cn")! }
    
    var path: String {
        switch self {
        case .Authorize:
            return "/oauth2/authorize"
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
            return ["client_id": WeiboWeiOAuthAPI.client_id,
                    "redirect_uri": WeiboWeiOAuthAPI.redirect_uri,
                    "scope": WeiboWeiOAuthAPI.scope,
                    "response_type": WeiboWeiOAuthAPI.response_type,
                    "state": generateStateWithLength(20)]
            
        case .AccessToken(let code):
            return ["client_id": WeiboWeiOAuthAPI.client_id,
                    "client_secret": WeiboWeiOAuthAPI.client_secret,
                    "grant_type": WeiboWeiOAuthAPI.grant_type,
                    "redirect_uri": WeiboWeiOAuthAPI.redirect_uri,
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