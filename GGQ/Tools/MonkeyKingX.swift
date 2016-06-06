//
//  MonkeyKingX.swift
//  GGQ
//
//  Created by 宋宋 on 5/30/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import SwiftyJSON

func handleURL(url: NSURL) -> JSON {
    guard let query = url.query else {
        return JSON([:])
    }
    return handleQuery(query)
}

func handleQuery(query: String) -> JSON {
    let querys = query.componentsSeparatedByString("&")
    var parameters: [String: String] = [:]
    for query in querys {
        let parameter = query.componentsSeparatedByString("=")
        parameters[parameter[0]] = parameter[1]
    }
    return JSON(parameters)
}

class MonkeyKingX {
    
    enum Media {
        
        case URL(NSURL)
        case Image(UIImage)
        case Audio(audioURL: NSURL, linkURL: NSURL?)
        case Video(NSURL)
        case File(NSData)
    }
    
    typealias Info = (appID: String, title: String?, description: String?, thumbnail: UIImage?, media: Media?)
    
    enum Message {
        
        enum WeChatSubtype {
            
            case Session(info: Info)
            case Timeline(info: Info)
            case Favorite(info: Info)
            
            var scene: String {
                switch self {
                case .Session:
                    return "0"
                case .Timeline:
                    return "1"
                case .Favorite:
                    return "2"
                }
            }
            
            var info: Info {
                switch self {
                case .Session(let info):
                    return info
                case .Timeline(let info):
                    return info
                case .Favorite(let info):
                    return info
                }
            }
        }
        case WeChat(WeChatSubtype)
        
        enum QQSubtype {
            case Friends(info: Info)
            case Zone(info: Info)
            case Favorites(info: Info)
            case Dataline(info: Info)
            
            var scene: Int {
                switch self {
                case .Friends:
                    return 0x00
                case .Zone:
                    return 0x01
                case .Favorites:
                    return 0x08
                case .Dataline:
                    return 0x10
                }
            }
            
            var info: Info {
                switch self {
                case .Friends(let info):
                    return info
                case .Zone(let info):
                    return info
                case .Favorites(let info):
                    return info
                case .Dataline(let info):
                    return info
                }
            }
        }
        case QQ(QQSubtype)
        
        enum WeiboSubtype {
            case Default(info: Info, accessToken: String?)
            
            var info: Info {
                switch self {
                case .Default(let info, _):
                    return info
                }
            }
            
            var accessToken: String? {
                switch self {
                case .Default(_, let accessToken):
                    return accessToken
                }
            }
        }
        case Weibo(WeiboSubtype)
        
        var info: Info {
            switch self {
            case .QQ(let message):
                return message.info
            case .WeChat(let message):
                return message.info
            case .Weibo(let message):
                return message.info
            }
        }
        
    }
    
    class func shareMessage(message: Message) -> Bool {
        
        let appID = message.info.appID
        
