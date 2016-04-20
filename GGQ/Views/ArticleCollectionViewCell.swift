//
//  ArticleCollectionViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/11.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

extension ArticleCollectionViewCell {

    var title: String? {
        get {
            return contentTitleLabel.text
        }
        set {
            contentTitleLabel.text = title
        }
    }

    var contentText: NSAttributedString {
        get {
            return contentTextView.attributedText
        }
        set {
            contentTextView.attributedText = newValue
        }
    }

    var pageInfo: String? {
        get {
            return pageInfoLabel.text
        }
        set {
            pageInfoLabel.text = newValue
        }
    }
}

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var pageInfoLabel: UILabel!
}
