//
//  SGLoginViewController.swift
//  SwiftGG
//
//  Created by luckytantanfu on 1/19/16.
//  Copyright © 2015 swiftgg. All rights reserved.
//

import UIKit


class SGUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pinnedHeaderView: SGUSerTableHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

// MARK: - UITableViewDataSource
extension SGUserViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(String(SGUserReadingTableViewCell), forIndexPath: indexPath) as! SGUserReadingTableViewCell
        
        // configure cell
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "正在阅读"
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 28))
        let label = UILabel(frame: CGRectMake(5, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(12)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor(rgba: "#696969")
        header.addSubview(label)
        header.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        header.layer.addBorder([UIRectEdge.Bottom], color: UIColor(rgba: "#C7C7C7"), thickness: 0.5)
        
        return header
    }
    
}

// MARK: - UITableViewDelegate
extension SGUserViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - SGUSerTableHeaderViewDelegate
extension SGUserViewController: SGUSerTableHeaderViewDelegate {
    func didUserInfoContainerPressed() {
        let userInfoViewController = SGUserInfoViewController()
        userInfoViewController.hidesBottomBarWhenPushed = true
        navigationController!.pushViewController(userInfoViewController, animated: true)
    }
}

// MARK: - Target-Action
extension SGUserViewController {
    func settingButtonTapped(sender: UIBarButtonItem) {
        let settingViewController = SGSettingViewController()
        settingViewController.hidesBottomBarWhenPushed = true
        navigationController!.pushViewController(settingViewController, animated: true)
    }
}

// MARK: - Helper
extension SGUserViewController: TransparentNavBarProtocol {
    private func setupViews() {
        view.backgroundColor = UIColor(rgba: "#3595BF")

        tableView.registerNib(UINib(nibName: "SGUserReadingTableViewCell", bundle: nil), forCellReuseIdentifier: String(SGUserReadingTableViewCell))
        tableView.dataSource = self
        tableView.delegate = self
        pinnedHeaderView.delegate = self
        
        let transparentNavBar = transparentNavigationBar()
        view.addSubview(transparentNavBar)
        let customNavigationItem = UINavigationItem(title: "")
        transparentNavBar.setItems([customNavigationItem], animated: false)
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "setting_nav_item"), style: .Plain, target: self, action: #selector(SGUserViewController.settingButtonTapped(_:)))
        settingBarItem.tintColor = UIColor.whiteColor()
        customNavigationItem.rightBarButtonItem = settingBarItem
    }
}
