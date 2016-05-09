//
//  Cache.swift
//  GGQ
//
//  Created by 宋宋 on 5/8/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation

let articleCache: NSCache = {
    let cache = NSCache()
    cache.name = "gg.swift.articleCache"
    cache.countLimit = 20
    return cache
}()

extension NSCache {
    subscript(key: AnyObject) -> AnyObject? {
        get {
            return objectForKey(key)
        }
        set {
            if let value: AnyObject = newValue {
                setObject(value, forKey: key)
            } else {
                removeObjectForKey(key)
            }
        }
    }
}