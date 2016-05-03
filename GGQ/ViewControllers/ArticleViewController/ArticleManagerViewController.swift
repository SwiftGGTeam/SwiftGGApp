//
//  ArticleManagerViewController.swift
//  GGQ
//
//  Created by 宋宋 on 5/1/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ArticleManagerViewController: UIPageViewController {
    
    var articleInfo: ArticleInfoObject!
    
    private var viewModel: ArticleManagerViewModel!
    
    let vcs = [R.storyboard.article.articleViewController()!, R.storyboard.article.articleViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        setViewControllers([vcs[0]!], direction: .Forward, animated: true, completion: nil)
        
        let mainScreenSize = UIScreen.mainScreen().bounds.size
        
        viewModel = ArticleManagerViewModel(articleInfo: articleInfo, nextPageTrigger: Driver.empty(), contentSize: CGSize(width: mainScreenSize.width - 40, height: mainScreenSize.height - 90))
        
        for vc in vcs.withoutNil() {
            
            vc.rx_articleTitle.value = articleInfo.title
            
            vc.rx_currentPage.asObservable()
                .flatMap(viewModel.contentText)
                .observeOn(.Main)
                .bindTo(vc.rx_contentText)
                .addDisposableTo(rx_disposeBag)
            
            viewModel.pagerTotal.asObservable()
                .observeOn(.Main)
                .bindTo(vc.rx_pagerTotal)
                .addDisposableTo(rx_disposeBag)
        }
        
        view.backgroundColor = UIColor.gg_backgroundColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }

}

extension ArticleManagerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ArticleViewController where viewController.rx_currentPage.value > 1 else { return nil }
        guard let nextViewController = viewController == vcs[0] ? vcs[1] : vcs[0] else { return nil }
        nextViewController.rx_currentPage.value = viewController.rx_currentPage.value - 1
        return nextViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        // FIXME: - 异步变同步了
        guard let viewController = viewController as? ArticleViewController where viewController.rx_currentPage.value < viewController.rx_pagerTotal.value else { return nil }
        guard let nextViewController = viewController == vcs[0] ? vcs[1] : vcs[0] else { return nil }
        nextViewController.rx_currentPage.value = viewController.rx_currentPage.value + 1
        return nextViewController
    }
    
}

// MARK: - Status Bar

extension ArticleManagerViewController {
	override func prefersStatusBarHidden() -> Bool {
		return navigationController?.navigationBarHidden ?? true
	}

	override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
		return .Slide
	}
}
