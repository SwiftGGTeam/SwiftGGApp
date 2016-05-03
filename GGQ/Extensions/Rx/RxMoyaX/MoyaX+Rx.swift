//
//  MoyaX+Rx.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/14.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import MoyaX

class RxMoyaXProvider: MoyaXProvider {

    func request(token: Target) -> Observable<Response> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case .Response(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .Incomplete(let error):
                    observer.onError(error)
                }
            }

            return AnonymousDisposable {
                cancellableToken?.cancel()
            }
        }
    }
}
