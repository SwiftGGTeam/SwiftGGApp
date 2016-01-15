//
//  AppDelegate.swift
//  SwiftGG
//
//  Created by 王河云 on 15/11/2.
//  Copyright © 2015年 swiftgg. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbarController: SGTabBarController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let loginController = SGLoginViewController()
        window!.rootViewController = loginController
        
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        setDefaultAppearance()
        
        return true
    }

    func setDefaultAppearance(){
        let navBar = UINavigationBar.appearance()
        
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navBar.barTintColor = UIColor(rgba: "#3595BF")
    }
    
    func showHomePage(){
        tabbarController = SGTabBarController()
        window!.rootViewController = tabbarController
    }
}

