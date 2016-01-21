//
//  SGUSerTableHeaderView.swift
//  SwiftGG
//
//  Created by luckytantanfu on 1/19/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

class SGUSerTableHeaderView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readNumberLabel: UILabel!
    
    @IBOutlet weak var statusContainerFavCountLabel: UILabel!
    @IBOutlet weak var statusContainerAlreadyReadCountLabel: UILabel!
    @IBOutlet weak var statusContainerUnreadLabel: UILabel!
    
    @IBOutlet weak var userInfoContainer: UIView!
    @IBOutlet weak var middleViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var alreadyReadView: UIView!
    @IBOutlet weak var unreadView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 添加线条
        middleViewLeadingConstraint.constant = 0.5
        middleViewTrailingConstraint.constant = 0.5
        
        // add target-action
        userInfoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onUserInfoContainerClicked"))
        favView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onFavButtonClicked"))
        alreadyReadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAlreadyReadButtonClicked"))
        unreadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onUnreadButtonClicked"))
        
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.image = UIImage(named: "setting_nav_item")
    }
    
    func onUserInfoContainerClicked() {
        print("container")
    }
    
    func onFavButtonClicked() {
        print("fav")
    }
    
    func onAlreadyReadButtonClicked() {
        print("already")
    }
    
    func onUnreadButtonClicked() {
        print("unread")
    }
}