        switch message {
            
        case .WeChat(let type):
            
            var weChatMessageInfo: [String: AnyObject] = [
                "result": "1",
                "returnFromApp": "0",
                "scene": type.scene,
                "sdkver": "1.5",
                "command": "1010",
                ]
            
            let info = type.info
            
            if let title = info.title {
                weChatMessageInfo["title"] = title
            }
            
            if let description = info.description {
                weChatMessageInfo["description"] = description
            }
            
            if let thumbnailData = info.thumbnail?.monkeyking_compressedImageData {
                weChatMessageInfo["thumbData"] = thumbnailData
            }
            
            if let media = info.media {
                switch media {
                    
                case .URL(let URL):
                    weChatMessageInfo["objectType"] = "5"
                    weChatMessageInfo["mediaUrl"] = URL.absoluteString
                    
                case .Image(let image):
                    weChatMessageInfo["objectType"] = "2"
                    
                    if let fileImageData = UIImageJPEGRepresentation(image, 1) {
                        weChatMessageInfo["fileData"] = fileImageData
                    }
                    
                case .Audio(let audioURL, let linkURL):
                    weChatMessageInfo["objectType"] = "3"
                    
                    if let linkURL = linkURL {
                        weChatMessageInfo["mediaUrl"] = linkURL.absoluteString
                    }
                    
                    weChatMessageInfo["mediaDataUrl"] = audioURL.absoluteString
                    
                case .Video(let URL):
                    weChatMessageInfo["objectType"] = "4"
                    weChatMessageInfo["mediaUrl"] = URL.absoluteString
                    
                case .File:
                    fatalError("WeChat not supports File type")
                }
                
            } else { // Text Share
                weChatMessageInfo["command"] = "1020"
            }
            
            let weChatMessage = [appID: weChatMessageInfo]
            
            guard let data = try? NSPropertyListSerialization.dataWithPropertyList(weChatMessage, format: .BinaryFormat_v1_0, options: 0) else {
                return false
            }
            
            UIPasteboard.generalPasteboard().setData(data, forPasteboardType: "content")
            
            let weChatSchemeURLString = "weixin://app/\(appID)/sendreq/?"
            
            return openURL(URLString: weChatSchemeURLString)
            
        case .QQ(let type):
            
            let callbackName = appID.monkeyking_QQCallbackName
            
            var qqSchemeURLString = "mqqapi://share/to_fri?"
            if let encodedAppDisplayName = NSBundle.mainBundle().monkeyking_displayName?.monkeyking_base64EncodedString {
                qqSchemeURLString += "thirdAppDisplayName=" + encodedAppDisplayName
            } else {
                qqSchemeURLString += "thirdAppDisplayName=" + "SwiftGG"
            }
            
            qqSchemeURLString += "&version=1&cflag=\(type.scene)"
            qqSchemeURLString += "&callback_type=scheme&generalpastboard=1"
            qqSchemeURLString += "&callback_name=\(callbackName)"
            
            qqSchemeURLString += "&src_type=app&shareType=0&file_type="
            
            if let media = type.info.media {
                
                func handleNewsWithURL(URL: NSURL, mediaType: String?) {
                    
                    if let thumbnail = type.info.thumbnail, thumbnailData = UIImageJPEGRepresentation(thumbnail, 1) {
                        let dic = ["previewimagedata": thumbnailData]
                        let data = NSKeyedArchiver.archivedDataWithRootObject(dic)
                        UIPasteboard.generalPasteboard().setData(data, forPasteboardType: "com.tencent.mqq.api.apiLargeData")
                    }
                    
                    qqSchemeURLString += mediaType ?? "news"
                    
                    guard let encodedURLString = URL.absoluteString.monkeyking_base64AndURLEncodedString else {
                        return
                    }
                    
                    qqSchemeURLString += "&url=\(encodedURLString)"
                }
                
                switch media {
                    
                case .URL(let URL):
                    
                    handleNewsWithURL(URL, mediaType: "news")
                    
                case .Image(let image):
                    
                    guard let imageData = UIImageJPEGRepresentation(image, 1) else {
                        return false
                    }
                    
                    var dic = [
                        "file_data": imageData,
                        ]
                    if let thumbnail = type.info.thumbnail, thumbnailData = UIImageJPEGRepresentation(thumbnail, 1) {
                        dic["previewimagedata"] = thumbnailData
                    }
                    
                    let data = NSKeyedArchiver.archivedDataWithRootObject(dic)
                    
                    UIPasteboard.generalPasteboard().setData(data, forPasteboardType: "com.tencent.mqq.api.apiLargeData")
                    
                    qqSchemeURLString += "img"
                    
                case .Audio(let audioURL, _):
                    handleNewsWithURL(audioURL, mediaType: "audio")
                    
                case .Video(let URL):
                    handleNewsWithURL(URL, mediaType: nil) // No video type, default is news type.
                    
                case .File(let fileData):
                    
                    let data = NSKeyedArchiver.archivedDataWithRootObject(["file_data": fileData])
                    UIPasteboard.generalPasteboard().setData(data, forPasteboardType: "com.tencent.mqq.api.apiLargeData")
                    
                    qqSchemeURLString += "localFile"
                    
                    if let filename = type.info.description?.monkeyking_URLEncodedString {
                        qqSchemeURLString += "&fileName=\(filename)"
                    }
                }
                
                if let encodedTitle = type.info.title?.monkeyking_base64AndURLEncodedString {
                    qqSchemeURLString += "&title=\(encodedTitle)"
                }
                
                if let encodedDescription = type.info.description?.monkeyking_base64AndURLEncodedString {
                    qqSchemeURLString += "&objectlocation=pasteboard&description=\(encodedDescription)"
                }
                
            } else { // Share Text
                qqSchemeURLString += "text&file_data="
                
                if let encodedDescription = type.info.description?.monkeyking_base64AndURLEncodedString {
                    qqSchemeURLString += "\(encodedDescription)"
                }
            }

            return openURL(URLString: qqSchemeURLString)
            
        case .Weibo(let type):
            
            guard !UIApplication.sharedApplication().canOpenURL(NSURL(string: "weibosdk://request")!) else {
                
                // App Share
                
                var messageInfo: [String: AnyObject] = ["__class": "WBMessageObject"]
                let info = type.info
                
                if let description = info.description {
                    messageInfo["text"] = description
                }
                
                if let media = info.media {
                    switch media {
                    case .URL(let URL):
                        
                        var mediaObject: [String: AnyObject] = [
                            "__class": "WBWebpageObject",
                            "objectID": "identifier1"
                        ]
                        
                        if let title = info.title {
                            mediaObject["title"] = title
                        }
                        
                        if let thumbnailImage = info.thumbnail,
                            let thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 0.7) {
                            mediaObject["thumbnailData"] = thumbnailData
                        }
                        
                        mediaObject["webpageUrl"] = URL.absoluteString
                        
                        messageInfo["mediaObject"] = mediaObject
                        
                    case .Image(let image):
                        
                        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                            messageInfo["imageObject"] = ["imageData": imageData]
                        }
                        
                    case .Audio:
                        fatalError("Weibo not supports Audio type")
                    case .Video:
                        fatalError("Weibo not supports Video type")
                    case .File:
                        fatalError("Weibo not supports File type")
                    }
                }
                
