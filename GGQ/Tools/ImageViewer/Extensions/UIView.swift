//
//  UIView.swift
//  ImageViewer
//
//  Created by Kristian Angyal on 29/02/2016.
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

extension UIView {
    
    var boundsCenter: CGPoint {
        
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}