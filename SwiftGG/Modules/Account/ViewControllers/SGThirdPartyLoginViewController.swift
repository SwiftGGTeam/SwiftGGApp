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
    @IBAction func closeButtonTapped() {
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
    
    @IBAction func weiboLoginButtonTapped(sender: ThirdPartyLoginButton) {
        print("微博登录")
        closeButtonTapped()
    }
    
    @IBAction func wechatLoginButtonTapped(sender: ThirdPartyLoginButton) {
        print("微信登录")
        closeButtonTapped()
    }
    
    @IBAction func githubLoginButtonTapped(sender: ThirdPartyLoginButton) {
        print("Github 登录")
        closeButtonTapped()
    }
}
