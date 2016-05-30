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
import RxDataSources
import SwiftyJSON

final class SearchViewController: UIViewController {

	@IBOutlet private weak var searchBar: UISearchBar!

	@IBOutlet private weak var searchResultTableView: UITableView!

    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

	private var viewModel: SearchViewModel!
    
    var searchText: String?

	override func viewDidLoad() {
        
        searchBar.text = searchText
        
        searchResultTableView.estimatedRowHeight = 44
        searchResultTableView.rowHeight = UITableViewAutomaticDimension
        
        let search = (text: searchBar.rx_text.asObservable(), type: searchTypeSegmentedControl.rx_value.filter { $0 != 2 }.map { SearchType(rawValue: $0)! } )

        viewModel = SearchViewModel(search: search)
        
        viewModel.elements.asDriver()
            .drive(searchResultTableView.rx_itemsWithCellFactory) { tv, i, v in
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                switch v {
                case .All(let articleInfo):
                    let cell = tv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.searchContentTableViewCell, forIndexPath: indexPath)!
                    cell.title = articleInfo.title
                    let contentString = mdRender(markdown: articleInfo.content).string
                    cell.contentAttribute = NSMutableAttributedString(string: contentString)
                    return cell
                case .Content(let articleDetail):
                    let cell = tv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.searchContentTableViewCell, forIndexPath: indexPath)!
                    cell.title = articleDetail.content
                    return cell
                case .Title(let articleInfo):
                    let cell = tv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.searchTitleTableViewCell, forIndexPath: indexPath)!
                    cell.title = articleInfo.title
                    return cell
                }
            }
            .addDisposableTo(rx_disposeBag)

		searchResultTableView
			.rx_modelSelected(SearchResultType)
            .map { $0.openURL }
			.subscribeNext { [unowned self] url in
				self.dismissViewControllerAnimated(true) {
					RouterManager.sharedRouterManager().openURL(url)
                }
            }
			.addDisposableTo(rx_disposeBag)
        
        [NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillShowNotification).map { $0.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue().size.height },
            NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillHideNotification).map { _ in 0 }
            ].toObservable().merge()
            .subscribeNext { [unowned self] in
                self.bottomLayoutConstraint.constant = $0
            }
            .addDisposableTo(rx_disposeBag)
        
        searchBar
            .rx_cancelButtonClicked
            .subscribeNext { [unowned self] in
                self.dismissViewControllerAnimated(true, completion: nil) }
            .addDisposableTo(rx_disposeBag)
        
        let webSeg = searchTypeSegmentedControl.rx_value.filter { $0 == 2 }
        webSeg
            .withLatestFrom(searchBar.rx_text)
            .map { NSURL(string: "http://search.swift.gg/cse/search?s=4873498141517765035&q=" + $0)! }
            .subscribeNext(openSafari)
            .addDisposableTo(rx_disposeBag)

	}

	override func viewWillDisappear(animated: Bool) {
        // TODO: - 有搜索内容就不弹出键盘了
		searchBar.resignFirstResponder()
	}

	override func viewDidAppear(animated: Bool) {
		searchBar.becomeFirstResponder()
        searchTypeSegmentedControl.selectedSegmentIndex = 0
	}

}

extension SearchViewController: Routerable {
    var routingPattern: String {
        return GGConfig.Router.Search.index
    }
    
    var routingIdentifier: String? {
        if let searchText = searchBar?.text {
            return GGConfig.Router.Search.index + "/" + searchText
        } else {
            return GGConfig.Router.Search.index
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
