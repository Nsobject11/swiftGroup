//
//  BaseNavController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class BaseNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置navigaionbar的背景颜色
        self.navigationBar.tintColor = KHexColor(color: "ffffff");
        self.navigationBar.shadowImage = UIImage.init();
        UITabBar.appearance().isTranslucent = false;
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let btn = UIButton.kCreatBtn(target: self, action: #selector(BaseNavController.backTop), image: "fenlei_tuibiao_fanhui", title: "", rect: CGRect(x: 0, y: 0, width: 44, height: 44))
            let baseVc = viewController as!BaseViewController
            baseVc.initBarItem(view: btn, type: 0)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    //返回方法
    @objc private func backTop() {
        self.popViewController(animated: true);
    }
}
//实现手势代理，解决重新自定义导航栏左侧按钮，导致系统自带侧滑手势不可用问题
extension BaseNavController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.children.count == 1 {
            return false
        }
        return true
    }
}
