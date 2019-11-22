//
//  AppDelegate+Callback.swift
//  SwiftDemo
//
//  Created by john on 2019/11/22.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

extension AppDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var url1:String?
        do{
            url1 =  try String.init(contentsOf: url)
        }catch{}
        let flag:Bool = UMSocialManager.default()?.handleOpen(url) ?? false
        if (flag) {
            if((url1?.contains("wx44d165dfead69155://oauth"))! || (url1?.contains("tencent1109408142://qzapp/mqzone"))!){
                WXApi.handleOpen(url, delegate: self)
                return true
            }
            let result = UMSocialManager.default()?.handleOpen(url)
            return result!
        }else{
            //监听从hH5网页直接打开APP zhidi:
            if((url1?.contains("zhidi://"))!){
                return true
            }else{
                DispatchQueue.main.async {
                    WXApi.handleOpen(url, delegate: self)
//                    self.alipayWithURL(url: url)
                }
            }
        }
        return true
    }
    //支付宝回调 也可在调用支付宝成功后的回调里做处理任选其一
    fileprivate func alipayWithURL(url:URL) {
        if url.host == "safepay" {
            //跳转支付宝进行支付，处理支付结果
            AlipaySDK.defaultService()?.processAuthResult(url, standbyCallback: { (resultDic) in
                //            9000 订单支付成功
                //            8000 正在处理中
                //            4000 订单支付失败
                //            6001 用户中途取消
                //            6002 网络连接出错
                let status:Int = Int((resultDic?["resultStatus"] as? String) ?? "")!
                switch status{
                    case 9000:
                        kNotificationCenter.post(name: NSNotification.Name(rawValue: NOTI_ALI_PAY_SUCCESS), object: ["status":"success"])
                        AlertUtil.showTempInfo(info: "支付成功")
                        break
                    default:
                         kNotificationCenter.post(name: NSNotification.Name(rawValue: NOTI_ALI_PAY_SUCCESS), object: ["status":"failure"])
                         AlertUtil.showTempInfo(info: "支付失败")
                        break
                    }
            })
        }
    }
}
///WXApiDelegate
extension AppDelegate:WXApiDelegate{
    //发送一个sendReq后，收到微信的回应
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            //        WXSuccess           = 0,    /**< 成功    */
            //        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
            //        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
            //        WXErrCodeSentFail   = -3,   /**< 发送失败    */
            //        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
            //        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
            if(resp.errCode == WXSuccess.rawValue){
                kNotificationCenter.post(name: NSNotification.Name(rawValue: NOTI_WEI_XIN_PAY_SUCCESS), object: ["status":"success"])
            }else{
                kNotificationCenter.post(name: NSNotification.Name(rawValue: NOTI_WEI_XIN_PAY_SUCCESS), object: ["status":"failure"])
            }
        }
    }
}
