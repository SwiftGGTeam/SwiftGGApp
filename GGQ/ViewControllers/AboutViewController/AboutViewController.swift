//
//  AboutViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/13.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

private typealias AboutItem = (title: String, url: NSURL)

final class AboutViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private var versionInfoLabel: UILabel! {
        didSet {
            versionInfoLabel.text = "v" + Version.currentVersion + "(" + Version.buildVersion + ")"
        }
    }
    
    override func viewDidLoad() {
        let aboutItems: [AboutItem] = [
            AboutItem(title: "伟大的译者们", url: GGConfig.Router.About.Translators.index()),
            AboutItem(title: "我们在使用的第三方库", url: GGConfig.Router.About.Licences.index())
        ]
        
        Observable.just(aboutItems)
            .bindTo(tableView.rx_itemsWithCellFactory) { cv, i, v in
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let cell = cv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.aboutTableViewCell, forIndexPath: indexPath)!
                cell.textLabel?.text = v.title
                return cell
            }
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx_modelSelected(AboutItem)
            .map { $0.url }
            .subscribeNext(RouterManager.sharedRouterManager().neverCareResultOpenURL)
            .addDisposableTo(rx_disposeBag)
    }
}


extension AboutViewController: Routerable {
    
    var routingPattern: String {
        return GGConfig.Router.About.index
    }
    
    var routingIdentifier: String? {
        return GGConfig.Router.About.index
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let topRouterable = RouterManager.topRouterable() where routingIdentifier != topRouterable.routingIdentifier else { return }
        RouterManager.topViewController()?.showViewController(self, sender: nil)
    }
}