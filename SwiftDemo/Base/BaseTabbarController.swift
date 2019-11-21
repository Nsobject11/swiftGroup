//
//  BaseTabbarController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {

    static let sharedInstance: BaseTabbarController = {
        let instance = BaseTabbarController()
        return instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItems();
        changeItemTextColourAndFont();
        removeTabBarTopLine();
    }
    
    /*添加item**/
    private func addItems() {
        let home = HomeController();
        let profile = ProfileController();
        let arrVC = [home,profile];
        let titleArr = ["首页","我"];
        let picArr = ["shoucang_tuibiao_shouye_huise","shouye_icon_wode"];
        let picSArr = ["shouye_icon","wode_tubiao"];
        for i in 0...arrVC.count-1 {
            addChildViewController(childController: arrVC[i], title: titleArr[i], image: picArr[i], selectedImage: picSArr[i]);
        }
        
    }
    
    /*添加跟控制器**/
    private func addChildViewController(childController:UIViewController,title:String,image:String,selectedImage:String) {
        childController.title = title;
        childController.tabBarItem.image = UIImage(named: image)!.withRenderingMode(.alwaysOriginal);
        childController.tabBarItem.selectedImage = UIImage(named: selectedImage)!.withRenderingMode(.alwaysOriginal);
        let baseNav = BaseNavController(rootViewController: childController);
        self.addChild(baseNav);
    }
    
    /*调整item的文字颜色和字体大小**/
    private func changeItemTextColourAndFont() {
        if #available(iOS 13.0, *){
            self.tabBar.tintColor = KHexColor(color: "313235");
            self.tabBar.unselectedItemTintColor = KHexColor(color: "CCD0D3");
            let item = UITabBarItem.appearance();
            item.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.init(name: "PingFangSC-Regular", size: 10) as Any], for: .normal);
            item.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.init(name: "PingFangSC-Regular", size: 10) as Any], for: .selected);
        }else{
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.init(name: "PingFangSC-Regular", size: 10) as Any], for: .normal);
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.init(name: "PingFangSC-Regular", size: 10) as Any], for: .selected);
        }
    }
    
    private func removeTabBarTopLine(){
        //移除顶部线条
        self.tabBar.backgroundImage = UIImage.kImageWithColor(KHexColor(color: "ffffff"));
        self.tabBar.shadowImage = UIImage();
        
        //添加阴影
        self.tabBar.layer.shadowColor = KHexColor(color: "ADB5BA",alpha: 0.22).cgColor;
        self.tabBar.layer.shadowOffset = CGSize.init(width: 0, height: -3);
        self.tabBar.layer.shadowOpacity = 0.3;
    }
}
