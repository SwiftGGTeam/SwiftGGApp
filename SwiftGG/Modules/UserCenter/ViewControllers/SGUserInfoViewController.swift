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
    }
}
