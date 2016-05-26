//
//  LoginViewController.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/22.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import SwiftyJSON
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var weiboButton: UIButton!

    @IBOutlet weak var wechatButton: UIButton!
    
    @IBOutlet weak var githubButton: UIButton!
    
    override func viewDidLoad() {
        
        githubButton.rx_tap
            .doOnNext { HUD.show(.Label("请求 GitHub 认证…")) }
            .flatMap { GGProvider.request(GitHubOAuthAPI.Authorize) }
            .doOnError { HUD.flash(.LabeledError(title: "\($0._code)", subtitle: nil), delay: 0.3) }
            .doOnNext { _ in HUD.hide(afterDelay: 0.3) }
            .subscribeNext { [unowned self] in
                if let url = $0.response?.URL {
                    let sf = SFSafariViewController(URL: url)
                    self.showDetailViewController(sf, sender: nil)
                }
            }
            .addDisposableTo(rx_disposeBag)
        
        navigationItem.leftBarButtonItem?.rx_tap
            .subscribeNext { [unowned self] in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(rx_disposeBag)
        
        
    }

}


extension LoginViewController: Routerable {
    
    var routingPattern: String {
        return GGConfig.Router.oauth
    }
    
    func post(url: NSURL, sender: JSON?) {
        dismissViewControllerAnimated(true, completion: nil)
        if let code = url.query?.componentsSeparatedByString("&").first?.componentsSeparatedByString("=")[1] {
            HUD.show(.Progress)
            GGProvider.request(GitHubOAuthAPI.AccessToken(code: code)).mapJSON()
                .subscribe { event in
                    switch event {
                    case .Next(let json):
                        if let token = json["access_token"].string {
                            HUD.flash(.Label("请求成功"), delay: 0.6)
                            let url = NSURL(string: "swiftgg://swift.gg/profile/github/\(token)")!
                            RouterManager.sharedRouterManager().openURL(url)
                        } else {
                            HUD.flash(.Label("请求失败"), delay: 0.6)
                        }
                    case .Error:
                        HUD.flash(.Label("请求失败"), delay: 0.6)
                    case .Completed:
                        HUD.hide()
                    }
                }
                .addDisposableTo(rx_disposeBag)
        }
    }
}