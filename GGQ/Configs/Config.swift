//
//  Config.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/16.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import Foundation

class GGConfig {
    
    static let appGroupID = "group.app.swift.gg"

	struct Nerworking {
		#if DEV
			static let host = NSURL(string: "http://debug.api.swift.gg")!
		#else
			static let host = NSURL(string: "http://api.swift.gg")!
		#endif
	}
    
    struct Feedback {
        static let mail = "dev@swift.gg"
        static let theme = "GG 阅读反馈"
        static let footer = ""
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
    
    struct Router {
        
        static let scheme = "swiftgg"
        static let host = "swift.gg"
        
        static let baseURL = NSURL(string: scheme + "://" + host)!
        
        static let home = "/:page" // 未完成
        static let oauth = "/oauth/:type"
        static let profile = "/profile/:type/:token"
        static let article = "/:year/:month/:day/:pattern"

        static let setting = "/setting"
        static let archives = "/archives/:year/:month"
        
        
        static let feedback = "/feedback"
        static func feedback(_: Void) -> NSURL {
            return Router.baseURL.URLByAppendingPathComponent(feedback)
        }
        
        struct About {
            static let index = "/about"
            
            static func index(_: Void) -> NSURL {
                return Router.baseURL.URLByAppendingPathComponent(index)
            }
            
            struct Licences {
                static let index = About.index + "/licences"
                static let name = index + "/:name"
                
                static func index(_: Void) -> NSURL {
                    return Router.baseURL.URLByAppendingPathComponent(index)
                }
                
                static func name(name: String) -> NSURL {
                    return Router.baseURL.URLByAppendingPathComponent(index + "/\(name)")
                }
                
            }
            
            // Router 嵌套多层 ==
            struct Translators {
                static let index = About.index + "/translators"
                static let name = index + "/:name"
                
                static func index(_: Void) -> NSURL {
                    return Router.baseURL.URLByAppendingPathComponent(index)
                }
                
                static func name(name: String) -> NSURL {
                    return Router.baseURL.URLByAppendingPathComponent(index + "/\(name)")
                }
            }
            
        }
        
        struct Categoties {
            static let index = "/categories"
            static let id = index + "/id/:id"
            static let name = index + "/:name"
        }
        
        struct Search {
            static let index = "/search"
            
            static let content = index + "/:content"
            
            static func index(_: Void) -> NSURL {
                return Router.baseURL.URLByAppendingPathComponent(index)
            }
            
            static func content(content: String) -> NSURL {
                return Router.baseURL.URLByAppendingPathComponent(index + "/\(content)")
            }
        }
        
        struct Share {
            
            private static let index = "/share"
            
            static let article = index + "/:article_id"
            
            static func article(id: Int) -> NSURL {
                return Router.baseURL.URLByAppendingPathComponent(index + "/\(id)")
            }
        }
    }

}
