//
//  UIScrollView+Rx.swift
//  GGQ
//
//  Created by 宋宋 on 5/2/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift

extension UIScrollView {
    var rx_reachedBottom: Observable<Void> {
        return rx_contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Bool> in
                guard let `self` = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = self.frame.height - self.contentInset.top - self.contentInset.bottom
                let y = contentOffset.y + self.contentInset.top
                let threshold = max(0.0, self.contentSize.height - visibleHeight)
                Info("Offset: \(contentOffset), Size: \(self.contentSize)")
                Info("Y: \(y), threshold: \(threshold)")
                return y >= threshold ? Observable.just(true) : Observable.just(false)
            }.distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
    }
}
