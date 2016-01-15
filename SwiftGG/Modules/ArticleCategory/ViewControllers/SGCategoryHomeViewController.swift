//
//  SGLoginViewController.swift
//  SwiftGG
//
//  Created by TangJR on 11/30/15.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit
import Moya

let CategoryCellIdentifier = "CategoryCell"

class SGCategoryHomeViewController: UIViewController {
    var collectionView: UICollectionView!
    var categories = [ArticleCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "分类"
        
        setupCollectionView()
        
        SwiftGGProvider.request(.CategoryListings) { result in
            switch result {
            case .Success(let response):
                do {
                    
                    let resultData = try response.mapJSON() as! [String: AnyObject]
                    let code = resultData["ret"] as! Int
                    
                    if code == 0 {
                        let categoryDictArray = resultData["data"] as! [[String: AnyObject]]
                        self.categories = categoryDictArray.map { categoryDict in
                            return ArticleCategory(dict: categoryDict)
                        }
                        
                        self.collectionView.reloadData()
                    } else {
                        print("Error")
                    }
                } catch Error.Underlying(let error) {
                    print(error)
                } catch {
                    print("Unknow error")
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        let cellWidth = CGRectGetWidth(view.frame) / CGFloat(2)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        
        collectionView.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: CategoryCellIdentifier)
    }
}

extension SGCategoryHomeViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CategoryCell! = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCellIdentifier, forIndexPath: indexPath) as! CategoryCell
        
        let category = categories[indexPath.item]
        cell.configureCell(category)
        
        return cell
    }
}