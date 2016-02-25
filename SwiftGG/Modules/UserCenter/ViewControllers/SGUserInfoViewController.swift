//
//  SGUserInfoViewController.swift
//  SwiftGG
//
//  Created by luckytantanfu on 2/23/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

class SGUserInfoViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

// MARK: - Helper
extension SGUserInfoViewController {
    private func setupViews() {
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.layer.cornerRadius = avatarImageView.width/2
        avatarImageView.image = UIImage(named: "setting_nav_item")
        
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor.whiteColor().CGColor
        shareButton.layer.cornerRadius = 8.0

        addCustomNavigationBar()
    }

    private func addCustomNavigationBar() {
        let customNavigationBar = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.navigationController!.navigationBar.bounds), 64))
        customNavigationBar.tintColor = UIColor.whiteColor()
        customNavigationBar.tintAdjustmentMode = .Normal
        customNavigationBar.alpha = 1
        let customNavigationItem = UINavigationItem(title: "")
        customNavigationBar.setItems([customNavigationItem], animated: false)
        view.addSubview(customNavigationBar)

        customNavigationBar.backgroundColor = UIColor.clearColor()
        customNavigationBar.translucent = true
        customNavigationBar.shadowImage = UIImage()
        customNavigationBar.barStyle = UIBarStyle.BlackTranslucent
        customNavigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)

        // add setting barItem
        let backBarItem = UIBarButtonItem(image: UIImage(named: "back_gray"), style: .Plain, target: self, action: "back")
        backBarItem.tintColor = UIColor.whiteColor()
        customNavigationItem.leftBarButtonItem = backBarItem
    }
    
    func back() {
        navigationController!.popViewControllerAnimated(true)
    }
}
