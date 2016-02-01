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

protocol SGArticleDetailInfoProtocol: class {
    func openArticle() -> SGArticleDetailInfo
    func closeArticle(articleDetailInfo:SGArticleDetailInfo)
}

extension SGArticleDetailViewController {
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        self.articleContentView.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.articleDetailInfo!.offset), animated: false)
        let js = "$('body').scrollTop(" + (self.articleDetailInfo?.getOffset())! + ")"
        articleContentView.evaluateJavaScript(js, completionHandler: { (AnyObject, NSError) -> Void in
            print(AnyObject)
            print(NSError)
        })
    }
}

class SGArticleDetailViewController: UIViewController, WKNavigationDelegate {
    
    weak var articleDetailInfoProtocol : SGArticleDetailInfoProtocol?
    
    var articleDetailInfo:SGArticleDetailInfo?
    
    var articleContentView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initArticleContentView()
        
        setupNavigationBar()
    }
    
    // MARK: Helper Methods
    private func initArticleContentView() {
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
    
    // WARN:neon框架需要在autolayout渲染完之后再使用
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        articleContentView.fillSuperview()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "back_white")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: Selector("back"))
    }
    
    
    func back() {
        if articleContentView.canGoBack {
            articleContentView.goBack()
        } else {
            articleContentView.evaluateJavaScript("$('body').scrollTop()", completionHandler: { (AnyObject, NSError) -> Void in
                if let offset:Double = AnyObject as? Double {
                    self.articleDetailInfo?.offset = offset
                    self.articleDetailInfo?.height = Double(self.articleContentView.scrollView.contentSize.height)
                    self.articleDetailInfoProtocol?.closeArticle(self.articleDetailInfo!)
                }
            })

            navigationController!.popViewControllerAnimated(true)
        }
    }
}
