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
import Kingfisher

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        
        viewModel = ProfileViewModel()
        
        viewModel.avatarURL
            .subscribeNext { [unowned self] in
                self.avatarImageView.kf_setImageWithURL($0)
            }
            .addDisposableTo(rx_disposeBag)
        
        viewModel.userName
            .bindTo(userNameLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.logined.filter { !$0 }
            .map { _ in "未登录" }
            .bindTo(userNameLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
    }

	override func viewWillAppear(animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
}

extension ProfileViewController: Routerable {
    var routerIdentifier: String {
        return "profile"
    }
    
    func post(url: NSURL, sender: JSON?) {
        log.info("\(sender)")
        if let token = sender?["token"].string {
            viewModel.save(.GitHub, token: token)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}