//
//  UIViewController+STExtension.swift
//  SwiftGG
//
//  Created by TangJR on 1/25/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    func st_showErrorWithMessgae(message: String) {
        let HUD = JGProgressHUD(style: .Dark)
        HUD.textLabel.text = message
        HUD.indicatorView = JGProgressHUDErrorIndicatorView()
        HUD.showInView(view)
        HUD.dismissAfterDelay(1.0)
    }
}