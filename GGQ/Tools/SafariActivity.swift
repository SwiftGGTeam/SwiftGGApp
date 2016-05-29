//
//  SafariActivity.swift
//  GGQ
//
//  Created by 宋宋 on 5/29/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit

class SafariActivity: UIActivity {
    
    private var url: NSURL?
    
    override func activityType() -> String? {
        return "\(SafariActivity.self)"
    }
    
    override func activityTitle() -> String? {
        return "在 Safari 中打开"
    }
    
    override func activityImage() -> UIImage? {
        return R.image.icon_safari()
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for activityItem in activityItems {
            if let _  = activityItem as? NSURL {
                return true
            }
        }
        
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems {
            if let activityItem = activityItem as? NSURL {
                url = activityItem
            }
        }
    }
    
    override func performActivity() {
        let completed = UIApplication.sharedApplication().openURL(url!)
        activityDidFinish(completed)
    }
    
}