//
//  HomeCollectionViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import SwiftDate

extension HomeCollectionViewCell {

    var title: NSAttributedString? {
        get {
            return contentTitleLabel.attributedText
        }
        set {
            contentTitleLabel.attributedText = newValue
        }
    }

    var time: NSDate? {
        get {
            return contentTimeLabel.text?.toDate(DateFormat.ISO8601Format(.Extended))
        }
        set {
            contentTimeLabel.text = newValue?.toString()
        }
    }

    var timeString: String? {
        get {
            return contentTimeLabel.text
        }
        set {
            contentTimeLabel.text = newValue
        }
    }

    var info: String? {
        get {
            return contentInfoLabel.text
        }
        set {
            contentInfoLabel.text = newValue
        }
    }

    var preview: NSAttributedString? {
        get {
            return contentPreviewLabel.attributedText
        }
        set {
            contentPreviewLabel.attributedText = newValue
        }
    }
}

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var contentTimeLabel: UILabel!
    @IBOutlet private weak var contentInfoLabel: UILabel!
    @IBOutlet private weak var contentPreviewLabel: UILabel!

    override func awakeFromNib() {
        gg_addShadow()
        
    }
}
