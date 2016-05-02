//
//  SegueHandlerType.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/10.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import Foundation

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier,
        sender: AnyObject?) {

            performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier) -> AnyObject -> Void {
        return { [unowned self] sender in
            self.performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
        }
    }

    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {

        // 这里还是需要使用 guard 语句，但是至少我们可以获取到变量的值
        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Invalid segue identifier \(segue.identifier).") }

        return segueIdentifier
    }
}
