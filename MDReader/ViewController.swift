//
//  ViewController.swift
//  MDReader
//
//  Created by 宋宋 on 5/26/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {

        let fileURL = R.file.contentMd()!
        let string = try! NSString(contentsOfURL: fileURL, encoding: NSUTF8StringEncoding) as String
        
        textView.attributedText = mdRender(markdown: string)
        
        NSTextStorage
    }

}

