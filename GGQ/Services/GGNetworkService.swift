//
//  GG.swift
//  SwiftGGQing
//
//  Created by 宋宋 on 16/4/9.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import MoyaX
import RxSwift

enum SGError: CustomStringConvertible {
	case TimeOut
	case Failure

	var description: String {
		switch self {
		case .TimeOut:
			return "请求超时"
		case .Failure:
			return "请求失败"
		}
	}
}

// 一个简单的 logger
class LoggerMiddleware: Middleware {
	// 这个方法会在请求发送前被调用
	func willSendRequest(target: Target, endpoint: Endpoint) {
		Info("Sending request: \(endpoint.URL.absoluteString)\nParameters: \(endpoint.parameters)")
	}

	// 这个方法会在处理响应的回调闭包前被调用
	func didReceiveResponse(target: Target, response: Result<Response, Error>) {
		switch response {
		case let .Response(response):
			Info("Received response(\(response.statusCode ?? 0)) from \(response.response!.URL?.absoluteString ?? String()).")
			if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) {
				Info("JSON: \(json)")
			} else if let string = NSString(data: response.data, encoding: NSUTF8StringEncoding) {
				Info("String: \(string)")
			}
		case .Incomplete(let error):
			Error("Got error: \(error)")
		}
	}
}

#if DEV
	let GGProvider = RxMoyaXProvider(middlewares: [LoggerMiddleware()])
#else
	let GGProvider = RxMoyaXProvider()
#endif

enum GGAPI {
	case Login(username: String, password: String)
	case Register(username: String, password: String)
	case UserInfo(uid: String)
	case Articles(pageIndex: Int, pageSize: Int)
	case ArticleDetail(articleId: Int)
	case CategoryList
	case ArticlesByCategory(categoryId: Int, pageIndex: Int, pageSize: Int)
    case ServerInfo
}

extension GGAPI: Target {

	var baseURL: NSURL { return GGConfig.Nerworking.host }

	var path: String {
		switch self {
		case .Login:
			return "/v1/user/userLogin"
		case .Register:
			return "/v1/user/userRegister"
		case .UserInfo:
			return "/v1/user/getInfo"
		case .Articles:
			return "/v1/article"
		case .ArticleDetail:
			return "/v1/article/detail"
		case .CategoryList:
			return "/v1/article/categoryList"
		case .ArticlesByCategory:
			return "/v1/article"
        case .ServerInfo:
            return "/v1/app/info"
		}
	}

	var headerFields: [String: String] {
		return [
            "Accept": "application/json",
            "SwiftGG": "GG"
        ]
	}

	var parameters: [String: AnyObject] {
		switch self {
		case .Login(let username, let password):
			return ["userName": username, "password": password]
		case .Register(let username, let password):
			return ["userName": username, "password": password]
		case .UserInfo(let uid):
			return ["uid": uid]
		case let .Articles(pageIndex, pageSize):
			return ["pageIndex": pageIndex, "pageSize": pageSize]
		case .ArticleDetail(let articleId):
			return ["articleId": articleId]
		case .CategoryList:
			return [:]
		case let .ArticlesByCategory(categoryId, pageIndex, pageSize):
			return ["categoryId": categoryId, "pageIndex": pageIndex, "pageSize": pageSize]
        case .ServerInfo:
            return [:]
		}
	}

	var method: HTTPMethod {
		return .GET
	}

	var parameterEncoding: ParameterEncoding {
		return .URL // GET
	}
	// TODO: - 添加参数
	var sampleData: NSData {
		switch self {
		case .CategoryList:
			return stubbedResponse("CategoryList")
		case .Login:
			return stubbedResponse("Login")
		case .Register:
			return stubbedResponse("Register")
		default:
			return stubbedResponse("")
		}
	}
}

// MARK: - Provider support
func stubbedResponse(filename: String) -> NSData! {
	let bundle = NSBundle.mainBundle()
	let path = bundle.pathForResource(filename, ofType: "json")
	return NSData(contentsOfFile: path!)
}

private extension String {
	var URLEscapedString: String {
		return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
	}
}

func url(route: Target) -> String {
	return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}
