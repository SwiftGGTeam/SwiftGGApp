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
import SwiftyJSON
import Kingfisher
import RxDataSources

private typealias ReadStatusSectionModel = AnimatableSectionModel<String, ArticleInfoObject>

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var articleStatusTableView: UITableView!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var profileViewModel: ProfileViewModel!
    private var readStatusViewModel: ReadStatusViewModel!
    
    
    override func viewDidLoad() {
        
        articleStatusTableView.estimatedRowHeight = 44
        articleStatusTableView.rowHeight = UITableViewAutomaticDimension
        
        profileViewModel = ProfileViewModel()
        readStatusViewModel = ReadStatusViewModel()
        
        profileViewModel.avatarURL
            .bindTo(avatarImageView.rx_imageURL)
            .addDisposableTo(rx_disposeBag)
        
        profileViewModel.userName
            .bindTo(userNameLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
        
        profileViewModel.logined
            .filter { !$0 }
            .map { _ in "未登录" }
            .bindTo(userNameLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
        
        #if !DEV
        profileViewModel.logined
            .bindTo(loginButton.rx_hidden)
            .addDisposableTo(rx_disposeBag)
        #endif
        
        let dataSource = RxTableViewSectionedReloadDataSource<ReadStatusSectionModel>()
        dataSource.configureCell = { ds, tv, ip, v in
            let cell = tv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.afterReadTableViewCell, forIndexPath: ip)!
            cell.title = v.title
            cell.category = v.typeName
            return cell
        }
        dataSource.titleForHeaderInSection = { ds, s in
            return ds.sectionAtIndex(s).identity
        }
        dataSource.canEditRowAtIndexPath = { ds, ip in
            return false
        }
        let afterReadSection = readStatusViewModel.afterReadElements
            .asObservable()
            .map { ReadStatusSectionModel(model: "稍后阅读", items: $0) }
        
        let readingSection = readStatusViewModel.readingElements
            .asObservable()
            .map { ReadStatusSectionModel(model: "正在阅读", items: $0) }
        
        let favoriteSection = readStatusViewModel.favoriteElements
            .asObservable()
            .map { ReadStatusSectionModel(model: "收藏", items: $0) }
        
        Observable.combineLatest(afterReadSection, readingSection, favoriteSection) { [$0, $1, $2] }
            .bindTo(articleStatusTableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(rx_disposeBag)
        
        articleStatusTableView
            .rx_modelSelected(ArticleInfoObject)
            .map { $0.convertURL() }
            .subscribeNext { url in
                RouterManager.sharedRouterManager().openURL(url)
            }
            .addDisposableTo(rx_disposeBag)
        
        articleStatusTableView.rx_itemDeleted.subscribeNext {
            Info("\($0)")
        }.addDisposableTo(rx_disposeBag)
        
        
        
    }

	override func viewWillAppear(animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
}

extension ProfileViewController: Routerable {
    
    var routingPattern: String {
        return GGConfig.Router.Profile.index
    }
    
    func post(url: NSURL, sender: JSON?) {
        Info("\(sender)")
        if let token = sender?["token"].string {
            profileViewModel.save(.GitHub, token: token)
        } else if url.path == GGConfig.Router.Profile.logout {
            avatarImageView.image = nil
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}