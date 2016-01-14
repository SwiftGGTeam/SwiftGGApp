//
//  SGTabBarController.swift
//  SwiftGG
//
//  Created by wangheyun on 16/1/14.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift


class SGTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        self.tabBar.barTintColor = UIColor(rgba: "#FCFCFC")
        //首页
        let homeVC = SGHomeViewController()
        homeVC.tabBarItem = UITabBarItem(title:"首页", image:nil , tag: 0)
        let homeNavigationVC = UINavigationController.init(rootViewController: homeVC)
        //分类
        let categoryVC = SGCategoryHomeViewController();
        categoryVC.tabBarItem = UITabBarItem(title:"分类", image:nil , tag: 0)
        let categoryNavigationVC = UINavigationController.init(rootViewController: categoryVC)
        //用户
        let userVC = SGUserViewController();
        userVC.tabBarItem = UITabBarItem(title:"我", image:nil , tag: 0)
        let userNavigationVC = UINavigationController.init(rootViewController: userVC)
        
        self.viewControllers = [homeNavigationVC, categoryNavigationVC, userNavigationVC]
        
    }
    
}