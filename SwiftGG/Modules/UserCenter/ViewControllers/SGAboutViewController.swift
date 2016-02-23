//
//  SGAboutViewController.swift
//  SwiftGG
//
//  Created by 杨志超 on 16/1/23.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

let AboutCellIdentifier = "AboutCellIdentifier"

class SGAboutViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    // MARK: - Helper Methods
    func setupNavigationBar() {
        title = "关于我们"
        
        let backImage = UIImage(named: "back_gray")?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: Selector("back"))
    }
    
    func back() {
        navigationController!.popViewControllerAnimated(true)
    }
}

// MARK: - UITableViewDataSource
extension SGAboutViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(SettingCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: SettingCellIdentifier)
        }
        
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(named: "toolbar")
            cell.textLabel?.text = "微博关注我们"
        } else if indexPath.row == 1 {
            cell.imageView?.image = UIImage(named: "toolbar")
            cell.textLabel?.text = "鼓励一下我们"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SGAboutViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 16
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
