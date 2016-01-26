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
    @IBOutlet weak var statusUnreadContainer: UIView!
    @IBOutlet weak var statusContainerFavCountLabel: UILabel!
    @IBOutlet weak var statusContainerAlreadyReadCountLabel: UILabel!
    @IBOutlet weak var statusContainerUnreadLabel: UILabel!
    
    @IBOutlet weak var userInfoContainer: UIView!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var alreadyReadView: UIView!
    @IBOutlet weak var unreadView: UIView!
    
    var leftBorderLayer = CALayer()
    var rightBorderLayer = CALayer()
    var bottomBorderLayer = CALayer()
    
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
        
        setupBorderLayer()
        updateBorderFrame()

        layer.addSublayer(bottomBorderLayer)
        statusAlreadReadContainer.layer.addSublayer(leftBorderLayer)
        statusUnreadContainer.layer.addSublayer(rightBorderLayer)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        updateBorderFrame()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorderFrame()
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

extension SGUSerTableHeaderView {
    private func setupBorderLayer() {
        let borderColor = UIColor(rgba: "#C7C7C7").CGColor
        leftBorderLayer.backgroundColor = borderColor
        rightBorderLayer.backgroundColor = borderColor
        bottomBorderLayer.backgroundColor = borderColor
    }
    
    private func updateBorderFrame() {
        let thickness: CGFloat = 0.5
        bottomBorderLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
        leftBorderLayer.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(statusAlreadReadContainer.frame))
        rightBorderLayer.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(statusUnreadContainer.frame))
    }
}
