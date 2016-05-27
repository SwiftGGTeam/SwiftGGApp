//
//  GGRouter.swift
//  GGQ
//
//  Created by 宋宋 on 5/8/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit

typealias RouterManager = UIApplication

extension RouterManager {
    
    class func sharedRouterManager() -> RouterManager {
        return sharedApplication()
    }
    
    class func topRouterable() -> Routerable? {
        if let topRouterable = topViewController() as? Routerable {
            return topRouterable
        } else {
            Warning("\(topViewController()) not conform Routerable")
        }
        return nil
    }
    
    class func findRouterable(base: UIViewController? = UIApplication.sharedApplication().windows.first?.rootViewController, routingPattern: String) -> Routerable? {
        if let vc = base as? Routerable where vc.routingPattern == routingPattern {
            return vc
        }
        if let nav = base as? UINavigationController {
            if let vc = findRouterable(nav.viewControllers, routingPattern: routingPattern) {
                return vc
            }
        }
        if let tab = base as? UITabBarController, let vcs = tab.viewControllers {
            if let vc = findRouterable(vcs, routingPattern: routingPattern) {
                return vc
            }
        }
        if let presented = base?.presentedViewController {
            if let vc = findRouterable(presented, routingPattern: routingPattern) {
                return vc
            }
        }
        return nil
    }
    
    private class func findRouterable(bases: [UIViewController], routingPattern: String) -> Routerable? {
        for base in bases {
            if let vc = base as? Routerable where vc.routingPattern == routingPattern {
                return vc
            }
            if let nav = base as? UINavigationController {
                if let vc = findRouterable(nav.viewControllers, routingPattern: routingPattern) {
                    return vc
                }
            }
            if let tab = base as? UITabBarController, let vcs = tab.viewControllers {
                if let vc = findRouterable(vcs, routingPattern: routingPattern) {
                    return vc
                }
            }
            if let presented = base.presentedViewController {
                if let vc = findRouterable(presented, routingPattern: routingPattern) {
                    return vc
                }
            }
        }
        return nil
    }
    
    func neverCareResultOpenURL(url: NSURL) {
        openURL(url)
    }
}

#if DEBUG
extension UIViewController: Routerable {
    
    var routingPattern: String {
        return "404"
    }
    
    var routingIdentifier: String? {
        return nil
    }

}
#endif

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
}