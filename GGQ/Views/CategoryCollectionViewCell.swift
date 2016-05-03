//
//  CategoryCollectionViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/13.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var contentNumberLabel: UILabel!

    var title: String? {
        get {
            return contentTitleLabel.text
        }
        set {
            contentTitleLabel.text = newValue
        }
    }

    var number: Int? {
        didSet {
            if let number = number {
                contentNumberLabel.text = "已有 \(number) 篇"
            } else {
                contentNumberLabel.text = nil
            }
        }
    }

    override func awakeFromNib() {
        gg_addShadow()
    }
}
