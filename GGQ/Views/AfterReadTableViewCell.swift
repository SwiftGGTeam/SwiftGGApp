//
//  AfterReadTableViewCell.swift
//  GGQ
//
//  Created by 宋宋 on 5/10/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit

extension AfterReadTableViewCell {
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var category: String? {
        get {
            return categoryLabel.text
        }
        set {
            categoryLabel.text = newValue
        }
    }
    
}

class AfterReadTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    
}
