//
//  AppDelegate+AppService.swift
//  SwiftDemo
//
//  Created by john on 2019/11/22.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

extension AppDelegate{
    ///注册极光
    func registerJPushWith(launchOptions:[UIApplication.LaunchOptionsKey: Any]?) {
        #if !targetEnvironment(simulator)
        if(IOS10_OR_LATER){
            let JPushEntity:JPUSHRegisterEntity = JPUSHRegisterEntity()
            JPushEntity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: JPushEntity, delegate: self)
        }else if(IOS8_OR_LATER){
            let categorys:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.sound.rawValue, categories: NSSet.init(object: categorys) as? Set<AnyHashable>)
        }
        JPUSHService.setup(withOption: launchOptions, appKey: Jpush_appKey, channel: "App Store", apsForProduction: false)
        JPUSHService.registrationIDCompletionHandler({(resCode,registrationID) in
            if(resCode == 0){
                print("registrationID获取成功：" + (registrationID ?? ""));
            } else {
                print("registrationID获取失败：", String(resCode));
            }
        })
        #endif
    }
    
    ///推送消息监听处理
    func receiveNotice(noti:[AnyHashable : Any],isForgend:Bool) {
        print("消息监听成功" + noti.description)
    }
}

/**JPUSHRegisterDelegate**/
extension AppDelegate:JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
       
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册失败did Fail To Register For Remote Notifications With Error")
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // 接收到消息回调方法
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        self.receiveNotice(noti: userInfo, isForgend: true)
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }else {
            //本地通知
        }
        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }else {
            //本地通知
        }
        //处理通知 跳到指定界面等等
        self.receiveNotice(noti: userInfo, isForgend: false)
        completionHandler()
    }
}
