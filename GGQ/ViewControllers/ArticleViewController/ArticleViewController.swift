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
import RxDataSources
import RxGesture

private typealias ArticleSectionModel = AnimatableSectionModel<Int, NSAttributedString>

private enum CellType {
	case Article(NSAttributedString)
	case Loading
	case Footer
}

final class ArticleViewController: UIViewController {
    
    let rx_currentPage = Variable(1)
    
    let rx_contentText = Variable(NSAttributedString(string: ""))
    
    let rx_pagerTotal = Variable(1)
    
    let rx_articleTitle = Variable("")
    
    let rx_currentReadPage = PublishSubject<Int>()
    
    @IBOutlet private weak var contentTitleLabel: UILabel!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var pageInfoLabel: UILabel!
    
    lazy var textView: UITextView = {
        let textStorage = NSTextStorage()
        let layoutManager = GGLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        let view = UITextView(frame: CGRect.zero, textContainer: textContainer)
        view.editable = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        view.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        
        return view
    }()
    
    override func viewDidLoad() {
        
        rx_articleTitle.asObservable()
            .observeOn(.Main)
            .bindTo(contentTitleLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
        
        Observable.combineLatest(rx_currentPage.asObservable(), rx_pagerTotal.asObservable()) { "\($0)/\($1)" }
            .observeOn(.Main)
            .bindTo(pageInfoLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
        
        rx_contentText.asObservable()
            .observeOn(.Main)
            .bindTo(textView.rx_attributedText)
            .addDisposableTo(rx_disposeBag)
        
        rx_sentMessage(#selector(ArticleViewController.viewDidAppear(_:)))
            .withLatestFrom(rx_currentPage.asObservable())
            .bindTo(rx_currentReadPage)
            .addDisposableTo(rx_disposeBag)
        
    }
    
}
