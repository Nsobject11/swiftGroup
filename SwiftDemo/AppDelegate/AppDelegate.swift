//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var deviceToken:Data? = nil
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        WXApi.registerApp(UMengSocial_WechatAppKey, enableMTA: true)
//        registerJPushWith(launchOptions: launchOptions) //注册极光
        setRootController();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //识别剪贴板中的内容
        if let paste = UIPasteboard.general.string,
            paste.contains("http://") {
            print(UIPasteboard.general.string as Any)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

