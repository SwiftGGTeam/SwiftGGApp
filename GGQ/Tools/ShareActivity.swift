//
//  ShareActivity.swift
//  GGQ
//
//  Created by 宋宋 on 5/30/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit

class ShareActivity: UIActivity {
    
    private let type: String
    private let title: String
    private let image: UIImage
    private let message: MonkeyKingX.Message
    
    init(type: String, title: String, image: UIImage, message: MonkeyKingX.Message) {
        
        self.type = type
        self.title = title
        self.image = image
        self.message = message
        
        super.init()
    }
    
    override class func activityCategory() -> UIActivityCategory {
        return .Share
    }
    
    override func activityType() -> String? {
        return type
    }
    
    override func activityTitle() -> String? {
        return title
    }
    
    override func activityImage() -> UIImage? {
        return image
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func performActivity() {
        MonkeyKingX.shareMessage(message)
        activityDidFinish(true)
    }
}
