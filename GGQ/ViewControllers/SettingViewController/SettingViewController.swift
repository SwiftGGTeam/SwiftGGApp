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

class SettingViewController: UITableViewController {
    
    @IBOutlet private weak var offlineInfoLabel: UILabel!
    
    var viewModel: SettingViewModel!
    
    override func viewDidLoad() {
        viewModel = SettingViewModel()
        
        Observable.combineLatest(viewModel.offlineArticlesNumber, viewModel.articlesNumber) { "\($0)/\($1)" }
            .observeOn(.Main)
            .bindTo(offlineInfoLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
