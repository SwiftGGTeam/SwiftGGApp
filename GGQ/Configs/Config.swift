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
}
