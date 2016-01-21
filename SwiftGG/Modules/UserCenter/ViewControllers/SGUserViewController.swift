//
//  SGLoginViewController.swift
//  SwiftGG
//
//  Created by TangJR on 11/30/15.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit

private let cellIdentifier = "SGUserReadingTableViewCell"

class SGUserViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

// MARK: - UITableViewDataSource
extension SGUserViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SGUserReadingTableViewCell
        
        // configure cell
//        cell.setArticleTitle(title: "")
//        cell.setArticleProgress(10)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SGUserViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - Helper
extension SGUserViewController {
    private func setupViews() {
        tableView.tableHeaderView = NSBundle.mainBundle().loadNibNamed("SGUserTableHeaderView", owner: self, options: nil).first as! SGUSerTableHeaderView
        
        navigationController?.navigationBar.barTintColor = tableView.tableHeaderView?.backgroundColor
        navigationController?.navigationBar.translucent = false
        tableView.backgroundColor = tableView.tableHeaderView?.backgroundColor

        // remove navigation bar shadow
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // add setting barItem
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "setting_nav_item"), style: .Plain, target: self, action: "setting")
        settingBarItem.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = settingBarItem
        
        tableView.registerNib(UINib(nibName: "SGUserReadingTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
    func setting() {
        print("setting clicked")
    }
}