                let uuIDString = CFUUIDCreateString(nil, CFUUIDCreate(nil))
                let dict = ["__class" : "WBSendMessageToWeiboRequest", "message": messageInfo, "requestID" :uuIDString]
                
                let messageData: [AnyObject] = [
                    ["transferObject": NSKeyedArchiver.archivedDataWithRootObject(dict)],
                    ["app": NSKeyedArchiver.archivedDataWithRootObject(["appKey": appID, "bundleID": NSBundle.mainBundle().monkeyking_bundleID ?? ""])]
                ]
                
                UIPasteboard.generalPasteboard().items = messageData

                return openURL(URLString: "weibosdk://request?id=\(uuIDString)&sdkversion=003013000")
            }
            
            // Weibo Web Share
            
            let info = type.info
            var parameters = [String: AnyObject]()
            
            guard let accessToken = type.accessToken else {
                print("When Weibo did not install, accessToken must need")
                return false
            }
            
            parameters["access_token"] = accessToken
            
            var statusText = ""
            
            if let title = info.title {
                statusText += title
            }
            
            if let description = info.description {
                statusText += description
            }
            
            var mediaType = Media.URL(NSURL())
            
            if let media = info.media {
                
                switch media {
                    
                case .URL(let URL):
                    
                    statusText += URL.absoluteString
                    
                    mediaType = Media.URL(URL)
                    
                case .Image(let image):
                    
                    guard let imageData = UIImageJPEGRepresentation(image, 0.7) else {
                        return false
                    }
                    
                    parameters["pic"] = imageData
                    mediaType = Media.Image(image)
                    
                case .Audio:
                    fatalError("web Weibo not supports Audio type")
                case .Video:
                    fatalError("web Weibo not supports Video type")
                case .File:
                    fatalError("web Weibo not supports File type")
                }
            }
            
            parameters["status"] = statusText
            
            switch mediaType {
                
            case .URL(_):
                
                let URLString = "https://api.weibo.com/2/statuses/update.json"
                
//                sharedMonkeyKing.request(URLString, method: .POST, parameters: parameters) { (responseData, HTTPResponse, error) -> Void in
//                    if let JSON = responseData, let _ = JSON["idstr"] as? String {
//                        completionHandler(result: true)
//                    } else {
//                        print("responseData \(responseData) HTTPResponse \(HTTPResponse)")
//                        completionHandler(result: false)
//                    }
//                }
                
            case .Image(_):
                
                let URLString = "https://upload.api.weibo.com/2/statuses/upload.json"
                
//                sharedMonkeyKing.upload(URLString, parameters: parameters) { (responseData, HTTPResponse, error) -> Void in
//                    if let JSON = responseData, let _ = JSON["idstr"] as? String {
//                        completionHandler(result: true)
//                    } else {
//                        print("responseData \(responseData) HTTPResponse \(HTTPResponse)")
//                        completionHandler(result: false)
//                    }
//                }
                
            case .Audio:
                fatalError("web Weibo not supports Audio type")
            case .Video:
                fatalError("web Weibo not supports Video type")
            case .File:
                fatalError("web Weibo not supports File type")
            }
            
