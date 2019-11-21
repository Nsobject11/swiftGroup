//
//  MBProgressHUD+Ext.swift
//  SwiftDemo
//
//  Created by john on 2019/11/13.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
extension MBProgressHUD{
    static let hud_interval:Int = 2;
     /*展示message在window上**/
    class func an_showTipMessageInWindow(message:String,aTimer:Int=2){
        MBProgressHUD().showTipMessage(message: message, isWindow: true, timer: aTimer)
    }
    /*展示message在view上**/
    class func an_showTipMessageInView(message:String,aTimer:Int=2){
        MBProgressHUD().showTipMessage(message: message, isWindow: false, timer: aTimer)

    }
    /**只显示菊花**/
    class func an_showActivity(){
        MBProgressHUD().showActivityMessage(message: "", isWindow: true, timer: 0)
    }
    
    class func an_showActivityMessageInWindow(message:String,timer:Int=0){
        MBProgressHUD().showActivityMessage(message: message, isWindow: true, timer: timer)
    }
    
    class func an_showActivityMessageInView(message:String,timer:Int=0){
        MBProgressHUD().showActivityMessage(message: message, isWindow: false, timer: timer)
    }
    
    class func an_showSuccessMessage(message:String){
        let name = "MBProgressHUD+AN.bundle/MBProgressHUD/MBHUD_Success";
        self.an_showCustomIconInWindow(iconName: name, message: message);
    }
    
    class func an_showErrorMessage(message:String){
        let name = "MBProgressHUD+AN.bundle/MBProgressHUD/MBHUD_Error";
        self.an_showCustomIconInWindow(iconName: name, message: message);
    }
    
    class func an_showInfoMessage(message:String){
        let name = "MBProgressHUD+AN.bundle/MBProgressHUD/MBHUD_Info";
        self.an_showCustomIconInWindow(iconName: name, message: message);
    }
    
    class func an_showWarnMessage(message:String){
        let name = "MBProgressHUD+AN.bundle/MBProgressHUD/MBHUD_Warn";
        self.an_showCustomIconInWindow(iconName: name, message: message);
    }
    
    class func an_showCustomIconInWindow(iconName:String,message:String){
        MBProgressHUD().an_showCustomIcon(iconName: iconName, message: message, isWindow: true);
    }
    
    class func an_showCustomIconInView(iconName:String,message:String){
        MBProgressHUD().an_showCustomIcon(iconName: iconName, message: message, isWindow: false);
    }
    
    /**hud消失**/
    class func an_dismiss(){
        let winView = UIApplication.shared.delegate?.window as? UIView;
        MBProgressHUD.hide(for: winView!, animated: true)
        MBProgressHUD.hideAllHUDs(for: winView!, animated: true)
    }
    
    /**创建MBProgress**/
    private func createMBProgressHUDviewWithMessage(message:String,isWindow:Bool)->MBProgressHUD{
        
        let view = (isWindow ? UIApplication.shared.delegate?.window : getCurrentUIVC().view) as? UIView
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.label.text = message
        hud.label.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        hud.label.numberOfLines = 0;
        hud.removeFromSuperViewOnHide = false;
        hud.bezelView.color = KHexColor(color: "000000", alpha: 0.8);
        hud.contentColor = UIColor.white;
        return hud;
        
    }
    
    private func showTipMessage(message:String,isWindow:Bool,timer:Int){
        an_dismissNoDelay()
        let hud = createMBProgressHUDviewWithMessage(message: message, isWindow: isWindow)
        hud.mode = .text;
        hud.bezelView.style = .solidColor;
        hud.contentColor = UIColor.white;
        hud.hide(animated: true, afterDelay: 1)
    }
    
    
    private func showActivityMessage(message:String,isWindow:Bool,timer:Int){
        let hud = createMBProgressHUDviewWithMessage(message: message, isWindow: isWindow)
        //自定义动画
        hud.mode = .customView;
        hud.backgroundColor = KClearColor
        hud.bezelView.style = .solidColor;
        hud.frame = CGRect(x: kScreenWidth/2-50, y: kScreenHeight/2-50, width: 100, height: 100)
        hud.bezelView.color = UIColor.white
        let image = UIImage.gif(name:"加载")
        let loadingView = UIImageView.init(frame: CGRect(x: hud.k_width/2-50, y: hud.k_height/2-50, width: 100, height: 100))
        loadingView.image = image;
        hud.customView = loadingView;
        if (timer>0) {
            hud.hide(animated: true, afterDelay: TimeInterval(timer));
        }
    }
    
    private func an_showCustomIcon(iconName:String,message:String,isWindow:Bool){
        an_dismissNoDelay()
        let hud = createMBProgressHUDviewWithMessage(message: message, isWindow: isWindow)
        hud.customView = UIImageView.init(image: UIImage(named: iconName));
        hud.mode = .customView;
        hud.bezelView.style = .solidColor;
        hud.hide(animated: true, afterDelay: 2)
    }
    
    private func an_dismissNoDelay(){
        let winView = UIApplication.shared.delegate?.window as? UIView
        MBProgressHUD.hide(for: winView!, animated: true)
        MBProgressHUD.hideAllHUDs(for: getCurrentUIVC().view, animated: true) 
    }
}
