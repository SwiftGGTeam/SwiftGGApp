//
//  SearchTableViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/11.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

extension SearchTableViewCell {
    var title: String? {
        get {
            return contentTitleLabel.text
        }
        set {
            contentTitleLabel.text = newValue
        }
    }
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTitleLabel: UILabel!

}
