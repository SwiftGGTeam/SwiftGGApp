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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let router = Router(defaultUnmatchHandler: { (url: NSURL, context: AnyObject?) in
        // Do something here, e.g: give some tips or show a default UI
        print("\(url) is unmatched.")

        // context can be provided on matching patterns
        if let context = context as? String {
            print("Context is \"\(context)\"")
        }
    })

//    // This is the handler that would be performed after no pattern match
//    let defaultUnmatchHandler = { (url: NSURL, context: AnyObject?) in
//        // Do something here, e.g: give some tips or show a default UI
//        print("\(url) is unmatched.")
//
//        // context can be provided on matching patterns
//        if let context = context as? String {
//            print("Context is \"\(context)\"")
//        }
//    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//            UIView.appearance().tintColor = UIColor.blackColor()
//            UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
//            UINavigationBar.appearance().shadowImage = UIImage()
//            UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//            UINavigationBar.appearance().gg_addShadow(defaultPath: true)
//            UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundImage = UIImage()
//            UITabBar.appearance().gg_addShadow(defaultPath: true)

//            cleanRealmFile()
        
        #if RELEASE
            Fabric.with([Crashlytics.self, Appsee.self])
        #endif
        
        SyncService.sharedInstance.sync()
        registerRoutingPattern()

        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        log.info("Open: \(url)")
        router.matchURLAndDoHandler(url)
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

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }

    class func findViewController(base: UIViewController? = UIApplication.sharedApplication().windows.first?.rootViewController, identifity: String) -> Routerable? {
        if let vc = base as? Routerable where vc.routerIdentifier == identifity {
            return vc
        }
        if let nav = base as? UINavigationController {
            if let vc = findViewController(nav.viewControllers, identifity: identifity) {
                return vc
            }
        }
        if let tab = base as? UITabBarController, let vcs = tab.viewControllers {
            if let vc = findViewController(vcs, identifity: identifity) {
                return vc
            }
        }
        if let presented = base?.presentedViewController {
            if let vc = findViewController(presented, identifity: identifity) {
                return vc
            }
        }
        return nil
    }

    class func findViewController(bases: [UIViewController], identifity: String) -> Routerable? {
        for base in bases {
            if let vc = base as? Routerable where vc.routerIdentifier == identifity {
                return vc
            }
            if let nav = base as? UINavigationController {
                if let vc = findViewController(nav.viewControllers, identifity: identifity) {
                    return vc
                }
            }
            if let tab = base as? UITabBarController, let vcs = tab.viewControllers {
                if let vc = findViewController(vcs, identifity: identifity) {
                    return vc
                }
            }
            if let presented = base.presentedViewController {
                if let vc = findViewController(presented, identifity: identifity) {
                    return vc
                }
            }
        }
        return nil
    }
}

extension AppDelegate {
    func registerRoutingPattern() {
        let patternOAuth = "/oauth/:type"
        router.registerRoutingPattern(patternOAuth) { (url, parameters, context) in

            var string = "URL is \(url), parameter is \(parameters)"
            if let context = context as? String {
                string += " Context is \"\(context)\""
            }

            let vc = UIApplication.findViewController(identifity: "oauth")

            vc?.post(url, sender: JSON(parameters))
        }

//        let patternArticle = "/:year/:month/:day/:pattern"
//        // http://swift.gg/2016/04/08/recap-of-swift-porting-efforts-2/
//        router.registerRoutingPattern(patternArticle) { (url, parameters, context) in
//
//            var string = "URL is \(url), parameter is \(parameters)"
//            if let context = context as? String {
//                string += " Context is \"\(context)\""
//            }
//
//            let vc = UIApplication.findViewController(identifity: "oauth")
//            print(vc)
//
//            vc?.post(url, sender: nil)
//        }
        
        let patternProfile = "/profile/:type/:token"
        
        router.registerRoutingPattern(patternProfile) { (url, parameters, context) in
            
            var string = "URL is \(url), parameter is \(parameters)"
            if let context = context as? String {
                string += " Context is \"\(context)\""
            }
            
            let vc = UIApplication.findViewController(identifity: "profile")
            
            vc?.post(url, sender: JSON(parameters))
        }
    }
}