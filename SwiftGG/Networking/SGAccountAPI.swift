//
//  SGAccountAPI.swift
//  SwiftGG
//
//  Created by TangJR on 2/3/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import Foundation
import Moya

class SGAccountAPI {
    static func sendRegisterRequest(username: String, password: String, success: (userModel: UserModel) -> Void, failure: (error: SGError) -> Void) -> Void {
        SwiftGGProvider.request(.Register(username, password)) { result in
            switch result {
            case .Success(let response):
                do {
                    let resultData = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as! [String: AnyObject]
//                    let resultData = try response. as! [String : AnyObject]
                    let code = resultData["ret"] as! Int
                    
                    if code == 0 {
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
}