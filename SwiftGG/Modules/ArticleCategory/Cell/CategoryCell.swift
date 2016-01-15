//
//  CategoryCell.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/1/15.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleCountLabel: UILabel!
    
    func configureCell(category: ArticleCategory) {
        if let coverURL = NSURL(string: category.coverUrl) {
            coverImageView.kf_setImageWithURL(coverURL, placeholderImage: UIImage(named: "toolbar"))
        }
        
        titleLabel.text = category.name
        articleCountLabel.text = "\(category.articlesCount) 篇"
    }
    
}
