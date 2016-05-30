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
    
    static var gg_schemaVersion: UInt64 = 1003

    static var gg_configuration: Realm.Configuration {
        return Realm.Configuration(fileURL: gg_realmURL, schemaVersion: gg_schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            if (oldSchemaVersion < 1) {
                migration.enumerate(ArticleInfoObject.className()) { oldObject, newObject in
                    newObject!["contentUrl"] = ""
                }
            }
            
            })
    }
    
    static var gg_realmURL: NSURL {
        let directory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(GGConfig.appGroupID)!
        Info("\(directory)")
        return directory.URLByAppendingPathComponent("db.realm")
    }
    
    static func prepareMigration() {
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(gg_realmURL)
                try NSFileManager.defaultManager().copyItemAtURL(fileURL, toURL: gg_realmURL)
            } catch {}
        }
    }
}
