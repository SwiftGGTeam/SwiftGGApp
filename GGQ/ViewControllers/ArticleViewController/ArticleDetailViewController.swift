//
//  ArticleDetailViewController.swift
//  GGQ
//
//  Created by 宋宋 on 5/27/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import RealmSwift

class ArticleDetailViewController: UIViewController {
    
    var articleInfo: ArticleInfoObject!
    
    var articleDetailViewModel: ArticleDetailViewModel!
    
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
        view.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -5).active = true
        view.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 5).active = true
        
        return view
    }()
    
    override func viewDidLoad() {
        articleDetailViewModel = ArticleDetailViewModel(articleInfo: articleInfo)
        
        articleDetailViewModel.contentAttributeText.asDriver()
            .drive(textView.rx_attributedText)
            .addDisposableTo(rx_disposeBag)
        
        [rx_sentMessage(#selector(ArticleDetailViewController.viewWillAppear(_:))).map { _ in true },
         rx_sentMessage(#selector(ArticleDetailViewController.viewWillDisappear(_:))).map { _ in false }]
            .toObservable()
            .merge()
            .subscribeNext { [unowned self] in
                self.navigationController?.hidesBarsOnSwipe = $0
            }
            .addDisposableTo(rx_disposeBag)
        
    }

}

// MARK: - Routerable

extension ArticleDetailViewController: Routerable {

    var routingPattern: String {
        return GGConfig.Router.article
    }
    
    var routingIdentifier: String? {
        if let id = articleInfo?.id {
            return String(id)
        }
        return nil
    }
    
    func get(url: NSURL, sender: JSON?) {
        
        if let urlStr = url.path,
            realm = try? Realm() {
            Info(urlStr)
            let predicate = NSPredicate(format: "contentUrl CONTAINS %@", urlStr)
            if let article = realm.objects(ArticleInfoObject).filter(predicate).first {
                
                if let topRouterable = RouterManager.topRouterable() where topRouterable.routingIdentifier == String(article.id) {
                    return
                }
                
                articleInfo = article
                RouterManager.topViewController()?.showViewController(self, sender: nil)
            }
        }
    }
}