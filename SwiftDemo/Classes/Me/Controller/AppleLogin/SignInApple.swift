//
//  SignInApple.swift
//  SwiftDemo
//
//  Created by john on 2020/2/13.
//  Copyright © 2020 qt. All rights reserved.
//

import UIKit
import AuthenticationServices
typealias succHandle =  ((_ token: String, _ code: String) -> Void)
class SignInApple: NSObject {
    var SuccBlock: succHandle?
    static let sharedInstance = SignInApple()
    //处理授权
    func handleAuthorizationAppleIDButtonPress(block: succHandle?) {
        if #available(iOS 13.0, *) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            // 创建新的AppleID 授权请求
            let appleIDRequest = appleIDProvider.createRequest()
            // 在用户授权期间请求的联系信息
            appleIDRequest.requestedScopes = [ASAuthorization.Scope.fullName, ASAuthorization.Scope.email]
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            authorizationController.presentationContextProvider = self
            // 在控制器初始化期间启动授权流
            authorizationController.performRequests()
            SuccBlock = block
        }else{
            AlertUtil.showTempInfo(info: "系统版本过低,不支持Apple登录")
        }
    }
    // 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
    func perfomExistingAccountSetupFlows() {
        if #available(iOS 13.0, *) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            // 授权请求AppleID
            let appleIDRequest = appleIDProvider.createRequest()
            // 为了执行钥匙串凭证分享生成请求的一种机制
            let passwordProvider = ASAuthorizationPasswordProvider()
            let passwordRequest = passwordProvider.createRequest()
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest, passwordRequest])
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            authorizationController.presentationContextProvider = self
            // 在控制器初始化期间启动授权流
            authorizationController.performRequests()
        }else{
            AlertUtil.showTempInfo(info: "系统版本过低,不支持Apple登录")
        }
    }
}

extension SignInApple: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){        print("授权完成回调:\(authorization.credential)")
        if authorization.credential.isKind(of: ASAuthorizationAppleIDCredential.self) {
            // 用户登录使用ASAuthorizationAppleIDCredential
            let appleIDCredential: ASAuthorizationAppleIDCredential = authorization.credential as! ASAuthorizationAppleIDCredential
//            let user = appleIDCredential.user
//            // 使用过授权的，可能获取不到以下三个参数
//            let familyName = appleIDCredential.fullName.familyName
//            let givenName = appleIDCredential.fullName.givenName
//            let email = appleIDCredential.email;
            
            let identityToken = appleIDCredential.identityToken
            let authorizationCode = appleIDCredential.authorizationCode
            // 服务器验证需要使用的参数
            guard let idToken = identityToken else {return}
            guard let authorCode = authorizationCode else {return}
            let identityTokenStr: String = String.init(data: idToken, encoding: String.Encoding.utf8) ?? ""
            let authorizationCodeStr: String = String.init(data: authorCode, encoding: String.Encoding.utf8) ?? ""
            SuccBlock?(identityTokenStr, authorizationCodeStr)
            print("token:\(String(describing: identityTokenStr))\ncode:\(String(describing: authorizationCodeStr))")
        }else if authorization.credential.isKind(of: ASPasswordCredential.self){
            let passwordCredential: ASPasswordCredential = authorization.credential as! ASPasswordCredential
            // 密码凭证对象的用户标识 用户的唯一标识
            let user = passwordCredential.user
            // 密码凭证对象的密码
            let password = passwordCredential.password
            print("\(user),\(password)")
        }else{
            print("授权信息不符")
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error){
       
        print("\(error.localizedDescription)")
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last!
    }
}
