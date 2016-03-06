//
//  SGUSerTableHeaderView.swift
//  SwiftGG
//
//  Created by luckytantanfu on 1/19/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

protocol SGUSerTableHeaderViewDelegate {
    func didUserInfoContainerPressed()
}

class SGUSerTableHeaderView: UIView {
    
    var delegate: SGUSerTableHeaderViewDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readNumberLabel: UILabel!
    
    @IBOutlet weak var userInfoContainer: UIView!
    
    @IBOutlet weak var statusFavContainer: UIView!
    @IBOutlet weak var statusAlreadReadContainer: UIView!
    @IBOutlet weak var statusUnreadContainer: UIView!
    
    @IBOutlet weak var statusContainerFavCountLabel: UILabel!
    @IBOutlet weak var statusContainerAlreadyReadCountLabel: UILabel!
    @IBOutlet weak var statusContainerUnreadLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let containerView = UINib(nibName: "SGUserTableHeaderView", bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(containerView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add target-action
        userInfoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onUserInfoContainerClicked"))
        statusFavContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onFavButtonClicked"))
        statusAlreadReadContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAlreadyReadButtonClicked"))
        statusUnreadContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onUnreadButtonClicked"))
        
        avatarImageView.layer.borderWidth = 1.5
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.image = UIImage(named: "setting_nav_item")
    }
    
    func onUserInfoContainerClicked() {
        self.delegate?.didUserInfoContainerPressed()
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