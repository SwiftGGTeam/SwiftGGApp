//
//  SGRegisterInformationController.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/1/15.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

let RegisterInformationCellIdentifier = "RegisterInformationCell"

class SGRegisterInformationController: UIViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgba: "#F7F7F7")
        
        setupNavigationBar()
        
        setupTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    // MARK: - Helper Methods
    
    func setupNavigationBar() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        title = "注册 SwiftGo"
        
        navigationController!.navigationBar.barTintColor = UIColor(rgba: "#FCFCFC")
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba: "#303030"), NSFontAttributeName: UIFont.systemFontOfSize(17)]
        
        let backImage = UIImage(named: "back_gray")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: #selector(SGRegisterInformationController.back))
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        view.addSubview(tableView)
    }
    
    func back() {
        navigationController!.popViewControllerAnimated(true)
    }
}

// MARK: - UITableViewDataSource
extension SGRegisterInformationController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(RegisterInformationCellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: RegisterInformationCellIdentifier)
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: "toolbar")
                cell.textLabel?.text = "微博关注我们"
            } else if indexPath.row == 1 {
                cell.imageView?.image = UIImage(named: "toolbar")
                cell.textLabel?.text = "鼓励一下我们"
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SGRegisterInformationController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
