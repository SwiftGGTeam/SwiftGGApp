//
//  FeedbackController.swift
//  GGQ
//
//  Created by 宋宋 on 5/30/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import SwiftyJSON
import MessageUI
import RxSwift
import RxCocoa

class FeedbackController: NSObject, Routerable {

    private let disposeBag = DisposeBag()

    var routingPattern: String {
        return GGConfig.Router.feedback
    }

    var routingIdentifier: String? {
        return GGConfig.Router.feedback
    }

    func get(url: NSURL, sender: JSON?) {
        let mail = MFMailComposeViewController()
        mail.setToRecipients([GGConfig.Feedback.mail])
        mail.setSubject(GGConfig.Feedback.theme)
        mail.view.tintColor = R.color.gg.black()
        mail.mailComposeDelegate = self

        RouterManager.topViewController()?.showDetailViewController(mail, sender: nil)
    }

}

extension FeedbackController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        RouterManager.topViewController()?.dismissViewControllerAnimated(true, completion: nil)
    }
}
