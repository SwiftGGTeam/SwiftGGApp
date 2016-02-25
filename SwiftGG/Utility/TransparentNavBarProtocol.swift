//
//  TransparentNavBarProtocol.swift
//  SwiftGG
//
//  Created by luckytantanfu on 2/25/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit


protocol TransparentNavBarProtocol {
    func transparentNavigationBar() -> UINavigationBar
}

extension TransparentNavBarProtocol where Self: UIViewController {
    func transparentNavigationBar() -> UINavigationBar {
        let customNavigationBar = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.navigationController!.navigationBar.bounds), 64))
        customNavigationBar.tintAdjustmentMode = .Normal
        customNavigationBar.backgroundColor = UIColor.clearColor()
        customNavigationBar.translucent = true
        customNavigationBar.shadowImage = UIImage()
        customNavigationBar.barStyle = UIBarStyle.BlackTranslucent
        customNavigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)

        return customNavigationBar
    }
}
