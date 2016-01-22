//
//  JPushHelper.swift
//  SwiftGG
//
//  Created by Semper_Idem on 16/1/20.
//  Copyright © 2016年 swiftgg. All rights reserved.
//

import UIKit

/// JPush 辅助类
class JPushHelper {
    
    private static let appKey = "65781a04c446abeebb9ab527"
    /// 指明应用程序包的下载渠道，为方便分渠道统计
    private static let channel = "App Store"
    /// 用于标识当前应用所使用的APNs证书环境
    /// false 表示采用的是开发证书，true 表示采用生产证书发布应用
    private static var apsForProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
    
    /// 配置 JPush，初始化
    class func setupJPushWithLaunchOptions(launchOptions: [NSObject: AnyObject]?) {
        // 注册通知类型
        let types: UIUserNotificationType = [.Badge, .Sound, .Alert]
        JPUSHService.registerForRemoteNotificationTypes(types.rawValue, categories: nil)
        // JPush 配置
        JPUSHService.setupWithOption(launchOptions, appKey: appKey, channel: channel, apsForProduction: apsForProduction)
    }
    
    /// 注册 Device Token
    class func registerDeviceToken(deviceToken: NSData) {
        print("【推送】Device Token：\(deviceToken)")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    /// 基本的通知处理
    class func handleRemoteNotification(userInfo: [NSObject: AnyObject]) {
        handleRemoteAPNMessage(userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
        print("【推送】收到的通知为：\(notificationMessageHandle(userInfo))")
    }
    
    /// 处理 APNs 信息
    class func handleRemoteAPNMessage(userInfo: [NSObject: AnyObject]) {
        // 取得 APNs 内容
        guard let aps = userInfo["aps"] as? NSDictionary,
            content = aps["alert"] as? String,
            badge = aps["badge"] as? Int,
            sound = aps["sound"] as? String else { return }
        // TODO: 需要对取得的内容进行处理
        print("取得的内容为：\(content)，显示的badge数目为：\(badge)，播放声音：\(sound)")
    }
    
    /// 将收到的通知文字转换为 UTF8 类型，否则的话接收到的信息将会为 \Uxxx
    /// 例如："\ud83d\udc36" -> "🐶"
    private class func notificationMessageHandle(userinfo: [NSObject: AnyObject]) -> String {
        if userinfo.isEmpty { return "" }
        let tempStr1 = userinfo.description.stringByReplacingOccurrencesOfString("\\u", withString: "\\U")
        let tempStr2 = tempStr1.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        let tempStr3 = "\"" + tempStr2 + "\""
        guard let tempData = tempStr3.dataUsingEncoding(NSUTF8StringEncoding) else { return "" }
        var returnString: String?
        do {
            try returnString = NSPropertyListSerialization.propertyListWithData(tempData, options: .Immutable, format: nil) as? String
        } catch let error {
            print("【推送】通知解析错误，错误原因：\(error)")
        }
        return returnString ?? ""
    }
}
