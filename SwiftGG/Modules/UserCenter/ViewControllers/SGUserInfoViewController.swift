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
extension SGUserInfoViewController: TransparentNavBarProtocol {
    private func setupViews() {
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.layer.cornerRadius = avatarImageView.width/2
        avatarImageView.image = UIImage(named: "setting_nav_item")
        
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor.whiteColor().CGColor
        shareButton.layer.cornerRadius = 8.0

        let transparentNavBar = transparentNavigationBar()
        view.addSubview(transparentNavBar)
        let customNavigationItem = UINavigationItem(title: "")
        transparentNavBar.setItems([customNavigationItem], animated: false)
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "back_gray"), style: .Plain, target: self, action: "back")
        settingBarItem.tintColor = UIColor.whiteColor()
        customNavigationItem.leftBarButtonItem = settingBarItem
    }
    
    func back() {
        navigationController!.popViewControllerAnimated(true)
    }
}
