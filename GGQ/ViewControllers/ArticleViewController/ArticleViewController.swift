//
//  ArticleViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources
import NSObject_Rx
import RxGesture

private typealias ArticleSectionModel = AnimatableSectionModel<Int, NSAttributedString>

final class ArticleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!

	var articleInfo: ArticleInfoObject!

	private var viewModel: ArticleViewModel!

	override func viewDidLoad() {

		title = articleInfo.title
		let width = UIScreen.mainScreen().bounds.width - 60
		let height = UIScreen.mainScreen().bounds.height - 60 - 44
		let size = CGSize(width: width, height: height)

		let ds = RxCollectionViewSectionedReloadDataSource<ArticleSectionModel>()
		ds.cellFactory = { [unowned self] ds, cv, ip, i in
			let cell = cv.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.articleCollectionViewCell, forIndexPath: ip)!
			cell.title = self.articleInfo.title
			cell.pageInfo = "\(ip.row + 1)/\(ds.sectionAtIndex(ip.section).model)"
			cell.contentText = i.identity
			return cell
		}

		viewModel = ArticleViewModel(articleInfo: articleInfo, contentSize: size)

		viewModel.elements.asObservable()
			.map { [ArticleSectionModel(model: $0.count, items: $0)] }
			.observeOn(.Main)
			.bindTo(collectionView.rx_itemsWithDataSource(ds))
			.addDisposableTo(rx_disposeBag)

		let ges = UITapGestureRecognizer()
		ges.rx_event
			.filter { $0.state == .Ended }
			.subscribeNext { [unowned self] _ in
				if let hidden = self.navigationController?.navigationBarHidden {
					self.navigationController?.setNavigationBarHidden(!hidden, animated: true)
				}
		}.addDisposableTo(rx_disposeBag)

		collectionView.addGestureRecognizer(ges)
	}

	override func viewWillAppear(animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
}

// MARK: - Preview Action

extension ArticleViewController {

	override func previewActionItems() -> [UIPreviewActionItem] {
		let afterPreviewAction = UIPreviewAction(title: "稍后阅读", style: .Default) { previewAction, viewController in
		}

		return [afterPreviewAction]
	}
}

// MARK: - Status Bar

extension ArticleViewController {

	override func prefersStatusBarHidden() -> Bool {
		return navigationController?.navigationBarHidden ?? true
	}

	override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
		return .Slide
	}
}
