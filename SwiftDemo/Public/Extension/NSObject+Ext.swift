//
//  NSObject+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/4/3.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

extension NSObject {
    
    /// 动态添加属性
    ///
    /// - Parameters:
    ///   - key: 唯一值
    ///   - value: 保存的值
    public func k_setAssociatedObject(key: String, value: Any?) {
        guard let keyHashValue = UnsafeRawPointer(bitPattern: key.hashValue) else { return }
        objc_setAssociatedObject(self, keyHashValue, value, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// 获取属性值
    ///
    /// - Parameter key: 唯一值
    /// - Returns: 保存的值
    public func k_getAssociatedObject(key: String) -> Any? {
        guard let keyHashValue = UnsafeRawPointer(bitPattern: key.hashValue) else { return nil }
        return objc_getAssociatedObject(self, keyHashValue)
    }
    
//    获取根window
    public func getKeyWindow()->UIWindow{
        let window = UIApplication.shared.keyWindow;
        return window!;
    }
    
    /**获取当前控制器**/
    func getCurrentVC()->UIViewController{
        var result:UIViewController?
        var window = getKeyWindow();
        if window.windowLevel != .normal {
            let windows = UIApplication.shared.windows;
            for tmpWin  in windows{
                if tmpWin.windowLevel == .normal{
                    window = tmpWin;
                    break;
                }
            }
        }
        let frontView = window.subviews[0];
        let nextResponder = frontView.next;
        if (nextResponder?.isKind(of: UIViewController.self))! {
            result = (nextResponder as! UIViewController);
        }else{
            result = window.rootViewController;
        }
        return result!;
    }
    
    func getCurrentUIVC() -> UIViewController {
        let superVC = getCurrentVC();
        if(superVC.isKind(of: UITabBarController.self)){
            let TabVC = superVC as! UITabBarController
            let tabSelectVC = TabVC.selectedViewController
            if((tabSelectVC?.isKind(of: UINavigationController.self))!){
                let navCon = tabSelectVC as! UINavigationController;
                return navCon.viewControllers.last!
            }
            return tabSelectVC!
        }else if(superVC.isKind(of: UINavigationController.self)){
            let navCon = superVC as! UINavigationController
            return navCon.viewControllers.last!
        }
        return superVC
    }
}
