//
//  UIView+GG.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

extension UIView {

    func gg_addShadow(defaultPath defaultPath: Bool = false) {
        layer.shadowColor = R.color.gg.shadows().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        if defaultPath {
            layer.shadowPath = CGPathCreateWithRect(bounds, nil)
        }
    }

}
