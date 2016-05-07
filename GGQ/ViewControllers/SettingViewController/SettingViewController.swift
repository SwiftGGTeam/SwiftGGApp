//
//  SettingViewController.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/19.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import PKHUD

class SettingViewController: UITableViewController {
    
    @IBOutlet private weak var offlineInfoLabel: UILabel!
    
    var viewModel: SettingViewModel!
    
    var homeViewModel: HomeViewModel!
    
    private let loadMoreTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        viewModel = SettingViewModel()
        
        homeViewModel = HomeViewModel(loadMoreTrigger: loadMoreTrigger.asObservable())
        
        homeViewModel.isLoading.asObservable()
//            .skip(1)
            .filter { !$0 }
            .map { _ in }
            .subscribeNext(loadMoreTrigger.onNext)
            .addDisposableTo(rx_disposeBag)
        
        loadMoreTrigger.onNext()
        
        HUD.show(.Label("加载文章中..."))
        
        homeViewModel.hasNextPage.asObservable()
            .log("hasNextPage")
            .filter { !$0 }
            .map { _ in }
            .doOnNext { HUD.hide(afterDelay: 0.3) }
            .subscribeNext(loadMoreTrigger.onCompleted)
            .addDisposableTo(rx_disposeBag)
        
        loadMoreTrigger.asObservable()
            .log("Offline")
            .subscribe()
            .addDisposableTo(rx_disposeBag)
        
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
