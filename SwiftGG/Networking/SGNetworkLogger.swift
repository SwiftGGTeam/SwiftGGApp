//
//  SGNetworkLogger.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/2/4.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import Moya
import Result
import XCGLogger

class SGNetworkLogger: PluginType {
    let log: XCGLogger = {
        let log = XCGLogger.defaultInstance()
        // By using Swift build flags, different log levels can be used in debugging versus staging/production. Go to Build settings -> Swift Compiler - Custom Flags -> Other Swift Flags and add -DDEBUG to the Debug entry.
        #if DEBUG
            log.setup()
        #else
            log.setup(.Severe)
        #endif
        log.xcodeColorsEnabled = false
        log.xcodeColors = [
            .Verbose: .lightGrey,
            .Debug: .darkGrey,
            .Info: .darkGreen,
            .Warning: .orange,
            .Error: .red,
            .Severe: .whiteOnRed
        ]
        return log
    }()
    
    typealias NetworkLoggerClosure = (change: NetworkActivityChangeType) -> ()
    let networkLoggerClosure: NetworkLoggerClosure
    
    static let defaultLoggerClousre: NetworkLoggerClosure = { change in
        
    }
    
    init(networkLoggerClosure: NetworkLoggerClosure = SGNetworkLogger.defaultLoggerClousre) {
        self.networkLoggerClosure = networkLoggerClosure
    }
    
    func willSendRequest(request: RequestType, target: TargetType) {
        log.info("\n\(target.path) \(target.method) \(target.parameters ?? [:])")
        networkLoggerClosure(change: .Began)
    }
    
    func didReceiveResponse(result: Result<Moya.Response, Moya.Error>, target: TargetType) {
        switch result {
        case .Success(let response) :
            do {
                let json = try response.mapJSON()
                log.info("\n\(response.statusCode) \(target.method) \(target.path) \(target.parameters ?? [:]) \n\(json)")
            } catch {
                log.info("\n\(response.statusCode) \(target.method) \(target.path) \(target.parameters ?? [:]) \n\(response.data)")
            }
        case .Failure(let error) :
            log.error("\(error)")
        }
        networkLoggerClosure(change: .Ended)
    }
}
