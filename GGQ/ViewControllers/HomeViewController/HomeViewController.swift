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
import SwiftDate
import SwiftyJSON

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var searchButtonItem: UIBarButtonItem!

	@IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet weak var homeCollectionViewFlowLayout: HomeCollectionViewFlowLayout!
    

	var viewModel: HomeViewModel!

	private enum ModelType {
		case Element(HomeArticleInfoItem)
		case LoadMore
	}

	override func viewDidLoad() {
        
        let refresh = UIRefreshControl()
        collectionView.addSubview(refresh)
        
        let refreshTrigger = refresh.rx_controlEvent(.ValueChanged).asObservable()

		let loadMoreTrigger = rx_sentMessage(#selector(HomeViewController.collectionView(_: willDisplayCell: forItemAtIndexPath:)))
			.flatMapLatest { objects -> Observable<Void> in
				let objects = objects as [AnyObject]
				if let _ = objects[1] as? HomeLoadMoreCollectionViewCell {
					return Observable.just(())
				} else {
					return Observable.empty()
				}
		}

		viewModel = HomeViewModel(input: (
            loadMoreTrigger: loadMoreTrigger,
            refreshTrigger: refreshTrigger)
        )
        
		viewModel.elements.asObservable()
			.map { $0.map { ModelType.Element($0) } + [ModelType.LoadMore] }
			.bindTo(collectionView.rx_itemsWithCellFactory) { cv, i, v in
				let indexPath = NSIndexPath(forItem: i, inSection: 0)
				switch v {
				case .Element(let e):
					let cell = cv.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.homeCollectionViewCell, forIndexPath: indexPath)!
					cell.title = e.title
					cell.time = e.time//submitDate.toDateFromISO8601()
					cell.info = e.info//typeName + " " + e.translator
                    cell.preview = e.description//mdRender(markdown: e.articleDescription).string
                    cell.setNeedsLayout()
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
        
        viewModel.isRefreshing.asDriver()
            .drive(refresh.rx_refreshing)
            .addDisposableTo(rx_disposeBag)

		collectionView.rx_modelSelected(ModelType)
			.subscribeNext {
				if case .Element(let article) = $0 {
                    RouterManager.sharedRouterManager().openURL(article.url)
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
                    self.collectionView.scrollToItemAtIndexPath(ip, atScrollPosition: .CenteredVertically, animated: true)
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
        
        searchButtonItem.rx_tap
            .map { GGConfig.Router.Search.index() }
            .subscribeNext(RouterManager.sharedRouterManager().neverCareResultOpenURL)
            .addDisposableTo(rx_disposeBag)

        NSNotificationCenter.defaultCenter().rx_notification(UIDeviceOrientationDidChangeNotification)
            .map { _ in }
            .subscribeNext(collectionView.reloadData)
            .addDisposableTo(rx_disposeBag)
	}

	override func viewWillAppear(animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
}

// MARK: - UIViewControllerPreviewingDelegate

extension HomeViewController: UIViewControllerPreviewingDelegate {
	func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//		if let indexPath = collectionView.indexPathForItemAtPoint(location),
//			cellAttributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath) {
//				do {
//					if case .Element(let articleInfo) = try collectionView.rx_modelAtIndexPath(indexPath) as ModelType {
//						previewingContext.sourceRect = cellAttributes.frame
//						let articleViewController = R.storyboard.article.initialViewController()
//						articleViewController?.articleInfo = articleInfo
//						return articleViewController
//					}
//				} catch let error {
//					fatalError("\(error)")
//				}
//		}
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let modeType: ModelType = try! collectionView.rx_modelAtIndexPath(indexPath)
        
        switch modeType {
        case .Element(let articleInfo):
            
            let size = CGSize(width: collectionView.bounds.width - 40, height: collectionView.bounds.height)
            
            let titleHeight = articleInfo.title.boundingRectWithSize(size, options: [.TruncatesLastVisibleLine, .UsesFontLeading, .UsesLineFragmentOrigin], context: nil).height
            
            let descriptionHeight = articleInfo.description.boundingRectWithSize(size, options: [.TruncatesLastVisibleLine, .UsesFontLeading, .UsesLineFragmentOrigin], context: nil).height

            return CGSize(width: size.width, height: titleHeight + descriptionHeight + 3 * 15 + 2 * 17 + 30 * 2)
            
        case .LoadMore:
            return CGSize(width: collectionView.bounds.width - 30, height: 300)
        }

    }
    
}

extension HomeViewController: Routerable {
    
    var routingPattern: String {
        return GGConfig.Router.home
    }
    
    var routingIdentifier: String? {
        return GGConfig.Router.home
    }

    func get(url: NSURL, sender: JSON?) {
        Info("\(sender)")
        Info("\(url)")
    }
}
