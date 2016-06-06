//
//  LicencesViewController.swift
//  GGQ
//
//  Created by 宋宋 on 5/30/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

private typealias LicenceItem = (name: String, url: NSURL?)

class LicencesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        guard let rawLicenceItems = NSArray(contentsOfURL: R.file.licencesPlist()!) as? Array<Dictionary<String, String>> else { return }
        
        let licenceItems = rawLicenceItems
            .flatMap { rawTranslatorItem -> LicenceItem? in
                guard let name = rawTranslatorItem["name"] else {
                    return nil
                }
                if let urlString = rawTranslatorItem["link"],
                    url = NSURL(string: urlString) {
                    return LicenceItem(name: name, url: url)
                } else {
                    return LicenceItem(name: name, url: nil)
                }
        }
        
        Observable.just(licenceItems)
            .bindTo(tableView.rx_itemsWithCellFactory) { cv, i, v in
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let cell = cv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.licenceTableViewCell, forIndexPath: indexPath)!
                cell.textLabel?.text = v.name
                return cell
            }
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx_modelSelected(LicenceItem)
            .map { $0.url }
            .filterNil()
            .subscribeNext(openSafari)
            .addDisposableTo(rx_disposeBag)
        
    }


}

extension LicencesViewController: Routerable {
    var routingPattern: String {
        return GGConfig.Router.About.Licences.index
    }
    
    var routingIdentifier: String? {
        return GGConfig.Router.About.Licences.index
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let topRoutable = RouterManager.topRouterable() where topRoutable.routingIdentifier != routingIdentifier else { return }
        RouterManager.topViewController()?.showViewController(self, sender: nil)
    }
}
