//
//  RxUITabBarDelegateProxy.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxTabBarControllerDelegateProxy: DelegateProxy, UITabBarControllerDelegate, DelegateProxyType {

    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let tabBarVC: UITabBarController = castOrFatalError(object)
        return tabBarVC.delegate
    }

    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let tabBarVC: UITabBarController = castOrFatalError(object)
        tabBarVC.delegate = delegate as? UITabBarControllerDelegate
    }

}
