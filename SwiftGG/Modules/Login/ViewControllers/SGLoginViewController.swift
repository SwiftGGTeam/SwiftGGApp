//
//  SGLoginViewController.swift
//  SwiftGG
//
//  Created by TangJR on 11/30/15.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit

class SGLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
}