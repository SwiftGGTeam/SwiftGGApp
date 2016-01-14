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
        
        setupTabbar()
    }
    
    func setupTabbar() {
        selectedIndex = 0
        tabBar.barTintColor = UIColor(rgba: "#FCFCFC")
        
        let toolBarImage = UIImage(named: "toolbar")
        //首页
        let homeVC = SGHomeViewController()
        homeVC.tabBarItem = UITabBarItem(title:"首页", image: toolBarImage, tag: 0)
        let homeNavigationVC = UINavigationController(rootViewController: homeVC)
        
        //分类
        let categoryVC = SGCategoryHomeViewController()
        categoryVC.tabBarItem = UITabBarItem(title:"分类", image:toolBarImage , tag: 0)
        let categoryNavigationVC = UINavigationController(rootViewController: categoryVC)
        
        //用户
        let userVC = SGUserViewController()
        userVC.tabBarItem = UITabBarItem(title:"我", image:toolBarImage , tag: 0)
        let userNavigationVC = UINavigationController(rootViewController: userVC)
        
        viewControllers = [homeNavigationVC, categoryNavigationVC, userNavigationVC]
    }
    
}