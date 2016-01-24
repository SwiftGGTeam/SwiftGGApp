//
//  SGHomeViewCell.swift
//  SwiftGG
//
//  Created by Jack on 16/1/24.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

class SGHomeViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var assistView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var translatorLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2.0
        avatarImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cellModel: HomeViewCellModel) {
        if let avatarUrl = NSURL(string: cellModel.avatarUrl) {
            avatarImageView.kf_setImageWithURL(avatarUrl, placeholderImage: UIImage(named: "about_logo"))
        }
        titleLabel.text = cellModel.title
        descriptionLabel.text = cellModel.description
        categoryLabel.text = cellModel.category
        translatorLabel.text = cellModel.translator
        commentCountLabel.text = String(cellModel.commentCount)
        
        authorLabel.text = cellModel.author
        dateLabel.text = cellModel.date
        
    }
    
    
}
