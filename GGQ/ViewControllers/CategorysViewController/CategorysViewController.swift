//
//  CategorysViewController.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/12.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class CategorysViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case ShowCategory
//        case ShowSearch
    }

    @IBOutlet private weak var categorysCollectionView: UICollectionView!

    private var viewModel: CategorysViewModel!

    override func viewDidLoad() {
        
        let refresh = UIRefreshControl()
        categorysCollectionView.addSubview(refresh)
        
        viewModel = CategorysViewModel(refreshTrigger: refresh.rx_controlEvent(.ValueChanged).asDriver())
        
        viewModel.isRefreshing.asDriver()
            .skip(1)
            .drive(refresh.rx_refreshing)
            .addDisposableTo(rx_disposeBag)

        viewModel.elements.asObservable()
            .observeOn(.Main)
            .bindTo(categorysCollectionView.rx_itemsWithCellFactory) { cv, i, v in
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let cell = cv.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.categoryCollectionViewCell, forIndexPath: indexPath)!
                cell.title = v.name
                cell.number = v.sum
                return cell }
            .addDisposableTo(rx_disposeBag)

        categorysCollectionView
            .rx_modelSelected(CategoryObject)
            .subscribeNext { [unowned self] category in
                self.performSegueWithIdentifier(.ShowCategory, sender: category) }
            .addDisposableTo(rx_disposeBag)

        tabBarController?
            .rx_didSelectViewController
            .map { [unowned self] in $0 == self.navigationController } // 选择了"自己"
            .buffer(timeSpan: 0.6, count: 2, scheduler: MainScheduler.instance) // buffer 两个
            .filter { $0.count >= 2 } // 确保是在 0.6s 内点击两次
            .map { $0[0] == $0[1] } // 两次都是点击"自己"
            .subscribeNext { [unowned self] doubleClick in
                if doubleClick {
                    let ip = NSIndexPath(forItem: 0, inSection: 0)
                    self.categorysCollectionView.scrollToItemAtIndexPath(ip, atScrollPosition: .CenteredVertically, animated: true)
                }
            }
            .addDisposableTo(rx_disposeBag)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .ShowCategory:
            let categoryViewController = segue.destinationViewController.gg_castOrFatalError(CategoryViewController)
            let category: CategoryObject = castOrFatalError(sender)
            categoryViewController.category = category
        }
    }
}
