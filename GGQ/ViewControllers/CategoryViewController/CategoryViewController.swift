//
//  CategoryViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON

private typealias CategoryList = AnimatableSectionModel<String, ArticleInfoObject>

final class CategoryViewController: UIViewController {
    
	var category: CategoryObject!

	var viewModel: CategoryViewModel!

	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

	override func viewDidLoad() {
		title = category.name
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refresh = UIRefreshControl()
        tableView.addSubview(refresh)

        let refreshTrigger = refresh.rx_controlEvent(.ValueChanged).asObservable()
        
        let dataSource = RxTableViewSectionedReloadDataSource<CategoryList>()
        dataSource.configureCell = { ds, tb, ip, v in
            let cell = tb.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleTableViewCell, forIndexPath: ip)!
            cell.title = v.title
            cell.readPageInfo = v.readStatus
            return cell
        }
        dataSource.canEditRowAtIndexPath = { ds, ip in
            return false
        }
        
        viewModel = CategoryViewModel(refreshTrigger: refreshTrigger, loadMoreTrigger: tableView.rx_reachedBottom, category: category)

		viewModel.elements.asDriver()
            .map { [CategoryList(model: "", items: $0)] }
            .drive(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(rx_disposeBag)
        
        viewModel.isLoading.asDriver()
            .drive(indicatorView.rx_animating)
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx_modelSelected(ArticleInfoObject)
            .map { $0.contentUrl.stringByReplacingOccurrencesOfString("http://", withString: "swiftgg://") }
            .map { NSURL(string: $0)! }
            .subscribeNext(RouterManager.sharedRouterManager().neverCareResultOpenURL)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.hasNextPage.asDriver()
            .driveNext { [unowned self] hasNextPage in
                if !hasNextPage {
                    self.tableView.tableFooterView = nil
                }
            }
            .addDisposableTo(rx_disposeBag)
        
        viewModel.isRefreshing.asDriver()
            .drive(refresh.rx_refreshing)
            .addDisposableTo(rx_disposeBag)
        
	}
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

}

extension CategoryViewController: Routerable {
    
    var routingPattern: String {
        return GGConfig.Router.Categoties.index
    }
    
    var routingIdentifier: String? {
        if let id = category?.id {
            return GGConfig.Router.Categoties.index + "\(id)"
        } else {
            return GGConfig.Router.Categoties.index
        }
    }
    
    func get(url: NSURL, sender: JSON?) {
        
        guard let realm = try? Realm() else {
            Warning("Realm 挂了")
            return
        }

        if let name = sender?["name"].string,
            object = realm.objects(CategoryObject.self).filter(NSPredicate(format: "name = %@", name)).first where GGConfig.Router.Categoties.index + "\(object.id)" != routingIdentifier {
            category = object
        } else if let idString = sender?["id"].string,
            id = Int(idString),
            object = realm.objectForPrimaryKey(CategoryObject.self, key: id) where GGConfig.Router.Categoties.index + "\(object.id)" != routingIdentifier{
            category = object
        }
        
        if let _ = category {
            RouterManager.topViewController()?.showViewController(self, sender: nil)
        }
        
    }
}