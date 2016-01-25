//
//  SGArticleDetailViewController.swift
//  MBArticleViewForSwiftGGApp
//
//  Created by Perry on 16/1/19.
//  Copyright © 2016年 MmoaaY. All rights reserved.
//

import UIKit
import WebKit

protocol SGArticleDetailInfoProtocol: class {
    func getSGArticleDetailInfo() -> SGArticleDetailInfo
}

class SGArticleDetailViewController: UIViewController {
    
    weak var articleDetailInfoProtocol : SGArticleDetailInfoProtocol?
    
    @IBOutlet weak var articleContentView: UIWebView!
    
    private func initArticleContentView() {

        if let articleInfo = articleDetailInfoProtocol?.getSGArticleDetailInfo() {
            let url = NSURL(string: articleInfo.url)
            //            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: NSTimeInterval(30))
            let request = NSURLRequest(URL: url!)
            articleContentView.loadRequest(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initArticleContentView()
    }
}
