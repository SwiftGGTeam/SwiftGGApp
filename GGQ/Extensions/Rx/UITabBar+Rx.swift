//
//  UITabBar+Rx.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa

extension UITabBarController {

    var rx_delegate: DelegateProxy {
        return proxyForObject(RxTabBarControllerDelegateProxy.self, self)
    }

    var rx_didSelectViewController: ControlEvent<UIViewController> {
        let source = rx_delegate
            .observe(#selector(UITabBarControllerDelegate.tabBarController(_:didSelectViewController:)))
            .map { castOrFatalError($0[1]) as UIViewController }
        return ControlEvent(events: source)
    }

}
