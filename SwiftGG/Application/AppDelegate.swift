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
        
        application.statusBarHidden = false
        application.statusBarStyle = .LightContent
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let rootViewController = SGTabBarController()
        window!.rootViewController = rootViewController
        
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        setDefaultAppearance()
        JPushHelper.setupJPushWithLaunchOptions(launchOptions)
        if let info = launchOptions where info[UIApplicationLaunchOptionsRemoteNotificationKey] != nil {
            // 代表应用从通知启动，需要处理通知
            JPushHelper.handleRemoteAPNMessage(info)
        }
        
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
    
    // MARK: Remote Notification
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        JPushHelper.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("【推送】推送服务注册失败，错误原因：\(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        JPushHelper.handleRemoteNotification(userInfo)
    }
}