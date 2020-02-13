//
//  RuleController.swift
//  SwiftDemo
//
//  Created by john on 2020/1/6.
//  Copyright © 2020 qt. All rights reserved.
//

import UIKit

class RuleController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(numberTopRulerView)
        
    }
    
//    lazy var numberTopRulerView:RulerView = {
//        let numberTopRulerView = RulerView.init(frame: CGRect(x: 0, y: kTopHeight+100, width: kScreenWidth, height: 65))
//        numberTopRulerView.backgroundColor = UIColor.red;
//        numberTopRulerView.tag = 0
//        numberTopRulerView.delegate = self
//
//        let config:RulerConfig = RulerConfig()
//        //刻度高度
//        config.shortScaleLength = 7;
//        config.longScaleLength = 11;
//        //刻度宽度
//        config.scaleWidth = 2;
//        //刻度起始位置
//        config.shortScaleStart = 58;
//        config.longScaleStart = 54;
//        //刻度颜色
//        config.scaleColor = UIColor.blue;
//        //刻度之间的距离
//        config.distanceBetweenScale = 4;
//        //刻度距离数字的距离
//        config.distanceFromScaleToNumber = 13;
//        //指示视图属性设置
//        config.pointSize = CGSize(width: 2, height: 20)
//        config.pointColor = UIColor.cyan;
//        config.pointStart = 45;
//        //文字属性
//        config.numberFont = UIFont.systemFont(ofSize: 11);
//        config.numberColor = UIColor.cyan;
//        //数字所在位置方向
//        config.numberDirection = .numberBottom;
//
//        //取值范围
//        config.max = 200;
//        config.min = 0;
//        //默认值
//        config.defaultNumber = 57;
//        //使用小数类型
//        config.isDecimal = false
//        //选中
//        config.selectionEnable = false
//        //使用渐变背景
//        config.useGradient = false
//        config.infiniteLoop = true
//        numberTopRulerView.rulerConfig = config;
//        return numberTopRulerView
//    }()
}

//extension RuleController:RulerViewDelegate{
//    func rulerSelectValue(value: Double, tag: NSInteger) {
//        if (tag == 1) {
//
//        } else if (tag == 3) {
//
//        }
//        print("value：\(value)")
//    }
//}
