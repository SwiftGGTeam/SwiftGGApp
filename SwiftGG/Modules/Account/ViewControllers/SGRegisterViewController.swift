//
//  SGRegisterViewController.swift
//  SwiftGG
//
//  Created by TangJR on 12/2/15.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit

class SGRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButton = UIButton(type: .System)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("关闭", forState: .Normal)
        closeButton.addTarget(self, action: Selector("dismiss"), forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
        
        let horizontalCenterConstraint = NSLayoutConstraint(item: closeButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let verticalCenterConstraint = NSLayoutConstraint(item: closeButton, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([horizontalCenterConstraint, verticalCenterConstraint])
        
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}