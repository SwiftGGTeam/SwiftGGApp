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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}