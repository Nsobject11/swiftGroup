//
//  RefineAlertView.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
enum RefineAlertViewStyle: Int{
    case Top// 从上到下
    case Down // 从下到上
    case Right// 从右到左
    case Left // 从左到右
    case Spring //由上到下的回弹动画
}

class RefineAlertView: UIView {
    
    let animationTime:Float = 0.3 //动画弹窗时间
    var isAllowUserInterface:Bool=true{
        didSet{
            blackView?.isUserInteractionEnabled = isAllowUserInterface
        }
    }
    var blackView:UIView?
    var bgView:UIView?
    var isOpen:Bool = false //是否允许点击背景
    var subView:UIView?
    var ReStyle:RefineAlertViewStyle = .Down
    
    init(frame:CGRect,viewB:UIView,style:RefineAlertViewStyle) {
        super.init(frame: frame)
        subView = viewB
        ReStyle = style
        setUI(frame: frame)
    }
    
    func setUI(frame:CGRect) {
        let bView = UIView(frame: frame)
        bView.backgroundColor = KHexColor(color: "000000", alpha: 0.3)
        addSubview(bView)
        blackView = bView
    }
    
    /**视图弹出**/
    func alertSelectViewshow() {
        if ((self.bgView) != nil){return}
        self.isOpen = true
        var frame:CGRect = .zero
        var frameStart:CGRect  = .zero
        let TANWIDTH:CGFloat  = subView!.frame.width
        let TANHIDTH:CGFloat = subView!.frame.height
        switch ReStyle {
        case .Top:
            subView?.k_height = 0
            frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 0)
            frameStart = CGRect(x: 0, y: 0, width: kScreenWidth, height: TANHIDTH)
            break
        case .Down:
            frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: TANHIDTH)
            frameStart = CGRect(x: 0, y: kScreenHeight-TANHIDTH, width: kScreenWidth, height: TANHIDTH)
            break
        case .Right:
            frame = CGRect(x: kScreenWidth, y: 0, width: TANWIDTH, height: TANHIDTH)
            frameStart = CGRect(x: kScreenWidth - TANWIDTH, y: 0, width: TANWIDTH, height: TANHIDTH)
            break
        case .Left:
            frame = CGRect(x: -TANWIDTH, y: 0, width: TANWIDTH, height: TANHIDTH)
            frameStart = CGRect(x: 0, y: 0, width: TANWIDTH, height: TANHIDTH)
            break
        case .Spring:
            frame = CGRect(x: kScreenWidth/2-TANWIDTH/2, y: -TANHIDTH, width: TANWIDTH, height: TANHIDTH)
            frameStart = CGRect(x: kScreenWidth/2-TANWIDTH/2, y: kScreenHeight/2-TANHIDTH/2, width: TANWIDTH, height: TANHIDTH)
            break
        }
        
        let bView = UIView.init(frame: frame)
        bView.backgroundColor = .clear;
        bView.isUserInteractionEnabled = true;
        bView.addSubview(subView!)
        self.addSubview(bView)
        bgView = bView
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClose))
        self.blackView?.isUserInteractionEnabled = true
        self.blackView?.addGestureRecognizer(tap)
        if self.ReStyle == .Spring {
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 0.65 , initialSpringVelocity: 0.5 , options: [] , animations: {
                bView.frame = frameStart
            }, completion: nil)
        }else{
            UIView.animate(withDuration: TimeInterval(animationTime)) {
                bView.frame = frameStart
                if(self.subView?.k_height==0){
                    self.subView?.k_height = TANHIDTH
                }
            }
        }
        
        kRootViewController?.view.addSubview(self)
    }
    
    @objc func tapClose() {
        self.isOpen = false
        let TANWIDTH:CGFloat  = subView!.frame.width
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            if (self.ReStyle == .Right) {
                self.bgView?.k_x = kScreenWidth;
            }else if(self.ReStyle == .Left){
                self.bgView?.k_x = -TANWIDTH;
            }else if(self.ReStyle == .Top){
                self.bgView?.k_height = 0
                self.subView?.k_height = 0
            } else if(self.ReStyle == .Down){
                self.bgView?.k_y = kScreenHeight;
            } else{
                self.subView?.alpha = 0
            }
            self.blackView!.alpha = 0;
        }) { (flag) in
            self.bgView?.removeFromSuperview()
            self.bgView = nil;
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    } 
}
