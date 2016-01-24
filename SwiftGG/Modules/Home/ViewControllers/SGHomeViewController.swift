//
//  SGHomeViewController.swift
//  SwiftGG
//
//  Created by JackAlan on 01/22/16.
//  Copyright © 2016 swiftgg. All rights reserved.
//

import UIKit

let cellId = "HomeViewCell"

class SGHomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.registerNib(UINib(nibName: "SGHomeViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId,forIndexPath: indexPath) as! SGHomeViewCell
        return cell;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10;
    }
}