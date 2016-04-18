//
//  ArticleCollectionViewFlowLayout.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/11.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

final class ArticleCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        itemSize = CGSize(width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
    }
}
