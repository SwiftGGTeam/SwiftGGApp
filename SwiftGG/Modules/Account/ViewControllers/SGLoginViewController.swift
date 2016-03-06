//
//  SGLoginViewController.swift
//  SwiftGG
//
//  Created by TangJR on 11/30/15.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit
import Moya

class SGLoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // FIXME: 登录用户名密码暂时写死
        passwordTextField.text = "swiftgg"
        usernameTextField.text = "swiftgg"
    }
    
    // MARK: Actions
    @IBAction func loginButtonTapped() {
        loginRequest()
    }
    
    @IBAction func registerButtonTapped() {
        let registerController = SGRegisterViewController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @IBAction func thirdPartyLoginButtonTapped() {
        let thirdPartyLoginController = SGThirdPartyLoginViewController()
        
        addChildViewController(thirdPartyLoginController)
        view.addSubview(thirdPartyLoginController.view)
        
        thirdPartyLoginController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view": thirdPartyLoginController.view]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": thirdPartyLoginController.view]))
        thirdPartyLoginController.didMoveToParentViewController(self)
        
        thirdPartyLoginController.view.alpha = 0.0
        UIView.animateWithDuration(0.33) {
            thirdPartyLoginController.view.alpha = 1.0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }
}

extension SGLoginViewController {
    private func setupNavigationBar() {
        title = "登录 SwiftGG"
        navigationController?.navigationBar.tintColor = UIColor.clearColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}

extension SGLoginViewController {
    private func loginRequest() {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        guard username != "" else {
            st_showErrorWithMessgae("用户名不能为空")
            return
        }
        guard password != "" else {
            st_showErrorWithMessgae("密码不能为空")
            return
        }
        
        SGAccountAPI.sendLoginRequest(username, password: password,
            success: { userModel in
                self.loginSuccess(userModel)
            },
            failure: { error in
                print(error)
        })
    }
    
    func loginSuccess(userModel: UserModel) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showHomePage()
        UserSingleton.shareInstence.userModel = userModel
        NSNotificationCenter.defaultCenter().postNotificationName(SGNotificationNameConst.LoginSuccess, object: self)
    }
}