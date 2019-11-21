//
//  UIViewController+Ext.swift
//  SwiftDemo
//
//  Created by john on 2019/11/21.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

extension UIViewController{
    func configUSharePlatforms()  {
        /**友盟*/
        UMConfigure.initWithAppkey(UM_Appkey, channel: nil)
        /* 设置微信的appKey和appSecret */
        /**
         UMSocialPlatformType_WechatSession      = 1, //微信聊天
         UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
         UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
         UMSocialPlatformType_Qzone              = 5,//qq空间
         */
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: UMengSocial_WechatAppKey, appSecret: UMengSocial_WechatAppSecret, redirectURL: "http://www.baidu.com")
        /*
         * 移除相应平台的分享，如微信收藏
         */
//        UMSocialManager.default()?.removePlatformProvider(with: .wechatFavorite)
        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         */
        UMSocialManager.default()?.setPlaform(.QQ, appKey: UMengSocial_QQAppID, appSecret: nil, redirectURL: "")
        /* 设置新浪的appKey和appSecret */
        UMSocialManager.default()?.setPlaform(.sina, appKey: UMengSocial_SinaAppKey, appSecret: UMengSocial_SinaSecret, redirectURL: "http://www.baidu.com")
        UMSocialManager.default()?.openLog(true)
    }
    
    func application(application:UIApplication,url:NSURL,sourceApplication:String,annotation:Any) -> Bool {  //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        let result =  UMSocialManager.default()?.handleOpen(url as URL, sourceApplication: sourceApplication, annotation: annotation)
        return result!
    }
    
    /**授权登录*/
    func getAuthWithUserInfoFromPlat(type:UMSocialPlatformType,success:@escaping (_ openID:String?,_ name:String?,_ iconUrl:String?)->Void) {
        UMSocialManager.default()?.getUserInfo(with: type, currentViewController: nil, completion: { (result, error) in
            if((error) != nil){
                let str = type == .wechatSession ? "微信授权失败" : type == .sina ? "新浪授权失败" : "QQ授权失败"
                AlertUtil.showTempInfo(info: str)
            }else{
                let resp:UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                success(resp.uid , resp.name,resp.iconurl)
                
                print("Wechat uid:" + resp.uid)
                print("Wechat openid:" + resp.openid)
                print("Wechat accessToken:" + resp.unionId)
                print("Wechat refreshToken:" + resp.accessToken)
                print("Wechat expiration:" + resp.refreshToken)
                
                // 用户信息
                print("Wechat expiration:" + resp.name)
                print("Wechat expiration:" + resp.iconurl)
                print("Wechat expiration:" + resp.unionGender)
                
                // 第三方平台SDK源数据
                print(resp.originalResponse as Any)

            }
        })
    }
    /**分享图片*/
    func shareImageToPlatformType(platformType:UMSocialPlatformType) {
        //创建分享消息对象
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //创建图片内容对象
        let shareObject:UMShareImageObject = UMShareImageObject()
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = UIImage.init(named: "icon")
        shareObject.shareImage = "https://mobile.umeng.com/images/pic/home/social/img-1.png"
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    
    /**分享文本*/
    func shareTextToPlatformType(platformType:UMSocialPlatformType)  {
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //设置文本
        messageObject.text = "社会化组件UShare将各大社交平台接入您的应用，快速武装App。"
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    /**图文分享*/
    func shareImageAndTextToPlatformType(platformType:UMSocialPlatformType)  {
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //设置文本
        messageObject.text = "面向中国高净值人群推出的海外房掌上管理应用";
        //创建图片内容对象
        let shareObject:UMShareImageObject = UMShareImageObject()
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = UIImage.init(named: "iconS");
        shareObject.shareImage = "https://www.umeng.com/img/index/demo/1104.4b2f7dfe614bea70eea4c6071c72d7f5.jpg"
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    /**分享网页*/
    func shareWebPageToPlatformType(platformType:UMSocialPlatformType,model:ShareModel)  {
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        let url = URL.init(string: model.imgStr ?? "") ?? URL.init(string: "")
        var dataS:Data = Data()
        do {
            let data = try Data.init(contentsOf: url!)
            dataS = data
        }catch{}
        var imagea:UIImage? = UIImage.init(data: dataS as Data)
        if(imagea == nil){
            imagea = kImage_Named(name: "Logo");
        }
        //创建网页内容对象
        let shareObject:UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: model.title, descr: model.content, thumImage: imagea)
        //设置网页地址
        shareObject.webpageUrl = model.urlPath;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    
    /**分享音乐*/
    func shareMusicToPlatformType(platformType:UMSocialPlatformType){
        
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //创建音乐内容对象
        let shareObject:UMShareMusicObject = UMShareMusicObject.shareObject(withTitle: "分享标题", descr: "分享内容描述", thumImage: UIImage.init(named: "iconS"))
        //设置音乐网页播放地址
        shareObject.musicUrl = "http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect";
        //            shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    
    /**分享视频*/
    func shareVedioToPlatformType(platformType:UMSocialPlatformType){
        
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //创建视频内容对象
        let shareObject:UMShareVideoObject = UMShareVideoObject.shareObject(withTitle: "分享标题", descr: "分享内容描述", thumImage: UIImage.init(named: "iconS"))
        //设置视频网页播放地址
        shareObject.videoUrl = "http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect";
        //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    /**分享微信表情*/
    func shareEmoticonToPlatformType(platformType:UMSocialPlatformType){
        
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //创建视频内容对象
        let shareObject:UMShareEmotionObject = UMShareEmotionObject.shareObject(withTitle: "", descr: "", thumImage: nil)
        let filePath = Bundle.main.path(forResource: "gifFile", ofType: "gif")
        let emoticonData = NSData.init(contentsOfFile: filePath!)
        shareObject.emotionData = emoticonData as Data?;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
    
    /**分享微信小程序*/
    func shareMiniProgramToPlatformType(platformType:UMSocialPlatformType)  {
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        //创建视频内容对象
        let shareObject:UMShareMiniProgramObject = UMShareMiniProgramObject.shareObject(withTitle: "小程序标题", descr: "小程序内容描述", thumImage: UIImage.init(named: "iconS")) as! UMShareMiniProgramObject
        shareObject.webpageUrl = "兼容微信低版本网页地址";
        shareObject.userName = "小程序username，如 gh_3ac2059ac66f";
        shareObject.path = "小程序页面路径，如 pages/page10007/page10007";
        messageObject.shareObject = shareObject;
        shareObject.hdImageData = NSData.init(contentsOfFile: Bundle.main.path(forResource: "logo", ofType: "png")!) as Data?
        shareObject.miniProgramType = UShareWXMiniProgramType.release; // 可选体验版和开发板
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if((error) != nil){
                print(error as Any)
            }else{
                print(data as Any)
            }
        })
    }
}

class ShareModel: NSObject {
    var title:String?//标题
    var content:String?//内容
    var urlPath:String?//分享的链接
    var imgStr:String?//分享的图片
}
