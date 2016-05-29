//
//  TranslatorsViewController.swift
//  GGQ
//
//  Created by 宋宋 on 5/30/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

private typealias TranslatorItem = (name: String, url: NSURL?)

class TranslatorsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        guard let rawTranslatorItems = NSArray(contentsOfURL: R.file.translatorsPlist()!) as? Array<Dictionary<String, String>> else { return }
        
        
        let translatorItems = rawTranslatorItems
            .flatMap { rawTranslatorItem -> TranslatorItem? in
                guard let name = rawTranslatorItem["name"] else {
                    return nil
                }
                if let urlString = rawTranslatorItem["blog"],
                    url = NSURL(string: urlString) {
                    return TranslatorItem(name: name, url: url)
                } else {
                    return TranslatorItem(name: name, url: nil)
                }
            }
        
        Observable.just(translatorItems)
            .bindTo(tableView.rx_itemsWithCellFactory) { cv, i, v in
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let cell = cv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.translatorTableViewCell, forIndexPath: indexPath)!
                cell.textLabel?.text = v.name
                return cell
            }
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx_modelSelected(TranslatorItem)
            .map { $0.url }
            .filterNil()
            .subscribeNext(openSafari)
            .addDisposableTo(rx_disposeBag)
        
    }

}


extension TranslatorsViewController: Routerable {
    var routingPattern: String {
        return GGConfig.Router.About.Translators.index
    }
    
    var routingIdentifier: String? {
        return GGConfig.Router.About.Translators.index
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let topRoutable = RouterManager.topRouterable() where topRoutable.routingIdentifier != routingIdentifier else { return }
        RouterManager.topViewController()?.showViewController(self, sender: nil)
    }
}