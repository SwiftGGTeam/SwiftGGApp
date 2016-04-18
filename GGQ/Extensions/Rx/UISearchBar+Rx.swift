//
//  UISearchBar+Rx.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import RxSwift
import RxCocoa


extension UISearchBar {

    var rx_searchBarCancelButtonClicked: ControlEvent<Void> {
        let source = rx_delegate.observe(#selector(UISearchBarDelegate.searchBarCancelButtonClicked(_:)))
            .map { _ in }
        return ControlEvent(events: source)
    }

}
