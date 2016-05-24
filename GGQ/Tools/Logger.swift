//
//  Logger.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

#if DEV
    import XCGLogger

    private let log: XCGLogger = {
        let log = XCGLogger.defaultInstance()
        let logPath: NSURL = cacheDirectory.URLByAppendingPathComponent("XCGLogger.Log")
        #if DEV
            log.setup(.Verbose, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #else
            log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
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

    func Verbose(@autoclosure closure: () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        log.verbose(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    func Debug(@autoclosure closure: () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        log.debug(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    func Info(@autoclosure closure: () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        log.info(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    func Warning(@autoclosure closure: () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        log.warning(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    func Error(@autoclosure closure: () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        log.error(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    func Severe(@autoclosure closure: () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        log.severe(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

#else
    func Verbose(@autoclosure closure: () -> String?) { }
    func Debug(@autoclosure closure: () -> String?) { }
    func Info(@autoclosure closure: () -> String?) { }
    func Warning(@autoclosure closure: () -> String?) { }
    func Error(@autoclosure closure: () -> String?) { }
    func Severe(@autoclosure closure: () -> String?) { }
#endif
