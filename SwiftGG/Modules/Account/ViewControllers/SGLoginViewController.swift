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
    
    // MARK: Helper Methods
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension SGLoginViewController {
    private func loginRequest() {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        guard username != "" else {
            showAlertWithMessage("用户名不能为空")
            return
        }
        guard password != "" else {
            showAlertWithMessage("密码不能为空")
            return
        }
        
        SwiftGGProvider.request(.Login(username, password)) { result in
            switch result {
            case .Success(let response):
                do {
                    
                    let resultData = try response.mapJSON() as! [String: AnyObject]
                    let code = resultData["ret"] as! Int
                    
                    if code == 0 {
                        
                        if username == "swiftgg" && password == "swiftgg" {
                            self.loginSuccess()
                        } else {
                            self.showAlertWithMessage("用户名或密码错误")
                        }
                        
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