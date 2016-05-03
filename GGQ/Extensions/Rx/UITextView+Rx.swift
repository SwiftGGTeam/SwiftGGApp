//
//  UITextView+Rx.swift
//  GGQ
//
//  Created by 宋宋 on 5/1/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextView {
    
    /**
     Bindable sink for `attributedText` property.
     */
    var rx_attributedText: AnyObserver<NSAttributedString> {
        return UIBindingObserver(UIElement: self) { textView, text in
            textView.attributedText = text
            }.asObserver()
    }
    
}