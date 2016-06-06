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
            
            let weichatShareInfo = MonkeyKingX.Info(appID: GGConfig.Share.Weichat.appID, title: shareName, description: shareDescription, thumbnail: shareImage, media: .URL(shareURL))
            
            let shareMessge = MonkeyKingX.Message.WeChat(.Session(info: weichatShareInfo))
            
            let weChatSessionActivity = ShareActivity(
                type: "gg.swift.WeChat.Session",
                title: "发送给朋友",
                image: R.image.wechat_session()!,
                message: shareMessge
            )
            
            let timelineMessage = MonkeyKingX.Message.WeChat(.Timeline(info: weichatShareInfo))
            
            let weChatTimelineActivity = ShareActivity(
                type: "gg.swift.WeChat.Timeline",
                title: "分享到朋友圈",
                image: R.image.wechat_timeline()!,
                message: timelineMessage
            )
            
            let weiboShareInfo = MonkeyKingX.Info(appID: GGConfig.Share.Weibo.appID, title: shareName, description: shareDescription, thumbnail: shareImage, media: .URL(shareURL))
            
            let weiboMessage = MonkeyKingX.Message.Weibo(.Default(info: weiboShareInfo, accessToken: KeychainService.read(.Weibo)))
            
            let weiboActivity = ShareActivity(
                type: "gg.swift.Weibo",
                title: "分享到微博",
                image: R.image.weibo()!,
                message: weiboMessage
            )
            
            let qqShareInfo = MonkeyKingX.Info(appID: GGConfig.Share.QQ.appID, title: shareName, description: shareDescription, thumbnail: shareImage, media: .URL(shareURL))
            
            let qqFriendsMessage = MonkeyKingX.Message.QQ(.Friends(info: qqShareInfo))
            
            let qqFriendsMessageActivity = ShareActivity(
                type: "gg.swift.QQ",
                title: "分享给 QQ 好友",
                image: R.image.qQ()!,
                message: qqFriendsMessage
            )
            
            let qqZoneMessage = MonkeyKingX.Message.QQ(.Zone(info: qqShareInfo))
            
            let qqZoneMessageActivity = ShareActivity(
                type: "gg.swift.QQZone",
                title: "分享到 QQ 空间",
                image: R.image.qzone()!,
                message: qqZoneMessage
            )
            
            let starActivity = ArticleActivity(id: articleID, action: .Star)
            let afterReadActivity = ArticleActivity(id: articleID, action: .AfterRead)
            
            let vc = UIActivityViewController(activityItems: [shareImage, shareURL, shareName],
                                              applicationActivities: [SafariActivity(), weChatSessionActivity, weChatTimelineActivity, weiboActivity, qqFriendsMessageActivity, qqZoneMessageActivity, starActivity, afterReadActivity])
            RouterManager.topViewController()?.showDetailViewController(vc, sender: nil)
            
        }

    }
    
}
