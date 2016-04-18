//
//  Logger.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

#if DEV
    import XCGLogger

    let log: XCGLogger = {
        let log = XCGLogger.defaultInstance()
        let logPath: NSURL = cacheDirectory.URLByAppendingPathComponent("XCGLogger.Log")
        #if DEBUG
            log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #else
            log.setup(.Verbose, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #endif
        log.xcodeColorsEnabled = true
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

    private var documentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1]
    }

    private var cacheDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1]
    }

#else
    class Logger {
        func verbose(@autoclosure closure: () -> String?) { }
        func debug(@autoclosure closure: () -> String?) { }
        func info(@autoclosure closure: () -> String?) { }
        func warning(@autoclosure closure: () -> String?) { }
        func error(@autoclosure closure: () -> String?) { }
        func severe(@autoclosure closure: () -> String?) { }
    }

    let log = Logger()
#endif
