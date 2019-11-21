//
//  BaseViewController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
class BaseViewController: UIViewController {

    var isTap:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as UIGestureRecognizerDelegate);
        if #available(iOS 11.0, *){
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never;
        }else{
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    
    /**设置状态栏字体颜色**/
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        self.view.endEditing(true);
    }
    
    /**添加ITEM**/
    public func initBarItem(view:UIView,type:NSInteger){
        let buttonItem  = UIBarButtonItem.init(customView: view);
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil);
        spaceItem.width = -16
        switch type {
        case 0:
            if(kIOS11()){
                self.navigationItem.leftBarButtonItems = [spaceItem,buttonItem];
            }else{
                self.navigationItem.leftBarButtonItem = buttonItem;
            }
            break;
        case 1:
            if kIOS11(){
                self.navigationItem.rightBarButtonItems = [spaceItem,buttonItem];
            }else{
                self.navigationItem.rightBarButtonItem = buttonItem;
            }
            break;
        default:
            break;
        } 
    }
}
/*扩展添加uUIbarItem  分享 等**/
extension BaseViewController{
    /**添加单个导航栏按钮**/
    func setNavItem(imageName:String,title:String,action:Selector,index:Int){
        let btn:BadgeButton = BadgeButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(kFontTxtColor, for: .normal)
        btn.addTarget(self, action: action, for: .touchUpInside)
        if imageName.count>0 {
            btn.setImage(kImage_Named(name: imageName), for: .normal)
        }
        initBarItem(view: btn, type: index)
    }
    /**添加多个导航栏按钮**/
    func setNavItem(imageName:Array<String>,imageNameS:Array<String>,title:Array<String>,action:Selector,index:Int,sapce:Int){
        var items:[UIBarButtonItem] = []
        for (index,value) in imageName.enumerated() {
            let btn:BadgeButton = BadgeButton.init(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            if kValidStr(str: value as AnyObject) {
                btn.setImage(kImage_Named(name: value), for: .normal)
            }
            if kValidStr(str: imageNameS[index] as AnyObject) {
                btn.setImage(kImage_Named(name: imageNameS[index]), for: .selected)
            }
            btn.tag = 10086 + index;
            btn.titleLabel?.font = kFont(name: "PingFangSC-Medium", size: 14);
            btn.setTitleColor(kFontTxtColor, for: .normal)
            btn.addTarget(self, action: action, for: .touchUpInside)
            if(index==1){
                btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
            }else{
                btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10)
            }
            let item = UIBarButtonItem.init(customView: btn)
            items.append(item)
        }
        if (index==0) {
            self.navigationItem.leftBarButtonItems = items
        }else{
            self.navigationItem.rightBarButtonItems = items
        }
    }
}

/**UIGestureRecognizerDelegate**/
extension BaseViewController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.isTap {
            return false;
        }
        self.view.endEditing(true);
        // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
        // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
        if (self.navigationController?.children.count)!<=1 {
            return false;
        }
        let pan = gestureRecognizer as! UIPanGestureRecognizer;
        let point = pan.translation(in: self.view);
        if point.x<0{
            return false;
        }
        return true;
    }
}
