//
//  LoginViewModel.swift
//  GGQ
//
//  Created by 宋宋 on 5/25/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MoyaX

enum LoginType {
    case GitHub
    case Wechat
    case Weibo
}

class LoginViewModel {
    
    let authorizeResponse: Observable<GGResult<NSURL>>
    
    let isAuthorizing = Variable(false)
    
    private let disposeBag = DisposeBag()
    
    init(input: (
        loginTrigger: Observable<LoginType>,
        oauthCallbackToken: Observable<NSURL>
        ),
         provider: RxMoyaXProvider) {
        
        let authorizeRequest = input.loginTrigger
            .map { type -> Target in
                switch type {
                case .GitHub:
                    return GitHubOAuthAPI.Authorize
                default:
                    fatalError("暂不支持")
                }
            }
            .share()
        
        authorizeResponse = authorizeRequest
            .flatMapLatest(provider.v2_request)
            .map { result -> GGResult<NSURL> in
                switch result {
                case .Success(let response):
                    if let url = response.response?.URL {
                        return GGResult.Success(url)
                    } else {
                        return GGResult.Failure(GGError.Authorize.Unknown)
                    }
                case .Failure(let error):
                    return GGResult.Failure(error)
                }
            }
            .share()
        
        [authorizeRequest.map { _ in true}, authorizeResponse.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(isAuthorizing)
            .addDisposableTo(disposeBag)
        
        
        
        
        }
}
