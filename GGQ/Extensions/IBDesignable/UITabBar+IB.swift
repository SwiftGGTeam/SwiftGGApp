//
//  UITabBar+IB.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

@IBDesignable
extension UITabBar {

    @IBInspectable var imageInsetTop: CGFloat {
        get {
            return items!.first!.imageInsets.top
        }
        set {
            for item in items! where item.imageInsets.top != newValue {
                item.imageInsets.top = newValue
            }
        }
    }

    @IBInspectable var imageInsetBottom: CGFloat {
        get {
            return items!.first!.imageInsets.bottom
        }
        set {
            for item in items! where item.imageInsets.bottom != newValue {
                item.imageInsets.bottom = newValue
            }
        }
    }

    @IBInspectable var imageInsetLeft: CGFloat {
        get {
            return items!.first!.imageInsets.left
        }
        set {
            for item in items! where item.imageInsets.left != newValue {
                item.imageInsets.left = newValue
            }
        }
    }

    @IBInspectable var imageInsetRight: CGFloat {
        get {
            return items!.first!.imageInsets.right
        }
        set {
            for item in items! where item.imageInsets.right != newValue {
                item.imageInsets.right = newValue
            }
        }
    }
}
