//
//  UIImageView+Rx.swift
//  GGQ
//
//  Created by 宋宋 on 5/10/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension UIImageView {

    var rx_imageURL: AnyObserver<NSURL> {
        return UIBindingObserver(UIElement: self) { imageView, URL in
            imageView.kf_setImageWithURL(URL)
            }.asObserver()
    }
    
}