            return false

        }
    }
    
    private class func openURL(URLString URLString: String) -> Bool {
        
        guard let URL = NSURL(string: URLString) else {
            return false
        }
        
        return UIApplication.sharedApplication().openURL(URL)
    }
    
    private func canOpenURL(URLString URLString: String) -> Bool {
        
        guard let URL = NSURL(string: URLString) else {
            return false
        }
        
        return UIApplication.sharedApplication().canOpenURL(URL)
    }
}

extension NSBundle {
    
    var monkeyking_displayName: String? {
        
        func getNameByInfo(info: [String : AnyObject]) -> String? {
            
            guard let displayName = info["CFBundleDisplayName"] as? String else {
                return info["CFBundleName"] as? String
            }
            
            return displayName
        }
        
        var info = infoDictionary
        
        if let localizedInfo = localizedInfoDictionary where !localizedInfo.isEmpty {
            info = localizedInfo
        }
        
        guard let unwrappedInfo = info else {
            return nil
        }
        
        return getNameByInfo(unwrappedInfo)
    }
    
    var monkeyking_bundleID: String? {
        return objectForInfoDictionaryKey("CFBundleIdentifier") as? String
    }
}

private extension String {
    
    var monkeyking_base64EncodedString: String? {
        return dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    var monkeyking_URLEncodedString: String? {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
    }
    
    var monkeyking_base64AndURLEncodedString: String? {
        return monkeyking_base64EncodedString?.monkeyking_URLEncodedString
    }
    
    var monkeyking_URLDecodedString: String? {
        return stringByReplacingOccurrencesOfString("+", withString: " ").stringByRemovingPercentEncoding
    }
    
    var monkeyking_QQCallbackName: String {
        
        var hexString = String(format: "%02llx", (self as NSString).longLongValue)
        while hexString.characters.count < 8 {
            hexString = "0" + hexString
        }
        
        return "QQ" + hexString
    }
}

private extension NSData {
    
    var monkeyking_JSON: [String: AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self , options: .AllowFragments) as? [String: AnyObject]
        } catch {
            return nil
        }
    }
}

private extension NSURL {
    
    var monkeyking_queryDictionary: [String: AnyObject] {
        
        var infos = [String: AnyObject]()
        
        let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        
        guard let items = components?.queryItems else {
            return infos
        }
        
        items.forEach {
            infos[$0.name] = $0.value
        }
        
        return infos
    }
}

private extension UIImage {
    
    var monkeyking_compressedImageData: NSData? {
        
        var compressionQuality: CGFloat = 0.7
        
        func compresseImage(image: UIImage) -> NSData? {
            
            let maxHeight: CGFloat = 240.0
            let maxWidth: CGFloat = 240.0
            var actualHeight: CGFloat = image.size.height
            var actualWidth: CGFloat = image.size.width
            var imgRatio: CGFloat = actualWidth/actualHeight
            let maxRatio: CGFloat = maxWidth/maxHeight
            
            if actualHeight > maxHeight || actualWidth > maxWidth {
                
                if imgRatio < maxRatio { // adjust width according to maxHeight
                    
                    imgRatio = maxHeight / actualHeight
                    actualWidth = imgRatio * actualWidth
                    actualHeight = maxHeight
                    
                } else if imgRatio > maxRatio { // adjust height according to maxWidth
                    
                    imgRatio = maxWidth / actualWidth
                    actualHeight = imgRatio * actualHeight
                    actualWidth = maxWidth
                    
                } else {
                    actualHeight = maxHeight
                    actualWidth = maxWidth
                }
            }
            
            let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight)
            UIGraphicsBeginImageContext(rect.size)
            image.drawInRect(rect)
            let imageData = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), compressionQuality)
            UIGraphicsEndImageContext()
            
            return imageData
        }
        
        var imageData = UIImageJPEGRepresentation(self, compressionQuality)
        
        guard imageData != nil else {
            return nil
        }
        
        let minCompressionQuality: CGFloat = 0.01
        let dataLengthCeiling: Int = 31500
        
        while imageData!.length > dataLengthCeiling && compressionQuality > minCompressionQuality {
            compressionQuality -= 0.1
            guard let image = UIImage(data: imageData!) else {
                break
            }
            imageData = compresseImage(image)
        }
        
        return imageData
    }
}