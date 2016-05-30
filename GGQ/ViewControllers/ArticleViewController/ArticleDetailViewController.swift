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
import PKHUD
import SafariServices

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
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
        view.layer.masksToBounds = true
        view.backgroundColor = R.color.gg.background()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 20).active = true
        view.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: -5).active = true
        view.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -5).active = true
        view.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor, constant: 10).active = true
        view.delegate = self
        return view
    }()
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(imageView, aboveSubview: self.backgroundContentView)
        imageView.contentMode = .ScaleAspectFit
        imageView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        imageView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        imageView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        imageView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        return imageView
    }()
    
    lazy var backgroundContentView: UIView = {
        let backgroundView = UIView()
        backgroundView.hidden = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = R.color.gg.lightBlack()
        backgroundView.alpha = 0.5
        self.view.addSubview(backgroundView)
        backgroundView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        backgroundView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        backgroundView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        return backgroundView
    }()
    
    override func viewDidLoad() {
        
        title = articleInfo.title
        
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
                self.navigationController?.hidesBarsOnTap = $0
            }
            .addDisposableTo(rx_disposeBag)
        
        textView.hidden = true
        textView.alpha = 0
        
        articleDetailViewModel.isLoading.asDriver()
            .driveNext { [unowned self] in
                switch $0 {
                case true:
                    HUD.show(.SystemActivity)
                case false:
                    HUD.hide(afterDelay: 0.15)
                    self.textView.hidden = false
                    UIView.animateWithDuration(0.3) {
                        self.textView.alpha = 1
                    }
                }
            }
            .addDisposableTo(rx_disposeBag)
        
        shareBarButtonItem.rx_tap
            .withLatestFrom(Observable.just(articleInfo.id))
            .map(GGConfig.Router.Share.article)
            .subscribeNext(RouterManager.sharedRouterManager().neverCareResultOpenURL)
            .addDisposableTo(rx_disposeBag)
        
        textView
            .rx_reachedBottom
            .filter { [unowned self] in
                self.textView.contentSize.height > 0
            }
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] in
                if let realm = self.articleInfo.realm {
                    try! realm.write {
                        self.articleInfo.hasBeenRead.value = true
                    }
                }
            }.addDisposableTo(rx_disposeBag)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let realm = articleInfo.realm {
            try! realm.write {
                articleInfo.isReading.value = true
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

extension ArticleDetailViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        if let image = textAttachment.image {
            Info("\(textAttachment)")

            let closeButtonAssets = CloseButtonAssets(normal: R.image.btn_close_write()!, highlighted: R.image.btn_close_write())
            let configuration = ImageViewerConfiguration(imageSize: image.size, closeButtonAssets: closeButtonAssets)
            let imageViewer = ImageViewer(configuration: configuration)
            imageViewer.image = image

            showDetailViewController(imageViewer, sender: nil)
        }

        return false
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        switch URL.scheme {
        case "swiftgg":
           RouterManager.sharedRouterManager().openURL(URL)
        case "http":
            fallthrough
        case "https":
            let sf = SFSafariViewController(URL: URL)
            showDetailViewController(sf, sender: nil)
        default:
            break
        }
        return false
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