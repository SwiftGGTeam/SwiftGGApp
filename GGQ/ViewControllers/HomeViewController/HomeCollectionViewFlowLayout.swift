//
//  HomeCollectionViewFlowLayout.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

final class HomeCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        itemSize = CGSize(width: collectionView!.bounds.width - 40, height: collectionView!.bounds.height - 60)
    }

}
