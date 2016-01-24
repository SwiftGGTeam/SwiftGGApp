//
//  UIImage+STCreation.swift
//  SwiftGG
//
//  Created by TangJR on 1/24/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

extension UIImage {
    static func st_imageWithColor(color: UIColor) -> UIImage {
//        let context = UIGraphicsGetCurrentContext()
//        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
//        UIGraphicsBeginImageContext(rect.size)
//        CGContextSetFillColorWithColor(context, color.CGColor)
//        CGContextFillRect(context, rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        let size = CGSizeMake(20, 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, size.width, size.height))
        let color = UIColor.clearColor()
        color.setFill()
        rectanglePath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}