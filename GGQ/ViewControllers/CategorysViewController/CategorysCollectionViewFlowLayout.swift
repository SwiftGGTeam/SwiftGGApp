//
//  CategorysCollectionViewFlowLayout.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/13.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

final class CategorysCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        itemSize = CGSize(width: collectionView!.bounds.width - 60, height: 120)
    }
}
