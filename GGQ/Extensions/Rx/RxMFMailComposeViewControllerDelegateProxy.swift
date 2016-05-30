//
//  RxMFMailComposeViewControllerDelegateProxy.swift
//  GGQ
//
//  Created by 宋宋 on 5/30/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MessageUI

class RxMFMailComposeViewControllerDelegateProxy: DelegateProxy, MFMailComposeViewControllerDelegate, DelegateProxyType {
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let mailVC: MFMailComposeViewController = castOrFatalError(object)
        return mailVC.mailComposeDelegate
    }
    
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let mailVC: MFMailComposeViewController = castOrFatalError(object)
        mailVC.mailComposeDelegate = delegate as? MFMailComposeViewControllerDelegate
    }
}

extension MFMailComposeViewController {
    
    var rx_delegate: DelegateProxy {
        return RxMFMailComposeViewControllerDelegateProxy.proxyForObject(self)
    }
    
    var rx_didFinishWithResult: ControlEvent<(result: MFMailComposeResult, error: NSError?)> {
        let source = rx_delegate
            .observe(#selector(MFMailComposeViewControllerDelegate.mailComposeController(_:didFinishWithResult:error:))).map { a in
                return (result: a[1] as! MFMailComposeResult, error: a[2] as? NSError)
        }
        return ControlEvent(events: source)
    }
    
}

