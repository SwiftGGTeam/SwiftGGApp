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

final class CategoryViewController: UIViewController, SegueHandlerType {
    
	var category: CategoryObject!

	var viewModel: CategoryViewModel!

    enum SegueIdentifier: String {
        case ShowArticle
    }

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
        
        let realm = try? Realm()
        
        let datasource = RxTableViewSectionedReloadDataSource<CategoryList>()
        datasource.configureCell = { ds, tb, ip, v in
            let cell = tb.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleTableViewCell, forIndexPath: ip)!
            cell.title = v.title
            if let realm = realm {
                
                if let article = realm.objectForPrimaryKey(ArticleDetailModel.self, key: v.id),
                    pagerTotal = article.pagerTotal.value,
                    currentPage = article.currentPage.value {
                    cell.readPageInfo = "\(currentPage)/\(pagerTotal)"
                } else {
                    cell.readPageInfo = "未读"
                }
                
            }
            return cell
        }
        
		viewModel = CategoryViewModel(refreshTrigger: refreshTrigger, loadMoreTrigger: tableView.rx_reachedBottom, category: category)

		viewModel.elements.asDriver()
            .map { [CategoryList(model: "", items: $0)] }
            .drive(tableView.rx_itemsWithDataSource(datasource))
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
        return GGConfig.Router.categotie
    }
    
    var routingIdentifier: String? {
        return category?.name
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let categoryName = sender?["category_name"].string,
            realm = try? Realm(),
            object = realm.objects(CategoryObject.self).filter(NSPredicate(format: "name = %@", categoryName)).first where object.name != routingIdentifier else {
                return
        }
        category = object
        RouterManager.topViewController()?.showViewController(self, sender: nil)
        
    }
}