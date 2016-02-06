//
//  ThirdPartyLoginViewController.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/2/6.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

class SGThirdPartyLoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(sender: UIButton) {
        willMoveToParentViewController(nil)
        
        UIView.animateWithDuration(0.33,
        animations: {
            self.view.alpha = 0.0
        },
        completion: {_ in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
}
