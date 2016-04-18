//
//  AboutViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/13.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {

    @IBOutlet private var versionInfoLabel: UILabel! {
        didSet {
            versionInfoLabel.text = "v" + Version.currentVersion + "(" + Version.buildVersion + ")"
        }
    }
}
