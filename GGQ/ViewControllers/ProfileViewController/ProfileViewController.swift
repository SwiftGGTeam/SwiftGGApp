//
//  ProfileViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/12.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import NSObject_Rx
import SwiftyJSON

final class ProfileViewController: UIViewController {

	override func viewWillAppear(animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
}

extension ProfileViewController: Routerable {
    var routerIdentifier: String {
        return "profile"
    }
    
    func post(url: NSURL, sender: JSON?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}