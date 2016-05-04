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

private enum CellType {
	case Article(NSAttributedString)
	case Loading
	case Footer
}

final class ArticleViewController: UIViewController {
    
    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var pageInfoLabel: UILabel!
    
    override func viewDidLoad() {
        
        rx_articleTitle.asObservable().observeOn(.Main).bindTo(contentTitleLabel.rx_text).addDisposableTo(rx_disposeBag)
        
        Observable.combineLatest(rx_currentPage.asObservable(), rx_pagerTotal.asObservable()) { "\($0)/\($1)" }.observeOn(.Main).bindTo(pageInfoLabel.rx_text).addDisposableTo(rx_disposeBag)
        
        rx_contentText.asObservable().observeOn(.Main).bindTo(contentTextView.rx_attributedText).addDisposableTo(rx_disposeBag)
        
    }
    
    let rx_currentPage = Variable(1)
    
    let rx_contentText = Variable(NSAttributedString(string: ""))
    
    let rx_pagerTotal = Variable(1)
    
    let rx_articleTitle = Variable("")
    
}

// MARK: - Preview Action

//extension ArticleViewController {
//	override func previewActionItems() -> [UIPreviewActionItem] {
//		let afterPreviewAction = UIPreviewAction(title: "稍后阅读", style: .Default) { previewAction, viewController in
//		}
//
//		return [afterPreviewAction]
//	}
//}

// MARK: - Status Bar

//extension ArticleViewController {
//	override func prefersStatusBarHidden() -> Bool {
//		return navigationController?.navigationBarHidden ?? true
//	}
//
//	override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
//		return .None
//	}
//}
