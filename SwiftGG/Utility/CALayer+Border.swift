//
//  CALayer+Border.swift
//  SwiftGG
//
//  Created by skyline on 16/4/7.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

extension CALayer {
    /**
     Add border to layer

     - parameter edges:     which side to add border
     - parameter color:     corlor of border to add
     - parameter thickness: border width
     */
    func addBorder(edges: [UIRectEdge], color: UIColor, thickness: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.Top:
                border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness)
            case UIRectEdge.Bottom:
                border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
            case UIRectEdge.Left:
                border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            case UIRectEdge.Right:
                border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            default:
                break
            }
            border.backgroundColor = color.CGColor
            self.addSublayer(border)
        }
    }
}