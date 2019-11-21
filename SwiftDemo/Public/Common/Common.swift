//
//  Common.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import SnapKit
// 每次加载数据条数
let kPageSize:Int = 20

/**获取系统对象**/
let kAppWindow = UIApplication.shared.delegate?.window
let kAppDelegate = UIApplication.shared.delegate
let kRootViewController = UIApplication.shared.delegate?.window!!.rootViewController
let kUserDefaults = UserDefaults.standard
let kNotificationCenter = NotificationCenter.default

/*屏幕尺寸**/
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreen_Bounds = UIScreen.main.bounds

/*系统类型**/
let kIsIphoneX = UIApplication.shared.statusBarFrame.size.height == 44 ? true : false
let kStatusBarHeight = kIsIphoneX ? 44 : 20
let kIndicatorHeight = kIsIphoneX ? 34 : 0
let kNavBarHeight = 44.0
let kTabBarHeight = kIsIphoneX ? 83 : 49
let kTopHeight:CGFloat = kIsIphoneX ? 88 : 64 // 这个高度根据是否是iPhone X系列手机, 来设置导航条高度, 不能使用 [[UIApplication sharedApplication] statusBarFrame].size.height 动态获取, 定位/拨打电话/共享热点会导致页面布局错落

//*常用定义**/
let kCachesDirectory:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!

func kURL(urlString:String) -> URL {
    return URL.init(string: urlString)!
}

func kImgNetUrl(urlSytring:String)->String{
    return Moya_baseURL + urlSytring
}

func kSystemFont(size:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size)
}

func kFont(name:String,size:CGFloat)->UIFont{
    return UIFont.init(name: name, size: size)!
}

func kImage_Named(name:String)->UIImage{
    return UIImage(named: name)!
}
/**发送通知**/
func kPostNotification(name:String,obj:AnyObject){
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: obj)
}

///*判断AnyObject是否为空**/
//func kStrValid(value:Any) -> Bool {
//    //首先判断是否为nil
//    if (value is NSNull) {
//        //对象是nil，直接认为是空串
//        return true
//    }else{
//        //然后是否可以转化为String
//        if let myValue  = value as? String{
//            //然后对String做判断
//            return myValue == "" || myValue == "(null)" || 0 == myValue.count
//        }else{
//            //字符串都不是，直接认为是空串
//            return true
//        }
//    }
//}

/**判断字符串是否为空*/
func kValidStr(str:AnyObject)->Bool{
    if (str.isKind(of: NSString.self)){
        let str1 = str as! String
        if(str1 != "" && str1.count>0){
            return false
        }
    }
    return true
}

func kValidDict(f:AnyObject) -> Bool {
    guard f is NSNull else {
       return f.isKind(of: NSDictionary.self)
    }
    return false
}

func kValidArray(f:AnyObject) -> Bool {
    guard f is NSNull else {
        return f.isKind(of: NSArray.self)
    }
    return false
}

func kValidNum(f:AnyObject) -> Bool {
    guard f is NSNull else {
        return f.isKind(of: NSNumber.self)
    }
    return false
}

func kValidClass(f:AnyObject,c:AnyClass) -> Bool {
    return f.isKind(of: c.self)
}

func kValidData(f:AnyObject) -> Bool {
    guard f is NSNull else {
        return f.isKind(of: NSData.self)
    }
    return false
}

/**颜色**/
let KWitheColor = UIColor.white
let KClearColor = UIColor.clear
let kRandomColor = UIColor.kRandomColor
/**主题文字颜色*/
let kFontTxtColor = KHexColor(color: "313235");


//View 圆角和加边框
func kViewBorderRadius(view:UIView,Radius:CGFloat,Width:CGFloat,Color:UIColor) {
    view.layer.cornerRadius = Radius
    view.layer.masksToBounds = true
    view.layer.borderWidth = Width
    view.layer.borderColor = Color.cgColor
}

// View 圆角
func kViewRadius(view:UIView,Radius:CGFloat){
    view.layer.cornerRadius = Radius
    view.layer.masksToBounds = true
}

//view 阴影
func KViewRadiusShadow(view:UIView,Radius:CGFloat,color:UIColor = KHexColor(color:"ADB5BA",alpha:0.22)){
    view.layer.cornerRadius = Radius
    view.backgroundColor = UIColor.white
    view.layer.masksToBounds = false
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    view.layer.shadowOpacity = 0.8
    view.layer.shadowRadius = 8
}

/**判断是否是IOS11*/
func kIOS11()->(Bool){
    if #available(iOS 11.0, *) {
        return true
    }else {
        return false
    }
}

/**返回颜色**/
func KHexColor(color:String,alpha:CGFloat=1) ->UIColor{
    return UIColor.init(hex: color, alpha: alpha)
}

/**返回RGB颜色**/
func KRGB(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1) -> UIColor{
    return UIColor.kColorWith(r: r, g: g, b: b, alpha: alpha);
}

/*延时调用**/
typealias TaskT = (_ cancel: Bool) ->()
func delay(_ time: TimeInterval, task: @escaping ()->()) -> TaskT? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->())? = task
    var result: TaskT?
    let delayedClosure: TaskT = { cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}
/**取消延时**/
func cancel(_ task: TaskT?) {
    task?(true)
}


