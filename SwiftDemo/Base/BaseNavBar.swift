//
//  BaseNavBar.swift
//  SwiftDemo
//
//  Created by yq on 2020/12/3.
//  Copyright © 2020 qt. All rights reserved.
//

import UIKit

class BaseNavBar: UIView {
    ///导航栏标题
    var titleLabel:UILabel?
    ///导航栏背景图片
    var imgNav:UIImageView?
    
    ///关闭按钮
    var closeBtn:UIButton?
    
    weak var barDelegate : BaseBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = KHexColor(color: "#FFFFFF")
        setUIViews()
    }
    
    private func setUIViews(){
        
    }
    
    ///返回按钮
    lazy var leftButton:UIButton = {
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: kScreenHeight - 10, width: kScreenWidth, height: kScreenHeight)
        return leftButton
    }()
    
    ///导航栏44
    lazy var navBarView:UIView = {
        let navBarView = UIView()
        navBarView.frame = CGRect(x: 0, y: kScreenWidth, width: 100, height: kNavBarHeight)
        navBarView.backgroundColor = .clear
        return navBarView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**BaseBarDelegate**/
@objc protocol BaseBarDelegate : NSObjectProtocol {
    ///左边按钮点击 默认是返回
    @objc optional func leftBtnClick(button:UIButton);
    ///关闭按钮点击
    @objc optional func closeBtnClick(button:UIButton);

}
