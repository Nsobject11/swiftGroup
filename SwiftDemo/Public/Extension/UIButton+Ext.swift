//
//  UIButton+Ext.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
enum ButtonEdgeInsetsStyle: Int{
    case ButtonEdgeInsetsStyleTop// image在上，label在下
    case ButtonEdgeInsetsStyleLeft // image在左，label在右
    case ButtonEdgeInsetsStyleBottom// image在下，label在上
    case ButtonEdgeInsetsStyleRight // image在右，label在左
}
extension UIButton{
    /**
     *  设置button的titleLabel和imageView的布局样式，及间距
     *
     *  @param style titleLabel和imageView的布局样式
     *  @param space titleLabel和imageView的间距
     */
    func layoutButtonWithEdgeInsetsStyle(style:ButtonEdgeInsetsStyle,imageTitleSpace:CGFloat) {
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith:CGFloat = self.imageView?.image?.size.width ?? 0
        let imageHeight:CGFloat = self.imageView?.image?.size.height ?? 0
        
        var labelWidth:CGFloat = 0.0;
        var labelHeight:CGFloat = 0.0;
        let version:String = UIDevice.current.systemVersion
        if (version.k_toCGFloat() > 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0;
            labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0
        } else {
            labelWidth = self.titleLabel?.frame.size.width ?? 0
            labelHeight = self.titleLabel?.frame.size.height ?? 0
        }
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets:UIEdgeInsets = .zero;
        var labelEdgeInsets:UIEdgeInsets = .zero;
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        
        switch (style) {
        case .ButtonEdgeInsetsStyleTop:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2.0, left: 0, bottom: 0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-imageTitleSpace/2.0, right: 0);
        break;
        case .ButtonEdgeInsetsStyleLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2.0, bottom: 0, right: imageTitleSpace/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2.0, bottom: 0, right: -imageTitleSpace/2.0);
        break;
        case .ButtonEdgeInsetsStyleBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-imageTitleSpace/2.0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-imageTitleSpace/2.0, left: -imageWith, bottom: 0, right: 0);
        break;
        case .ButtonEdgeInsetsStyleRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2.0, bottom: 0, right: -labelWidth-imageTitleSpace/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-imageTitleSpace/2.0, bottom: 0, right: imageWith+imageTitleSpace/2.0);
        break;
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
    
    
    /**创建UIButton**/
    class func kCreatBtn(target:AnyObject,action:Selector,image:String,title:String="",rect:CGRect=CGRect(x: 0, y: 0, width: 44, height: 44))->(UIButton){
        let btn = UIButton.init(type: .custom)
        btn.frame = rect
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle(title, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        if(image.count>0){
            btn.setImage(UIImage.init(named: image), for: .normal)
        }
        return btn
    }
    
    //    倒计时
    public func timeChange(){
        self.isEnabled = false
        self.layer.borderColor = UIColor.init(hex: "#CECDCD").cgColor
        self.setTitleColor(UIColor.init(hex: "#CECDCD"), for: .normal)
        var time = 60
        var codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        var remainingCount: Int = time {
            willSet {
                setTitle("\(newValue)s", for: .normal)
                if newValue <= 0 {
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        if codeTimer.isCancelled {
            codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
            
        }
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.isEnabled = true
                    self.layer.borderColor = UIColor.theme.cgColor
                    self.setTitleColor(UIColor.theme, for: .normal)
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}

/// 延迟调用,防止多次调用
extension UIControl {
    
    /// 延迟时间
    public var k_delayDuration: Double? {
        set {
            k_setAssociatedObject(key: "kUIButtonDelayDurationKey", value: newValue)
        }
        get { return k_getAssociatedObject(key: "kUIButtonDelayDurationKey") as? Double }
    }
    
    /// 按钮是否可用
    private var isBtnActionEnabled: Bool {
        set {
            k_setAssociatedObject(key: "kUIButtonDelayKey", value: newValue)
        }
        get { return (k_getAssociatedObject(key: "kUIButtonDelayKey") as? Bool) ?? true }
    }
    
    /// 发送事件
    @objc func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if self.k_delayDuration != nil {
            if self.isBtnActionEnabled {
                self.isBtnActionEnabled = false
                mySendAction(action, to: target, for: event)
                self.isBtnActionEnabled = true
            }
        } else {
            mySendAction(action, to: target, for: event)
        }
    }
}
