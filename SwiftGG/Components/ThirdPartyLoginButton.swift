//
//  ThirdPartyLoginButton.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/2/6.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

@IBDesignable
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
        l.textColor = UIColor.whiteColor()
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
            imageView.image = newImage?.imageWithRenderingMode(.AlwaysOriginal)
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
        
        NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0).active = true
        
        NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: imageView, attribute: .CenterY, multiplier: 1.0, constant: 0.0).active = true
        
        layer.cornerRadius = 4
        
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    }
}
