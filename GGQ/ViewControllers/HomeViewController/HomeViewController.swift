//
//  HomeViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import NSObject_Rx
import SwiftDate

final class HomeViewController: UIViewController, SegueHandlerType {
    
	@IBOutlet weak var collectionView: UICollectionView!

	var viewModel: HomeViewModel!

	enum SegueIdentifier: String {
		case ShowArticle
		case ShowSearch
	}

	private enum ModelType {
		case Element(ArticleInfoObject)
		case LoadMore
	}

	override func viewDidLoad() {
		let loadMore = rx_sentMessage(#selector(HomeViewController.collectionView(_: willDisplayCell: forItemAtIndexPath:)))
			.flatMapLatest { objects -> Observable<Void> in
				let objects = objects as [AnyObject]
				if let _ = objects[1] as? HomeLoadMoreCollectionViewCell {
					return Observable.just(())
				} else {
					return Observable.empty()
				}
		}

		viewModel = HomeViewModel(loadMoreTrigger: loadMore)

		viewModel.elements.asObservable()
			.map { $0.map { ModelType.Element($0) } + [ModelType.LoadMore] }
			.bindTo(collectionView.rx_itemsWithCellFactory) { cv, i, v in
				let indexPath = NSIndexPath(forItem: i, inSection: 0)
				switch v {
				case .Element(let e):
					let cell = cv.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.homeCollectionViewCell, forIndexPath: indexPath)!
					cell.title = e.title
					cell.time = e.submitDate.toDateFromISO8601()
					cell.info = e.typeName + " " + e.translator
					cell.preview = e.articleDescription
					cell.layoutIfNeeded()
					return cell
				case .LoadMore:
					let cell = cv.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.homeLoadMoreCollectionViewCell, forIndexPath: indexPath)!
					return cell
				}
		}.addDisposableTo(rx_disposeBag)
        
        viewModel.isRequestLatest.asDriver()
            .drive(UIApplication.sharedApplication().rx_networkActivityIndicatorVisible)
            .addDisposableTo(rx_disposeBag)

		collectionView.rx_modelSelected(ModelType)
			.subscribeNext { [unowned self] in
				if case .Element(let article) = $0 {
					self.performSegueWithIdentifier(.ShowArticle, sender: article)
				}
		}
			.addDisposableTo(rx_disposeBag)

		collectionView.rx_setDelegate(self)

		tabBarController?
			.rx_didSelectViewController
			.map { [unowned self] in $0 == self.navigationController } // 选择了"自己"
		.buffer(timeSpan: 0.6, count: 2, scheduler: MainScheduler.instance) // buffer 两个
		.filter { $0.count >= 2 } // 确保是在 0.6s 内点击两次
		.map { $0[0] == $0[1] } // 两次都是点击"自己"
		.subscribeNext { [unowned self] doubleClick in
			if doubleClick {
				let ip = NSIndexPath(forItem: 0, inSection: 0)
				self.collectionView.scrollToItemAtIndexPath(ip, atScrollPosition: .CenteredHorizontally, animated: true)
			}
		}
			.addDisposableTo(rx_disposeBag)

		registerForPreviewingWithDelegate(self, sourceView: collectionView)

		navigationItem.leftBarButtonItem?.rx_tap
			.subscribeNext { [unowned self] in
				let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
				let action1 = UIAlertAction(title: "全部显示", style: .Default, handler: nil)
				let action2 = UIAlertAction(title: "显示未读完", style: .Default, handler: nil)
				let action3 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)

				alert.addAction(action1)
				alert.addAction(action2)
				alert.addAction(action3)

				self.presentViewController(alert, animated: true, completion: nil)
		}.addDisposableTo(rx_disposeBag)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segueIdentifierForSegue(segue) {
		case .ShowArticle:
			let articleManagerViewController = segue.destinationViewController.gg_castOrFatalError(ArticleManagerViewController.self)
			let articleInfo: ArticleInfoObject = castOrFatalError(sender)
			articleManagerViewController.articleInfo = articleInfo
		case .ShowSearch:
			let searchViewController = segue.destinationViewController.gg_castOrFatalError(SearchViewController.self)
			searchViewController.snapshotView = tabBarController?.view.snapshotViewAfterScreenUpdates(false)
			searchViewController.dismissResult.asObservable()
				.filterNil()
				.subscribeNext { [unowned self] article in
					self.performSegueWithIdentifier(.ShowArticle, sender: article) }
				.addDisposableTo(rx_disposeBag)
		}
	}

	override func viewWillAppear(animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
}

// MARK: - UIViewControllerPreviewingDelegate

extension HomeViewController: UIViewControllerPreviewingDelegate {
	func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = collectionView.indexPathForItemAtPoint(location),
			cellAttributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath) {
				do {
					if case .Element(let articleInfo) = try collectionView.rx_modelAtIndexPath(indexPath) as ModelType {
						previewingContext.sourceRect = cellAttributes.frame
						let articleViewController = R.storyboard.article.initialViewController()
						articleViewController?.articleInfo = articleInfo
						return articleViewController
					}
				} catch let error {
					fatalError("\(error)")
				}
		}
		return nil
	}

	func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
		showViewController(viewControllerToCommit, sender: nil)
	}
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		if let cell = cell as? HomeLoadMoreCollectionViewCell {
			if !cell.activityIndicatorView.isAnimating() {
				cell.activityIndicatorView.startAnimating()
			}
		}
	}
}
