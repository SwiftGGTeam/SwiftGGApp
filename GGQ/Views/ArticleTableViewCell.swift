//
//  ArticleTableViewCell.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/16.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

extension ArticleTableViewCell {
	var title: String? {
		get {
			return contentTitleLabel.text
		}
		set {
			contentTitleLabel.text = newValue
		}
	}

	var readPageInfo: String? {
		get {
			return readPageInfoLabel.text
		}
		set {
			readPageInfoLabel.text = newValue
		}
	}
}

class ArticleTableViewCell: UITableViewCell {
	@IBOutlet weak var contentTitleLabel: UILabel!

	@IBOutlet weak var readPageInfoLabel: UILabel!
}
