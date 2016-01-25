//
//  SGArticleDetailViewController.swift
//  MBArticleViewForSwiftGGApp
//
//  Created by Perry on 16/1/19.
//  Copyright © 2016年 MmoaaY. All rights reserved.
//

import UIKit
import WebKit

protocol SGArticleDetailInfoProtocol {
    func getSGArticleDetailInfo()->SGArticleDetailInfo!
}

class SGArticleDetailViewController: UIViewController {
    
    var articleDetailInfoProtocol:SGArticleDetailInfoProtocol?
    
    @IBOutlet var articleContentView: UIWebView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private func initArticleContentView() {
//        self.articleContentView.allowsBackForwardNavigationGestures = true
        
        if let _ = self.articleDetailInfoProtocol {
            
            let articleInfo = self.articleDetailInfoProtocol?.getSGArticleDetailInfo()
            self.title = articleInfo?.title
            
            let url = NSURL(string: (articleInfo?.url)!)
//            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: NSTimeInterval(30))
            let request = NSURLRequest(URL: url!)
            self.articleContentView.loadRequest(request)
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initArticleContentView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
