//
//  UITabBar+Rx.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITabBarController {

    var rx_delegate: DelegateProxy {
        return RxTabBarControllerDelegateProxy.proxyForObject(self)
//        return proxyForObject(RxTabBarControllerDelegateProxy.self, self) Rx 2.4
    }

    var rx_didSelectViewController: ControlEvent<UIViewController> {
        let source = rx_delegate
            .observe(#selector(UITabBarControllerDelegate.tabBarController(_:didSelectViewController:)))
            .map { castOrFatalError($0[1]) as UIViewController }
        return ControlEvent(events: source)
    }

}
