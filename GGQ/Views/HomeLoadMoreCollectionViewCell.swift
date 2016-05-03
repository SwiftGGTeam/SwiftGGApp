//
//  HomeLoadMoreCollectionViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

class HomeLoadMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        gg_addShadow()
    }
}
