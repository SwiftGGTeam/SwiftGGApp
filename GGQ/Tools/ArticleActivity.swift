//
//  ArticleActivity.swift
//  GGQ
//
//  Created by 宋宋 on 6/7/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleActivity: UIActivity {

    private let articleID: Int
    private let action: Action
    
    enum Action: String {
        case Star = "star"
        case AfterRead = "afterRead"
        
        var title: String {
            switch self {
            case .Star:
                return "收藏"
            case .AfterRead:
                return "稍后阅读"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .Star:
                return R.image.icon_like()
            case .AfterRead:
                return R.image.icon_after_read()
            }
        }
    }
    
    init(id: Int, action: Action) {
        
        self.articleID = id
        self.action = action
        
        super.init()
    }
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityType() -> String? {
        return action.rawValue
    }
    
    override func activityTitle() -> String? {
        return action.title
    }
    
    override func activityImage() -> UIImage? {
        return action.image
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func performActivity() {
        guard let realm = try? Realm(),
        article = realm.objectForPrimaryKey(ArticleInfoObject.self, key: articleID) else {
            activityDidFinish(false)
            return
        }
        try! realm.write {
            switch action {
            case .Star:
                article.isFavorite.value = true
            case .AfterRead:
                article.readItLater.value = true
            }
        }
        activityDidFinish(true)
    }
}
