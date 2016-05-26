//
//  AboutViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/13.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import SwiftyJSON

final class AboutViewController: UIViewController {

    @IBOutlet private var versionInfoLabel: UILabel! {
        didSet {
            versionInfoLabel.text = "v" + Version.currentVersion + "(" + Version.buildVersion + ")"
        }
    }
}


extension AboutViewController: Routerable {
    
    var routingPattern: String {
        return GGConfig.Router.about
    }
    
    var routingIdentifier: String? {
        return GGConfig.Router.about
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let topRouterable = RouterManager.topRouterable() where routingIdentifier != topRouterable.routingIdentifier else { return }
        RouterManager.topViewController()?.showViewController(self, sender: nil)
    }
}