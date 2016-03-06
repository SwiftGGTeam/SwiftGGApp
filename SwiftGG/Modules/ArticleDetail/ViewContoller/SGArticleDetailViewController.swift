//
//  SGArticleDetailViewController.swift
//  MBArticleViewForSwiftGGApp
//
//  Created by Perry on 16/1/19.
//  Copyright © 2016年 MmoaaY. All rights reserved.
//

import UIKit
import Neon
import WebKit
import RxSwift
import RxCocoa

protocol SGArticleDetailInfoProtocol: class {
    func openArticle() -> SGArticleDetailInfo
    func closeArticle(articleDetailInfo:SGArticleDetailInfo)
}

public extension WKWebView {
    public var rx_canGoBack: Observable<Bool> {
        return Observable.just(canGoBack)
    }
    
    public var rx_canGoForward: Observable<Bool> {
        return Observable.just(canGoForward)
    }
}

extension SGArticleDetailViewController {
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        self.recordOffset()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if webView.URL?.absoluteString == self.articleDetailInfo?.url {
            let js = "$('body').scrollTop(" + (self.articleDetailInfo?.getOffset())! + ")"
            articleContentView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
    
    private func recordOffset() {
        if articleContentView.URL?.absoluteString == self.articleDetailInfo?.url {
            articleContentView.evaluateJavaScript("$('body').scrollTop()", completionHandler: { (AnyObject, NSError) -> Void in
                if let offset:Double = AnyObject as? Double {
                    self.articleDetailInfo?.offset = offset
                    self.articleDetailInfo?.height = Double(self.articleContentView.scrollView.contentSize.height)
                    self.articleDetailInfoProtocol?.closeArticle(self.articleDetailInfo!)
                }
            })
        }
    }
}

extension SGArticleDetailViewController {
    func backPressed() {
        if articleContentView.canGoBack {
            articleContentView.goBack()
        }
    }
    func forwardPressed() {
        if articleContentView.canGoForward {
            articleContentView.goForward()
        }
    }
}

class SGArticleDetailViewController: UIViewController, WKNavigationDelegate, SGArticleDetailToolBarProtocol {
    
    weak var articleDetailInfoProtocol : SGArticleDetailInfoProtocol?
    
    var articleDetailInfo: SGArticleDetailInfo?
    
    var articleContentView: WKWebView!
    
    var articleDetailToolBar: SGArticleDetailToolBar?
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        initArticleContentView()
        
        setupNavigationBar()
        
        setupArticleDetailToolBar()
    }
    
    // MARK: Helper Methods
    private func initArticleContentView() {
        // 设置webView
        articleContentView = WKWebView()
        view.insertSubview(articleContentView, atIndex: 0)
        articleContentView.allowsBackForwardNavigationGestures = true
        articleContentView.navigationDelegate = self
        
        if let articleDetail = articleDetailInfoProtocol?.openArticle() {
            articleDetailInfo = articleDetail
            
            title = articleDetail.title
            
            let url = NSURL(string: articleDetail.url)
//            let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: NSTimeInterval(30))
            let request = NSURLRequest(URL: url!)
            articleContentView.loadRequest(request)
        }
    }
    
    private func setupArticleDetailToolBar () {
        articleDetailToolBar = SGArticleDetailToolBar()
        articleDetailToolBar?.delegate = self
        view.addSubview((articleDetailToolBar?.backButton)!)
        view.addSubview((articleDetailToolBar?.forwardButton)!)
        
//        articleContentView.rx_canGoBack
//            .bindTo((articleDetailToolBar?.backButton)!.rx_enabled)
//            .addDisposableTo(disposeBag)
//        articleContentView.rx_canGoForward
//            .bindTo((articleDetailToolBar?.forwardButton)!.rx_enabled)
//            .addDisposableTo(disposeBag)
    }
    
    // WARN:neon框架需要在autolayout渲染完之后再使用
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        articleContentView.fillSuperview()
        articleDetailToolBar?.backButton.anchorToEdge(.Left, padding: 0, width: 50, height: 50)
        articleDetailToolBar?.forwardButton.anchorToEdge(.Right, padding: 0, width: 50, height: 50)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "back_white")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: Selector("back"))
    }
    
    
    func back() {
        self.recordOffset()
        navigationController!.popViewControllerAnimated(true)
    }
}
