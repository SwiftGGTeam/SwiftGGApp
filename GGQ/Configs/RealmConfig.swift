//
//  RealmConfig.swift
//  GGQ
//
//  Created by 宋宋 on 5/6/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static var gg_schemaVersion: UInt64 = 1000
    #if DEV
    static var gg_configuration: Realm.Configuration {
        return Realm.Configuration.defaultConfiguration
    }
    #else
    static var gg_configuration: Realm.Configuration {
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(GGConfig.appGroupID)!
        let realmURL = directory.URLByAppendingPathComponent("db.realm")
        
        return Realm.Configuration(fileURL: realmURL, schemaVersion: gg_schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            if (oldSchemaVersion < 1) {
                migration.enumerate(ArticleInfoObject.className()) { oldObject, newObject in
                    newObject!["contentUrl"] = ""
                }
            }
            
            })
    }
    #endif
}
