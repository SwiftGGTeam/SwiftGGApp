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
            let shareName = article.title + GGConfig.Share.footerMessage
            
            let itemProvider = NSItemProvider()
            itemProvider.registerItemForTypeIdentifier(kUTTypeURL as String) {
                completionHandler, expectedClass, options in
                completionHandler(shareURL, nil)
            }
            itemProvider.previewImageHandler = { completionHandler, expectedClass, options in
                completionHandler(shareImage, nil)
            }
            
            let shareDescription = article.praseMDArticleDescription()
                .stringByReplacingOccurrencesOfString(" ", withString: "")
                .stringByReplacingOccurrencesOfString("\n", withString: "")
            
            let shareInfo = MonkeyKingX.Info(appID: GGConfig.Share.Weichat.appID, title: shareName, description: shareDescription, thumbnail: shareImage, media: .URL(shareURL))
            
            let shareMessge = MonkeyKingX.Message.WeChat(.Session(info: shareInfo))
            
            let weChatSessionActivity = ShareActivity(
                type: "gg.swift.WeChat.Session",
                title: "发送给朋友",
                image: R.image.wechat_session()!,
                message: shareMessge
            )
            
            let timelineMessage = MonkeyKingX.Message.WeChat(.Timeline(info: shareInfo))
            
            let weChatTimelineActivity = ShareActivity(
                type: "gg.swift.WeChat.Timeline",
                title: "分享到朋友圈",
                image: R.image.wechat_timeline()!,
                message: timelineMessage
            )
            
            let vc = UIActivityViewController(activityItems: [shareImage, shareURL, shareName],
                                              applicationActivities: [SafariActivity(), weChatSessionActivity, weChatTimelineActivity])
            RouterManager.topViewController()?.showDetailViewController(vc, sender: nil)
            
        }

    }
    
}
