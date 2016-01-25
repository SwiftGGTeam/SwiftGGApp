//
//  UIViewController+STExtension.swift
//  SwiftGG
//
//  Created by TangJR on 1/25/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

extension UIViewController {
    func st_showAlertWithMessgae(message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}