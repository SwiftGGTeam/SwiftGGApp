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
#if !DEV
    import Fabric
    import Crashlytics
    import Appsee
#endif

import CoreSpotlight
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var feedbackController: FeedbackController?

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
            UINavigationBar.appearance().tintColor = R.color.gg.black()
            UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
            UINavigationBar.appearance().shadowImage = UIImage()
//            UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//            UINavigationBar.appearance().gg_addShadow(defaultPath: true)
        UITabBar.appearance().tintColor = R.color.gg.black()
//            UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundImage = UIImage()
//            UITabBar.appearance().gg_addShadow(defaultPath: true)
//        Realm.prepareMigration()
        Realm.Configuration.defaultConfiguration = Realm.gg_configuration
        
//            cleanRealmFile()
        
        #if !DEV
            Fabric.with([Crashlytics.self, Appsee.self])
        #endif
        
//        SyncService.sync()
        registerRoutingPattern()

        return true
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
//        let handledShortCutItem = handleShortCutItem(shortcutItem)
//        completionHandler(handledShortCutItem)
        
        if let urlStr = shortcutItem.userInfo?["URL"] as? String,
            url = NSURL(string: urlStr)
        {
            router.matchURLAndDoHandler(url)
        }
        
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        Info("Open: \(url)")
        
        if url.scheme == GGConfig.Router.Weibo.scheme && url.host == GGConfig.Router.Weibo.host {
            let vc = RouterManager.findRouterable(routingPattern: GGConfig.Router.oauth)
            vc?.post(url, sender: nil)
            return true
        }
        
        guard url.scheme == GGConfig.Router.scheme && url.host == GGConfig.Router.host else { return false }
        return router.matchURLAndDoHandler(url)
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

}

extension AppDelegate {
    func registerRoutingPattern() {
        
        router.registerRoutingPattern(GGConfig.Router.oauth) { (url, parameters, context) in
            let vc = RouterManager.findRouterable(routingPattern: GGConfig.Router.oauth)
            vc?.post(url, sender: JSON(parameters))
        }

        router.registerRoutingPattern(GGConfig.Router.article) { (url, parameters, context) in
            let vc = R.storyboard.article.articleDetailViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.Profile.token) { (url, parameters, context) in
            let vc = RouterManager.findRouterable(routingPattern: GGConfig.Router.Profile.index)
            vc?.post(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.Profile.logout) { (url, parameters, context) in
            let vc = RouterManager.findRouterable(routingPattern: GGConfig.Router.Profile.index)
            vc?.post(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.Categoties.name)  { (url, parameters, context) in
            let vc = R.storyboard.category.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.Categoties.id)  { (url, parameters, context) in
            let vc = R.storyboard.category.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.About.index) { (url, parameters, context) in
            let vc = R.storyboard.about.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.About.Licences.index) { (url, parameters, context) in
            let vc = R.storyboard.licences.licencesViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.About.Translators.index) { (url, parameters, context) in
            let vc = R.storyboard.translators.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }

        router.registerRoutingPattern(GGConfig.Router.Search.index) { (url, parameters, context) in
            let vc = R.storyboard.search.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }

        router.registerRoutingPattern(GGConfig.Router.Search.content) { (url, parameters, context) in
            let vc = R.storyboard.search.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.setting) { (url, parameters, context) in
            let vc = R.storyboard.setting.initialViewController()
            vc?.get(url, sender: JSON(parameters))
        }

        router.registerRoutingPattern(GGConfig.Router.feedback) { (url, parameters, context) in
            let vc = FeedbackController()
            vc.get(url, sender: JSON(parameters))
            self.feedbackController = vc
        }
        
        router.registerRoutingPattern(GGConfig.Router.home) { (url, parameters, context) in
            let vc = R.storyboard.main.homeViewController()
            vc?.get(url, sender: JSON(parameters))
        }
        
        router.registerRoutingPattern(GGConfig.Router.Share.article) { (url, parameters, context) in
            let vc = ShareController()
            vc.get(url, sender: JSON(parameters))
        }

    }
}
