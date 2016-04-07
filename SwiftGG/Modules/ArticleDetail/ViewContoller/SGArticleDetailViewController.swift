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
import SafariServices

protocol SGArticleDetailDataSource: class {
    func articleDetailModel() -> SGArticleDetailInfo
}

protocol SGArticleDetailDelegate: class {
    func didCloseArticle(article:SGArticleDetailInfo)
}

public extension WKWebView {
    public var rx_canGoBack: Observable<Bool> {
        return Observable.just(canGoBack)
    }
    
    public var rx_canGoForward: Observable<Bool> {
        return Observable.just(canGoForward)
    }
}

extension SGArticleDetailViewController:UIScrollViewDelegate {
    private func setupScrollView() {
        articleContentWebView.scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > lastContentOffset && scrollView.contentOffset.y >= 40.0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension SGArticleDetailViewController:SFSafariViewControllerDelegate,WKNavigationDelegate {
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        recordOffset()
        if webView.URL?.absoluteString != articleDetailInfo?.url {
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(URL:webView.URL!, entersReaderIfAvailable:true)
                svc.delegate = self
                presentViewController(svc, animated:true, completion: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.sharedApplication().openURL(webView.URL!)
            }
        }
    }
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        if webView.URL?.absoluteString == articleDetailInfo?.url {
            decisionHandler(WKNavigationResponsePolicy.Allow)
        } else {
            decisionHandler(WKNavigationResponsePolicy.Cancel)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if webView.URL?.absoluteString == articleDetailInfo?.url {
            let js = "$('body').scrollTop(" + articleDetailInfo!.getOffset() + ")"
            articleContentWebView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
    
    func backPressed() {
        if articleContentWebView.canGoBack {
            articleContentWebView.goBack()
        }
    }
    func forwardPressed() {
        if articleContentWebView.canGoForward {
            articleContentWebView.goForward()
        }
    }
    
    private func recordOffset() {
        if articleContentWebView.URL?.absoluteString == articleDetailInfo?.url {
            articleContentWebView.evaluateJavaScript("$('body').scrollTop()", completionHandler: { [unowned self] (AnyObject, NSError) -> Void in
                if let offset:Double = AnyObject as? Double {
                    self.articleDetailInfo?.offset = offset
                    self.articleDetailInfo?.height = Double(self.articleContentWebView.scrollView.contentSize.height)
                    self.delegate?.didCloseArticle(self.articleDetailInfo!)
                }
            })
        }
    }
    
    // MARK: Helper Methods
    private func setupArticleContentView() {
        // 设置webView
        articleContentWebView = WKWebView()
        view.insertSubview(articleContentWebView, atIndex: 0)
        articleContentWebView.allowsBackForwardNavigationGestures = true
        articleContentWebView.navigationDelegate = self
        
        if let articleDetail = dataSource?.articleDetailModel() {
            articleDetailInfo = articleDetail
            
            title = articleDetail.title
            
            let url = NSURL(string: articleDetail.url)
            //            let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: NSTimeInterval(30))
            let request = NSURLRequest(URL: url!)
            articleContentWebView.loadRequest(request)
        }
    }

}

extension SGArticleDetailViewController: SGArticleDetailToolBarProtocol {
    private func setupArticleDetailToolBar () {
        articleDetailToolBar = SGArticleDetailToolBar()
        articleDetailToolBar?.delegate = self
        view.addSubview(articleDetailToolBar!.backButton)
        view.addSubview(articleDetailToolBar!.forwardButton)
        
        articleContentWebView.rx_canGoBack
            .bindTo(articleDetailToolBar!.backButton.rx_enabled)
            .addDisposableTo(disposeBag)
        articleContentWebView.rx_canGoForward
            .bindTo(articleDetailToolBar!.forwardButton.rx_enabled)
            .addDisposableTo(disposeBag)
    }
}

class SGArticleDetailViewController: UIViewController {
    
    weak var dataSource : SGArticleDetailDataSource?

    weak var delegate : SGArticleDetailDelegate?

    var articleDetailInfo: SGArticleDetailInfo?
    
    var articleContentWebView: WKWebView!
    
    var articleDetailToolBar: SGArticleDetailToolBar?
    
    var disposeBag = DisposeBag()
    
    var lastContentOffset:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupArticleContentView()
        
        setupNavigationBar()
        
        setupScrollView()
        
//        setupArticleDetailToolBar()
    }
    
    // WARN:neon框架需要在autolayout渲染完之后再使用
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        articleContentWebView.fillSuperview()
        articleDetailToolBar?.backButton.anchorToEdge(.Left, padding: 0, width: 50, height: 50)
        articleDetailToolBar?.forwardButton.anchorToEdge(.Right, padding: 0, width: 50, height: 50)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "back_white")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: #selector(SGArticleDetailViewController.back))
    }

    func back() {
        recordOffset()
        navigationController!.popViewControllerAnimated(true)
    }

    deinit {
        articleContentWebView.scrollView.delegate = nil
    }
}
