//
//  Config.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/16.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation
import CocoaMarkdown

class GGConfig {
    
    static let appGroupID = "group.app.swift.gg"
    
	struct Nerworking {
		#if DEV
			static let host = NSURL(string: "http://debug.api.swift.gg")!
		#else
			static let host = NSURL(string: "http://api.swift.gg")!
		#endif
	}
	/// 主页的配置
	struct Home {
		/// 每次加载多少个
		static let pageSize = 10
	}

	struct Category {
		static let pageSize = 15
	}
    
    struct OAuth {
        struct GitHub {
            static let client_id = "742321c546e7cc39e53c"
            static let client_secret = "dfc142761f571be5abd0368dfd6e7864fd56c943"
            static let callback_url = "swiftgg://oauth/github"
            static let authorize_url = "https://github.com/login/oauth/authorize"
            static let accessToken_url = "https://github.com/login/oauth/access_token"
        }
    }
    
    struct Article {
        static var textAttributes: CMTextAttributes {
            let textAttributes = CMTextAttributes()
            
            textAttributes.h1Attributes = h1TextAttributes
            textAttributes.h2Attributes = h2TextAttributes
            textAttributes.h3Attributes = h3TextAttributes
            textAttributes.h4Attributes = h4TextAttributes
            textAttributes.h5Attributes = h5TextAttributes
            textAttributes.h6Attributes = h6TextAttributes
            
            textAttributes.emphasisAttributes = emphasisTextAttributes
            textAttributes.strongAttributes = strongTextAttributes
            
            textAttributes.linkAttributes = linkTextAttributes
            textAttributes.codeBlockAttributes = codeBlockTextAttributes
            textAttributes.inlineCodeAttributes = inlineCodeTextAttributes
            textAttributes.blockQuoteAttributes = blockQuoteTextAttributes
            
            textAttributes.orderedListAttributes = orderedListTextAttributes
            textAttributes.orderedListItemAttributes = orderedListItemTextAttributes
            
            textAttributes.unorderedListAttributes = unorderedListTextAttributes
            textAttributes.unorderedListItemAttributes = unorderedListItemTextAttributes
            
            return textAttributes
        }
        
        private static var h1TextAttributes: [NSObject : AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacingBefore = 20
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 25)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
        
        private static var h2TextAttributes: [NSObject : AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacingBefore = 20
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 23)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
        
        private static var h3TextAttributes: [NSObject : AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 21)!
            ]
        }
        
        private static var h4TextAttributes: [NSObject : AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 19)!
            ]
        }
        
        private static var h5TextAttributes: [NSObject : AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!
            ]
        }
        
        private static var h6TextAttributes: [NSObject : AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!
            ]
        }

        private static var emphasisTextAttributes: [NSObject: AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSObliquenessAttributeName: NSNumber(float: 0.2)
            ]
        }

        private static var strongTextAttributes: [NSObject: AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Medium", size: 17)!
            ]
        }
        
        private static var linkTextAttributes: [NSObject: AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSForegroundColorAttributeName: UIColor.blueColor(),
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
            ]
        }
        
        private static var codeBlockTextAttributes: [NSObject: AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!
            ]
        }
        
        private static var inlineCodeTextAttributes: [NSObject: AnyObject] {
            return [
                NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 17)!,
                NSForegroundColorAttributeName: UIColor.redColor()
            ]
        }
        
        private static var blockQuoteTextAttributes: [NSObject: AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 20
            paragraphStyle.headIndent = 20
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSForegroundColorAttributeName: UIColor.grayColor(),
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }

        private static var orderedListTextAttributes: [NSObject: AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 20
            paragraphStyle.headIndent = 38
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
        
        private static var orderedListItemTextAttributes: [NSObject: AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 20
            paragraphStyle.headIndent = 38
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
        
        private static var unorderedListTextAttributes: [NSObject: AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 20
            paragraphStyle.headIndent = 38
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
        
        private static var unorderedListItemTextAttributes: [NSObject: AnyObject] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 20
            paragraphStyle.headIndent = 38
            return [
                NSFontAttributeName: UIFont(name: "PingFangSC-Regular", size: 17)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
    }
}
