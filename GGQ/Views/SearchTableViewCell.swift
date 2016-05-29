//
//  SearchTableViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/11.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

extension SearchTitleTableViewCell {
    var title: String? {
        get {
            return contentTitleLabel.text
        }
        set {
            contentTitleLabel.text = newValue
        }
    }
}

class SearchTitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentTitleLabel: UILabel!

}


extension SearchContentTableViewCell {
    var title: String? {
        get {
            return contentTitleLabel.text
        }
        set {
            contentTitleLabel.text = newValue
        }
    }
    
    var contentAttribute: NSAttributedString? {
        get {
            return contentLabel.attributedText
        }
        set {
            contentLabel.attributedText = newValue
        }
    }
}

class SearchContentTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var contentTitleLabel: UILabel!
    
    @IBOutlet private weak var contentLabel: UILabel!
    
}