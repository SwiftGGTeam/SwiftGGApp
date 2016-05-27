//
//  ViewController.swift
//  MDReader
//
//  Created by 宋宋 on 5/26/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var textView: UITextView = {
        let textStorage = NSTextStorage()
        let layoutManager = GGLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        let view = UITextView(frame: CGRect.zero, textContainer: textContainer)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 30).active = true
        view.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        view.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        
        return view
    }()
    
    override func viewDidLoad() {

        let fileURL = R.file.contentMd()!
        let string = try! NSString(contentsOfURL: fileURL, encoding: NSUTF8StringEncoding) as String
        
        textView.attributedText = mdRender(markdown: string)
        
    }

}

