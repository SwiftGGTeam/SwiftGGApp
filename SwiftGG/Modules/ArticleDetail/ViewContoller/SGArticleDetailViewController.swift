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
    func getSGArticleDetailInfo() -> SGArticleDetailInfo
}

class SGArticleDetailViewController: UIViewController {
    
    weak var articleDetailInfoProtocol : SGArticleDetailInfoProtocol?
    
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
        
        if let articleInfo = articleDetailInfoProtocol?.getSGArticleDetailInfo() {
            let url = NSURL(string: articleInfo.url)
//            let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: NSTimeInterval(30))
            let request = NSURLRequest(URL: url!)
            articleContentView.loadRequest(request)
            
            title = articleInfo.title
        }
        
        
    }
    
    // WARN:neon框架需要在autolayout渲染完之后再使用
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        articleContentView.fillSuperview()
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "back_white")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: Selector("back"))
    }
    
    
    func back() {
        if articleContentView.canGoBack {
            articleContentView.goBack()
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
}
