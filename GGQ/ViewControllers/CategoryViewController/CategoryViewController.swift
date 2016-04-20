//
//  CategoryViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/15.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx
import RxOptional

//private typealias CategoryList = AnimatableSectionModel<String, ArticleInfoModel>

final class CategoryViewController: UIViewController {
	var category: CategoryObject!

	var viewModel: CategoryViewModel!

	private enum CategoryListType {
		case Element(ArticleInfoObject)
		case LoadMore
	}

	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var headerImageView: UIImageView!

	override func viewDidLoad() {
		title = category.name
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refresh = UIRefreshControl()
        tableView.addSubview(refresh)

		viewModel = CategoryViewModel(category: category)

		viewModel.elements.asObservable()
			.map { $0.map { CategoryListType.Element($0) } + [CategoryListType.LoadMore] }
			.bindTo(tableView.rx_itemsWithCellFactory) { tb, i, v in
				let indexPath = NSIndexPath(forRow: i, inSection: 0)
				switch v {
				case .Element(let info):
					let cell = tb.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleTableViewCell, forIndexPath: indexPath)!
					cell.title = info.title
					return cell
				case .LoadMore:
					let cell = tb.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleLoadMoreTableViewCell, forIndexPath: indexPath)!
					return cell
				}
		}
			.addDisposableTo(rx_disposeBag)
        
	}
}
