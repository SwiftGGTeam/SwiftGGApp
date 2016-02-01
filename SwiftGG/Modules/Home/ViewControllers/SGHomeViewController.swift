//
//  SGHomeViewController.swift
//  SwiftGG
//
//  Created by JackAlan on 01/22/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit
import RealmSwift

let cellId = "HomeViewCell"

class SGHomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.registerNib(UINib(nibName: "SGHomeViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId,forIndexPath: indexPath) as! SGHomeViewCell
        let model = HomeViewCellModel.init(dict: [
            "title": "3D Touch介绍：电子秤App与快捷操作",
            "description": "本文是一篇详细且具有实战意义的教程，涵盖几乎所有枚举知识点，为你解答 Swift 中枚举的应用场合以及使用方法。",
            "category": "Swift进阶",
            "translator": "小锅 | PPT",
            "commentCount": 123,
            "likeCount": 321,
            "author": "Maxime Defauw",
            "date": "2分钟前",
            "avatarUrl": "http://e.hiphotos.baidu.com/image/h%3D200/sign=a0901680a3c27d1eba263cc42bd4adaf/b21bb051f819861842d54ba04ded2e738bd4e600.jpg"
            ])
        cell.configureCell(model)
        return cell;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let articleDetailVC = SGArticleDetailViewController(nibName: "SGArticleDetailViewController", bundle: nil);
        self.navigationController?.pushViewController(articleDetailVC, animated: true)
        articleDetailVC.articleDetailInfoProtocol = self
    }
}

// MARK: - SGArticleDetailInfoProtocol
extension SGHomeViewController: SGArticleDetailInfoProtocol {
    
    func openArticle() -> SGArticleDetailInfo {
        var articleDetailInfo = SGArticleDetailInfo(id:"10", title: "为什么 Swift 中的 String API 如此难用？", url: "http://swift.gg/2016/01/25/friday-qa-2015-11-06-why-is-swifts-string-api-so-hard/", offset: 0.0, height: 0.0)
        let realm = try! Realm()
        if let articleDetailMetaData = realm.objects(SGAriticleDetailMetaData).filter("id == '10'").first {
            articleDetailInfo = articleDetailMetaData.getSGArticleDetailInfo()
        }
        
        return articleDetailInfo
    }
    
    func closeArticle(articleDetailInfo:SGArticleDetailInfo) {
        let realm = try! Realm()
        let articleDetailMetaData = SGAriticleDetailMetaData()
        articleDetailMetaData.setSGArticleDetailInfo(articleDetailInfo)
        try! realm.write {
            realm.add(articleDetailMetaData, update: true)
        }
    }
}