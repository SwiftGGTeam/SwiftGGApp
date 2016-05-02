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
import NSObject_Rx
import RxOptional

final class SearchViewController: UIViewController, SegueHandlerType {

	@IBOutlet private weak var searchBar: UISearchBar!

	@IBOutlet private weak var searchResultTableView: UITableView!

	@IBOutlet private weak var visualEffectView: UIVisualEffectView!

	private var viewModel: SearchViewModel!

	let dismissResult = Variable<ArticleInfoObject?>(nil)

	var snapshotView: UIView?

	enum SegueIdentifier: String {
		case ShowArticle
//        case ShowSearch
	}

	override func viewDidLoad() {

		searchBar
			.rx_searchBarCancelButtonClicked
			.subscribeNext { [unowned self] in
				self.dismissViewControllerAnimated(true, completion: nil) }
			.addDisposableTo(rx_disposeBag)

		viewModel = SearchViewModel(searchText: searchBar.rx_text.debounce(0.3, scheduler: MainScheduler.instance))

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

//        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//            searchResultTableView.backgroundColor = UIColor.clearColor()
////            let blurEffect = UIBlurEffect(style: .Light)
////            let blurEffectView = UIVisualEffectView(effect: blurEffect)
////            searchResultTableView.backgroundView = blurEffectView
//
//            // if inside a popover
//            if let popover = navigationController?.popoverPresentationController {
//                popover.backgroundColor = UIColor.clearColor()
//            }
//
//            // if you want translucent vibrant table view separator lines
//            searchResultTableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
//        }

		if let snapshotView = snapshotView {
			view.insertSubview(snapshotView, atIndex: 0)
			snapshotView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
			snapshotView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
			snapshotView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
			snapshotView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
		}
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
