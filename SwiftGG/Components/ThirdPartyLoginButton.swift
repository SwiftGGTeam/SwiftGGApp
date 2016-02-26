//
//  ThirdPartyLoginButton.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/2/6.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

class ThirdPartyLoginButton: UIControl {
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFontOfSize(14)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
}

extension ThirdPartyLoginButton {
    
    @IBInspectable
    var image: UIImage? {
        get {
            return imageView.image
        }
        
        set(newImage) {
            imageView.image = newImage?.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
    @IBInspectable
    var text: String? {
        get {
            return label.text
        }
        set(newText) {
            label.text = newText
        }
    }
}

extension ThirdPartyLoginButton {
    private func commonInitialization() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(label)
        addTapGestureRecognizer()
        
        label.textColor = tintColor
        
        let views = ["imageView": imageView]
        
        NSLayoutConstraint.activateConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]", options: [], metrics: nil, views: views)
        )
        NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0).active = true
        
        NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: imageView, attribute: .CenterY, multiplier: 1.0, constant: 0.0).active = true
        
        layer.cornerRadius = 4
        
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    }
}

extension ThirdPartyLoginButton {
    override func tintColorDidChange() {
        super.tintColorDidChange()
        label.textColor = tintColor
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleButtonTapped:"))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleButtonTapped(tapGestureRecoginzer: UITapGestureRecognizer) {
        sendActionsForControlEvents(.TouchUpInside)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animateTintAdjustmentMode(.Dimmed)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animateTintAdjustmentMode(.Normal)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        animateTintAdjustmentMode(.Normal)
    }
    
    private func animateTintAdjustmentMode(mode: UIViewTintAdjustmentMode) {
        let duration = (mode == .Normal ? 0.33 : 0.05)
        UIView.animateWithDuration(duration) {
            self.tintAdjustmentMode = mode
        }
    }
}
