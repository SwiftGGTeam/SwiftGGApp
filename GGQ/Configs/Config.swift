//
//  Config.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/16.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation

class GGConfig {
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
}
