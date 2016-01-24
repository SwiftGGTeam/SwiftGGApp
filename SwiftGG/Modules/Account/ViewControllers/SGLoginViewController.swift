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
    }
    
    // MARK: Actions
    @IBAction func loginButtonTapped() {
        loginRequest()
    }
    
    @IBAction func registerButtonTapped() {
        let registerController = SGRegisterViewController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension SGLoginViewController {
    private func loginRequest() {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        guard username == "" else {
            return
        }
        guard password == "" else {
            return
        }
        
        SwiftGGProvider.request(.Login(username, password)) { result in
            switch result {
            case .Success(let response):
                do {
                    
                    let resultData = try response.mapJSON() as! [String: AnyObject]
                    let code = resultData["ret"] as! Int
                    
                    if code == 0 {
                        self.loginSuccess()
                    } else {
                        print("Error")
                    }
                } catch Error.Underlying(let error) {
                    print(error)
                } catch {
                    print("Unknow error")
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func loginSuccess() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showHomePage()
    }
}