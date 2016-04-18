//
//  AppDelegate.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/8.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            UIView.appearance().tintColor = UIColor.blackColor()
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
            UINavigationBar.appearance().gg_addShadow(defaultPath: true)
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().gg_addShadow(defaultPath: true)

            cleanRealmFile()

            return true
    }

    func cleanRealmFile() {
        #if DEV
            let manager = NSFileManager.defaultManager()
            let realmPath = Realm.Configuration.defaultConfiguration.path! as NSString
            let realmPaths = [
                realmPath as String,
                realmPath.stringByAppendingPathExtension("lock")!,
                realmPath.stringByAppendingPathExtension("log_a")!,
                realmPath.stringByAppendingPathExtension("log_b")!,
                realmPath.stringByAppendingPathExtension("note")!
            ]
            for path in realmPaths {
                do {
                    try manager.removeItemAtPath(path)
                } catch {
                    // 处理错误
                }
            }
        #endif
    }
}
