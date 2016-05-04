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
import PKHUD

class ArticleManagerViewController: UIPageViewController {
    
    var articleInfo: ArticleInfoObject!
    
    private var viewModel: ArticleManagerViewModel!
    
    var vcs: [ArticleViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainScreenSize = UIScreen.mainScreen().bounds.size
        viewModel = ArticleManagerViewModel(articleInfo: articleInfo, nextPageTrigger: Driver.empty(), contentSize: CGSize(width: mainScreenSize.width - 40, height: mainScreenSize.height - 90))
        
        viewModel.updated.asDriver()
            .driveNext { updated in
                if updated {
                    HUD.flash(.Label("文章已更新"), delay: 0.6)
                }
            }
            .addDisposableTo(rx_disposeBag)

        dataSource = self
        let vc = newArticleViewController()
        vc.rx_currentPage.value = viewModel.currentReadPage
        setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
        
        view.backgroundColor = UIColor.gg_backgroundColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    private func newArticleViewController() -> ArticleViewController {
        let vc = R.storyboard.article.articleViewController()!
        
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
        
        vcs.append(vc)
        if vcs.count > 3 {
            log.error("逗比你多加了一个")
        }
        return vc
    }

}

extension ArticleManagerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ArticleViewController where viewController.rx_currentPage.value > 1 else { return nil }
        let nextViewController: ArticleViewController
        if vcs.count < 3 {
            nextViewController = newArticleViewController()
        } else {
            var index = vcs.indexOf(viewController)!
            if index == 0 {
                index = 2
            } else {
                index -= 1
            }
            nextViewController = vcs[index]
        }
        nextViewController.rx_currentPage.value = viewController.rx_currentPage.value - 1
        return nextViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ArticleViewController where viewController.rx_currentPage.value < viewController.rx_pagerTotal.value else { return nil }
        let nextViewController: ArticleViewController
        if vcs.count < 3 {
            nextViewController = newArticleViewController()
        } else {
            var index = vcs.indexOf(viewController)!
            if index == 2 {
                index = 0
            } else {
                index += 1
            }
            nextViewController = vcs[index]
        }
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
