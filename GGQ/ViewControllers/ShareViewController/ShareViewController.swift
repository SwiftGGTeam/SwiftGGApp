//
//  ShareViewController.swift
//  GGQ
//
//  Created by 宋宋 on 5/29/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import MobileCoreServices

class ShareController: Routerable {

    var routingPattern: String {
        return GGConfig.Router.Share.article
    }
    
    var routingIdentifier: String? {
        return nil
    }
    
    func get(url: NSURL, sender: JSON?) {
        Info("\(sender)")
        if let realm = try? Realm(),
            articleIDString = sender?["article_id"].string,
            articleID = Int(articleIDString),
            article = realm.objectForPrimaryKey(ArticleInfoObject.self, key: articleID) {
            let shareURL = NSURL(string: article.contentUrl)!
            let shareImage = R.image.icon_logo()!
            let shareName = article.title
            
            let itemProvider = NSItemProvider()
            itemProvider.registerItemForTypeIdentifier(kUTTypeURL as String) {
                completionHandler, expectedClass, options in
                completionHandler(shareURL, nil)
            }
            itemProvider.previewImageHandler = { completionHandler, expectedClass, options in
                completionHandler(shareImage, nil)
            }
            
            
            let vc = UIActivityViewController(activityItems: [shareImage, shareURL, shareName],
                                              applicationActivities: [SafariActivity()])
            RouterManager.topViewController()?.showDetailViewController(vc, sender: nil)
            
        }

    }
    
}
