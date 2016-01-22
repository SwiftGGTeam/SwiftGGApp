//
//  SGLoginViewController.swift
//  SwiftGG
//
//  Created by luckytantanfu on 1/19/16.
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
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "正在阅读"
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 28))
        let label = UILabel(frame: CGRectMake(5, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(12)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor(rgba: "#696969")
        header.addSubview(label)
        header.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        
        // 添加上下两条分界线
        addBorderToLayer(header.layer, edges: [UIRectEdge.Top, UIRectEdge.Bottom], color: UIColor(rgba: "#C7C7C7"), thickness: 0.5)
        
        return header
    }
    
}

// MARK: - UITableViewDelegate
extension SGUserViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - Target-Action
extension SGUserViewController {
    func setting() {
        print("setting clicked")
    }
}

// MARK: - Helper
extension SGUserViewController {
    private func setupViews() {
        tableView.registerNib(UINib(nibName: "SGUserReadingTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableHeaderView = NSBundle.mainBundle().loadNibNamed("SGUserTableHeaderView", owner: self, options: nil).first as! SGUSerTableHeaderView
        
        navigationController?.navigationBar.barTintColor = tableView.tableHeaderView?.backgroundColor
        navigationController?.navigationBar.translucent = false
        tableView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)

        // remove navigation bar shadow
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // add setting barItem
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "setting_nav_item"), style: .Plain, target: self, action: "setting")
        settingBarItem.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = settingBarItem
    }
    
    private func addBorderToLayer(layer: CALayer, edges: [UIRectEdge], color: UIColor, thickness: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.Top:
                border.frame = CGRectMake(0, 0, CGRectGetWidth(layer.frame), thickness)
            case UIRectEdge.Bottom:
                border.frame = CGRectMake(0, CGRectGetHeight(layer.frame) - thickness, CGRectGetWidth(layer.frame), thickness)
            case UIRectEdge.Left:
                border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(layer.frame))
            case UIRectEdge.Right:
                border.frame = CGRectMake(0, CGRectGetWidth(layer.frame) - thickness, thickness, CGRectGetHeight(layer.frame))
            default:
                break
            }
            border.backgroundColor = color.CGColor
            layer.addSublayer(border)
        }
    }
}