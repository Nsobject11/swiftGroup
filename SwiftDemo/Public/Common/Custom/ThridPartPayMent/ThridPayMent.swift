//
//  ThridPayMent.swift
//  SwiftDemo
//
//  Created by john on 2019/11/21.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

enum PartyPaymentType: Int{
    case PartyPaymentTypeAlipay //支付宝
    case PartyPaymentTypeWechat //微信
}
//区分不同发起订单  根据实际需求增加
enum PartyPayment: Int{
    case PartyPaymentOrder //区分不同发起订单
    case PartyPaymentCase //案例
}

class ThridPayMent: NSObject {
    
    /** 后台统一下单接口 */
    class func vPay(orderNo:String,type:PartyPayment,payType:PartyPaymentType){
        if type == .PartyPaymentOrder {
            //请求网络数据
            let model:PayModel = PayModel()
            model.alipayStr = ""
            model.appid = ""
            ThridPayMent.payByThirdPartyWithPaymet(payment: payType, model: model)
        }else if(type == .PartyPaymentCase){
//            ThridPayMent.payByThirdPartyWithPaymet(payment: payType, model: <#T##payModel#>)
        }
    }
    
    /** 调起第三方支付统一接口 */
    class func payByThirdPartyWithPaymet(payment:PartyPaymentType,model:PayModel){
        
        switch payment {
        case .PartyPaymentTypeAlipay:
            ThridPayMent.p_payByAlipayWithPayOrder(payOrder: model.alipayStr ?? "")
            break
        case .PartyPaymentTypeWechat:
            ThridPayMent.p_payByWeChatWithPartnerId(model: model)
            break
        }
    }
    ///** 调起支付宝支付 */
    class func p_payByAlipayWithPayOrder(payOrder:String){
        // NOTE: 调用支付结果开始支付
        AlipaySDK.defaultService()?.payOrder(payOrder, fromScheme: "swiftDemo", callback: { (resultDic) in
            let value:Int = Int(resultDic?["resultStatus"] as? String ?? "") ?? 0
            if(value == 9000){//支付成功请求后台接口查询结果
                kNotificationCenter.post(name: NSNotification.Name(rawValue: NOTI_ALI_PAY_SUCCESS), object: ["status":"success"])
            }else{
                kNotificationCenter.post(name: NSNotification.Name(rawValue: NOTI_ALI_PAY_SUCCESS), object: ["status":"failure"])
            }
        })
    }
    ///** 调起微信支付 */
    class func p_payByWeChatWithPartnerId(model:PayModel){
        let request = PayReq()
        request.partnerId = model.partnerid;
        request.prepayId = model.prepayid;
        request.package = "Sign=WXPay";
        request.nonceStr = model.noncestr;
        request.timeStamp = UInt32(model.timestamp!)!
        request.sign = model.sign;
        WXApi.send(request)
    } 
}
