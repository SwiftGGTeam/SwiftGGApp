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
import RealmSwift

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
        
//        weiboButton.rx_tap
//            .doOnNext { HUD.show(.Label("请求微博认证…")) }
//            .flatMap { GGProvider.request(WeiboWeiOAuthAPI.Authorize) }
//            .doOnError { HUD.flash(.LabeledError(title: "\($0._code)", subtitle: nil), delay: 0.3) }
//            .doOnNext { _ in HUD.hide(afterDelay: 0.3) }
//            .subscribeNext { [unowned self] response in
//                Info("\(response)")
//                if let url = response.response?.URL {
//                    let sf = SFSafariViewController(URL: url)
//                    self.showDetailViewController(sf, sender: nil)
//                }
//            }
//            .addDisposableTo(rx_disposeBag)

        weiboButton.rx_tap
            .map { GGOAuthService.OAuthType.Weibo(appID: GGConfig.OAuth.Weibo.client_id, appKey: GGConfig.OAuth.Weibo.client_secret, redirectURL: GGConfig.OAuth.Weibo.callback_url) }
            .subscribeNext { type in
                GGOAuthService.oauth(type)
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
        
        let json = handleURL(url)
        
        if let code = json["code"].string { // GitHub
            dismissViewControllerAnimated(true, completion: nil)
            HUD.show(.Progress)
            GGProvider.request(GitHubOAuthAPI.AccessToken(code: code)).mapJSON()
                .subscribe { event in
                    switch event {
                    case .Next(let json):
                        if let token = json["access_token"].string {
                            HUD.flash(.Label("请求成功"), delay: 0.6)
                            let url = GGConfig.Router.Profile.token(type: "github", token: token)
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
        } else if let id = json["id"].string { // Weibo

            guard let items = UIPasteboard.generalPasteboard().items as? [[String: AnyObject]] else {
                return
            }

            var results = [String: AnyObject]()

            for item in items {
                for (key, value) in item {
                    if let valueData = value as? NSData where key == "transferObject" {
                        results[key] = NSKeyedUnarchiver.unarchiveObjectWithData(valueData)
                    }
                }
            }

            guard let responseData = results["transferObject"] as? [String: AnyObject],
                let type = responseData["__class"] as? String else {
                    return
            }
            
            guard let statusCode = responseData["statusCode"] as? Int else {
                return
            }

            guard let accessToken = responseData["accessToken"] as? String else {
                return
            }
            
            guard let userID = responseData["userID"] as? String else {
                return
            }
            
            KeychainService.save(.Weibo, token: accessToken)
            
            GGProvider
                .request(WeiboAPI.Show(userID: userID))
                .mapJSON()
                .subscribeNext { [unowned self] userInfo in
                    Info("Weibo: \(userInfo)")
                    let realm = try! Realm()
                    try! realm.write {
                        realm.create(UserModel.self, value: userInfo.object, update: true)
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                .addDisposableTo(rx_disposeBag)
        }
        
    }
}