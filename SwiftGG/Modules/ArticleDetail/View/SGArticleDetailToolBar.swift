//
//  SGArticleDetailToolBar.swift
//  MBArticleViewForSwiftGGApp
//
//  Created by Perry on 16/1/19.
//  Copyright © 2016年 MmoaaY. All rights reserved.
//

import UIKit

protocol SGArticleDetailToolBarStyleProtocol {
    
}

protocol SGArticleDetailToolBarProtocol: class {
    func backPressed()
    func forwardPressed()
}

class SGArticleDetailToolBar: NSObject {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    
    weak var delegate: SGArticleDetailToolBarProtocol?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func backPressed(sender: AnyObject) {
        self.delegate?.backPressed()
    }

    @IBAction func forwardPressed(sender: AnyObject) {
        self.delegate?.forwardPressed()
    }
    
    override init() {
        super.init()
        NSBundle.mainBundle().loadNibNamed("SGArticleDetailToolBar", owner: self, options: nil)
    }
}
