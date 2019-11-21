//
//  BadgeButton.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {
    
    var badgeLabel:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInitialize()
    }
    /**初始化角标*/
    func customInitialize() {
        self.clipsToBounds = false
        //------- 角标label -------//
        badgeLabel = UILabel()
        addSubview(badgeLabel!)
        badgeLabel!.backgroundColor = KHexColor(color: "FE5E10")
        badgeLabel!.font = UIFont.systemFont(ofSize: 6)
        badgeLabel!.textColor = .white
        badgeLabel!.layer.cornerRadius = 5
        badgeLabel!.clipsToBounds = true;
        badgeLabel!.textAlignment  = .center
        // 默认隐藏
        self.badgeLabel!.isHidden = true;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refresh()
    }
    
    func refresh() {
        self.layoutIfNeeded()
        if kValidStr(str: titleLabel?.text as AnyObject) {
            badgeLabel?.frame = CGRect(x: titleLabel!.frame.maxX-8, y: (titleLabel?.frame.origin.y)!, width: 16, height: 10)
        }else{
            badgeLabel?.frame = CGRect(x: imageView!.frame.maxX-8, y: (imageView?.frame.origin.y)!, width: 16, height: 10)
        }
    }
    /*显示角标默认隐藏**/
    func showBadgeWithNumber(badgeNumber:Int) {
        if badgeNumber == 0 {
            return;
        }
        badgeLabel?.isHidden = false;
        // 注意数字前后各留一个空格，不然太紧凑
        if (badgeNumber>99) {
            badgeLabel?.text = " 99+ "
        }else{
            badgeLabel?.text = String(" " + String(badgeNumber) +  " ")
        }
        // 赋值后调整UI
        refresh()
    }
    
    /*隐藏角标**/
    func hideBadge()  {
        badgeLabel?.isHidden = true
    }
}
