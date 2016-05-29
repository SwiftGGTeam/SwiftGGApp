//
//  UIViewController+Router.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/22.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

//extension UIViewController: Routerable {
//    var routerIdentifier: String {
//        return "404"
//    }
//    
//    func post(url: NSURL, sender: JSON?)  {
//        print("WARNING")
//    }
//}

extension UIViewController {
    func openSafari(url: NSURL) {
        let sf = SFSafariViewController(URL: url)
        sf.view.tintColor = R.color.gg.black()
        showDetailViewController(sf, sender: nil)
    }
}