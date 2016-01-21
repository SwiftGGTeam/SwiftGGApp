//
//  SGUserReadingTableViewCell.swift
//  SwiftGG
//
//  Created by luckytantanfu on 1/19/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

class SGUserReadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorInset = UIEdgeInsetsZero
    }
}

// MARK: - public API
extension SGUserReadingTableViewCell {
    func setArticleTitle(title: String) {
        titleLabel.text = title
    }
    
    /// 文章阅读进度，传入两位整数
    func setArticleProgress(progress: Int) {
        progressLabel.text = "已读 \(progress)%"
    }
}
