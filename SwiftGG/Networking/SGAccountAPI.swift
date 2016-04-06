//
//  SGAccountAPI.swift
//  SwiftGG
//
//  Created by TangJR on 2/3/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import Foundation
import Moya

struct SGAccountAPI {
    static func sendRegisterRequest(username: String, password: String, success: (userModel: UserModel) -> Void, failure: (error: SGError) -> Void) {
        SwiftGGProvider.request(.Register(username, password)) { result in
            switch result {
            case .Success(let response):
                do {
                    let resultData = try response.mapJSON() as! [String: AnyObject]

                    if let code = resultData["ret"] as? Int where code == 0 {
                        let userModel = UserModel(jsonDict: resultData["data"] as! [String: AnyObject])
                        success(userModel: userModel)
                    } else {
                        failure(error: .Failure)
                    }
                } catch {
                    failure(error: .Failure)
                }
            case .Failure:
                failure(error: .Failure)
            }
        }
    }
    
    static func sendLoginRequest(username: String, password: String, success: (userModel: UserModel) -> Void, failure: (error: SGError) -> Void) {
        SwiftGGProvider.request(.Login(username, password)) { result in
            switch result {
            case .Success(let response):
                do {
                    
                    let resultData = try response.mapJSON() as! [String: AnyObject]

                    if let code = resultData["ret"] as? Int where code == 0 {
                        let userModel = UserModel(jsonDict: resultData["data"] as! [String: AnyObject])
                        success(userModel: userModel)
                    } else {
                        failure(error: .Failure)
                    }
                } catch {
                    failure(error: .Failure)
                }
            case .Failure:
                failure(error: .Failure)
            }
        }
    }
    
    static func sendOAuthGitHubRequest(token: String) {
        
    }
}