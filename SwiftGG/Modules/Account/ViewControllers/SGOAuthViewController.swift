//
//  SGOAuthViewController.swift
//  SwiftGG
//
//  Created by TangJR on 2/28/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit
import WebKit

class SGOAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
}

extension SGOAuthViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.whiteColor()
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(SGOAuthConst.GitHubClientId)&state=111&redirect_uri=\(SGOAuthConst.GitHubCallback)"
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        
        let webView = WKWebView()
        webView.loadRequest(request)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
}

extension SGOAuthViewController: WKNavigationDelegate {
    
}