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
import SwiftyJSON

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
    
    func v2_request(token: Target) -> Observable<GGResult<Response>> {

        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case .Response(let response):
                    observer.onNext(.Success(response))
                case .Incomplete(let error):
                    observer.onNext(.Failure(error))
                }
                observer.onCompleted()
            }
            
            return AnonymousDisposable {
                cancellableToken?.cancel()
            }
        }
    }
    
    func v2_requestJSON(token: Target) -> Observable<GGResult<JSON>> {
        
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case .Response(let response):
                    let json = JSON(data: response.data)
                    if let error = json.error {
                        observer.onNext(.Failure(error))
                    } else if json.type == .Null {
                        observer.onNext(.Failure(GGError.JSON.Null))
                    } else {
                        observer.onNext(GGResult.Success(json))
                    }
                case .Incomplete(let error):
                    observer.onNext(.Failure(error))
                }
                observer.onCompleted()
            }
            
            return AnonymousDisposable {
                cancellableToken?.cancel()
            }
        }
    }
    
    func v2_requestGGJSON(token: Target) -> Observable<GGResult<JSON>> {
        
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case .Response(let response):
                    let json = JSON(data: response.data)["data"]
                    if let error = json.error {
                        observer.onNext(.Failure(error))
                    } else if json.type == .Null {
                        observer.onNext(.Failure(GGError.JSON.Null))
                    } else {
                        observer.onNext(GGResult.Success(json))
                    }
                case .Incomplete(let error):
                    observer.onNext(.Failure(error))
                }
                observer.onCompleted()
            }
            
            return AnonymousDisposable {
                cancellableToken?.cancel()
            }
        }
    }

}
