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
    
    @IBOutlet weak var statusContainer: UIView!
    @IBOutlet weak var statusAlreadReadContainer: UIView!
    @IBOutlet weak var statusContainerFavCountLabel: UILabel!
    @IBOutlet weak var statusContainerAlreadyReadCountLabel: UILabel!
    @IBOutlet weak var statusContainerUnreadLabel: UILabel!
    
    @IBOutlet weak var userInfoContainer: UIView!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var alreadyReadView: UIView!
    @IBOutlet weak var unreadView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let containerView = UINib(nibName: "SGUserTableHeaderView", bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(containerView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add target-action
        userInfoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onUserInfoContainerClicked"))
        favView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onFavButtonClicked"))
        alreadyReadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAlreadyReadButtonClicked"))
        unreadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onUnreadButtonClicked"))
        
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.image = UIImage(named: "setting_nav_item")
        
        statusContainer.layer.addBorder([.Bottom], color: UIColor(rgba: "#C7C7C7"), thickness: 0.5)
        statusAlreadReadContainer.layer.addBorder([UIRectEdge.Left, UIRectEdge.Right], color: UIColor(rgba: "#C7C7C7"), thickness: 0.5)
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
