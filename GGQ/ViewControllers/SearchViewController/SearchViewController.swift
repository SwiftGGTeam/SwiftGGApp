//
//  SearchViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

final class SearchViewController: UIViewController, SegueHandlerType {

	@IBOutlet private weak var searchBar: UISearchBar!

	@IBOutlet private weak var searchResultTableView: UITableView!

	@IBOutlet private weak var visualEffectView: UIVisualEffectView!

	private var viewModel: SearchViewModel!

	let dismissResult = Variable<ArticleInfoObject?>(nil)
    
    var searchText: String?

	enum SegueIdentifier: String {
		case ShowArticle
//        case ShowSearch
	}

	override func viewDidLoad() {
        
        searchBar.text = searchText
        
        searchResultTableView.estimatedRowHeight = 44
        searchResultTableView.rowHeight = UITableViewAutomaticDimension

		searchBar
            .rx_cancelButtonClicked
			.subscribeNext { [unowned self] in
				self.dismissViewControllerAnimated(true, completion: nil) }
			.addDisposableTo(rx_disposeBag)

        viewModel = SearchViewModel(
            searchText:
            searchBar.rx_text.asObservable()
        )

		viewModel.elements.asObservable()
			.bindTo(searchResultTableView.rx_itemsWithCellFactory) { tv, i, v in
				let indexPath = NSIndexPath(forRow: i, inSection: 0)
				let cell = tv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.searchTableViewCell, forIndexPath: indexPath)!
				cell.contentTitleLabel.text = v.title
				return cell }
			.addDisposableTo(rx_disposeBag)

		searchResultTableView
			.rx_modelSelected(ArticleInfoObject)
			.subscribeNext { [unowned self] article in
				self.dismissViewControllerAnimated(true) {
					self.dismissResult.value = article
		} }
			.addDisposableTo(rx_disposeBag)

	}

	override func viewWillDisappear(animated: Bool) {
		searchBar.resignFirstResponder()
	}

	override func viewDidAppear(animated: Bool) {
		searchBar.becomeFirstResponder()
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		switch segueIdentifierForSegue(segue) {
		case .ShowArticle:
			let articleManagerViewController = segue.destinationViewController.gg_castOrFatalError(ArticleManagerViewController.self)
			articleManagerViewController.articleInfo = castOrFatalError(sender)
		}
	}
}

extension SearchViewController: Routerable {
    var routingPattern: String {
        return GGConfig.Router.search
    }
    
    var routingIdentifier: String? {
        if let searchText = searchBar?.text {
            return GGConfig.Router.search + "/" + searchText
        } else {
            return GGConfig.Router.search
        }
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let topRoutable = RouterManager.topRouterable() where topRoutable.routingIdentifier != routingIdentifier else { return }
        if topRoutable.routingPattern == routingPattern {
            topRoutable.post(url, sender: sender)
            return
        }
        searchText = sender?["content"].string
        RouterManager.topViewController()?.showDetailViewController(self, sender: nil)
    }
    
    func post(url: NSURL, sender: JSON?) {
        searchBar.text = sender?["content"].string
    }
    
    
}
