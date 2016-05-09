//
//  AppDelegate.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/8.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RealmSwift
import RouterX
import SwiftyJSON
#if RELEASE
    import Fabric
    import Crashlytics
    import Appsee
#endif

import CoreSpotlight
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let router = Router(defaultUnmatchHandler: { (url: NSURL, context: AnyObject?) in
        // Do something here, e.g: give some tips or show a default UI
        Warning("\(url) is unmatched.")

        // context can be provided on matching patterns
        if let context = context as? String {
            Warning("Context is \"\(context)\"")
        }
    })

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//            UIView.appearance().tintColor = UIColor.blackColor()
            UINavigationBar.appearance().tintColor = UIColor.gg_blackColor()
            UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
            UINavigationBar.appearance().shadowImage = UIImage()
//            UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//            UINavigationBar.appearance().gg_addShadow(defaultPath: true)
        UITabBar.appearance().tintColor = UIColor.gg_blackColor()
//            UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundImage = UIImage()
//            UITabBar.appearance().gg_addShadow(defaultPath: true)
//        #if RELEASE
//        Realm.prepareMigration()
//        #endif
        Realm.Configuration.defaultConfiguration = Realm.gg_configuration
        
//            cleanRealmFile()
        
        #if RELEASE
            Fabric.with([Crashlytics.self, Appsee.self])
        #endif
        
//        SyncService.sync()
        registerRoutingPattern()

        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        Info("Open: \(url)")
        router.matchURLAndDoHandler(url)
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        Info("\(userActivity)")
        
        if let urlStr = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
            url = NSURL(string: urlStr)
            where userActivity.activityType == CSSearchableItemActionType {
            router.matchURLAndDoHandler(url)
        }
        
        return true
    }

    func cleanRealmFile() {
        #if DEV
            let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
            let realmURLs = [
                realmURL,
                realmURL.URLByAppendingPathExtension("lock"),
                realmURL.URLByAppendingPathExtension("log_a"),
                realmURL.URLByAppendingPathExtension("log_b"),
                realmURL.URLByAppendingPathExtension("note")
            ]
            let manager = NSFileManager.defaultManager()
            for URL in realmURLs {
                do {
                    try manager.removeItemAtURL(URL)
                } catch {
                    // handle error
                }
            }

        #endif
    }
}

extension AppDelegate {
    func registerRoutingPattern() {
        
        router.registerRoutingPattern(GGConfig.Router.oauth) { (url, parameters, context) in
            let vc = RouterManager.findRouterable(routingPattern: GGConfig.Router.oauth)
            vc!.post(url, sender: JSON(parameters))
        }

        router.registerRoutingPattern(GGConfig.Router.article) { (url, parameters, context) in
            let vc = R.storyboard.article.articleManagerViewController()!
            vc.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.profile) { (url, parameters, context) in
            let vc = RouterManager.findRouterable(routingPattern: GGConfig.Router.profile)
            vc?.post(url, sender: JSON(parameters))
        }
    }
}
