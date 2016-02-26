//
//  SGRegisterViewController.swift
//  SwiftGG
//
//  Created by TangJR on 12/2/15.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit
import Moya

class SGRegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "注册 SwiftGo"
        
        let backImage = UIImage(named: "back_white")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: Selector("dismiss"))
    }
    
    // MARK: - Actions
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func registerInfomationButtonTapped() {
        let controller = SGRegisterInformationController()
        navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        registerRequest()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }
}

extension SGRegisterViewController {
    private func registerRequest() {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        guard username != "" else {
            st_showErrorWithMessgae("用户名不能为空")
            return
        }
        
        guard password != "" else {
            st_showErrorWithMessgae("密码不能为空")
            return
        }
        
        guard confirmPassword == password else {
            st_showErrorWithMessgae("两次密码不同")
            return
        }
        
        SGAccountAPI.sendRegisterRequest(username, password: password,
            success: { userModel in
                print(userModel)
            },
            failure: { error in
                print(error)
        })
    }
}