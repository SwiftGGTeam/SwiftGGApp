//
//  SGSettingViewController.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/1/23.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

let SettingCellIdentifier = "SettingCellIdentifier"

class SGSettingViewController: UIViewController {
    
    var tableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    // MARK: - Helper methods
    func setupNavigationBar() {
        title = "设置"
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController!.navigationBar.barTintColor = UIColor(rgba: "#FCFCFC")
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba: "#303030"), NSFontAttributeName: UIFont.systemFontOfSize(17)]
        
        let backImage = UIImage(named: "back_gray")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: Selector("back"))
    }
    
    func back() {
        navigationController!.popViewControllerAnimated(true)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(rgba: "#F7F7F7")
        tableView.scrollEnabled = false
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource
extension SGSettingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(SettingCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: SettingCellIdentifier)
        }
        
        switch indexPath.row {
        case 0: // 清理缓存
            cell.imageView?.image = UIImage(named: "toolbar")
            cell.textLabel?.text = "清理缓存"
        case 1: // 反馈问题
            cell.imageView?.image = UIImage(named: "toolbar")
            cell.textLabel?.text = "反馈问题"
        case 2: // 关于我们
            cell.imageView?.image = UIImage(named: "toolbar")
            cell.textLabel?.text = "关于我们"
        default: ()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SGSettingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0: // 清理缓存
            print("清理缓存")
        case 1: // 反馈问题
            print("反馈问题")
        case 2: // 关于我们
            let aboutViewController = SGAboutViewController()
            navigationController!.pushViewController(aboutViewController, animated: true)
        default: ()
        }
    }
}
