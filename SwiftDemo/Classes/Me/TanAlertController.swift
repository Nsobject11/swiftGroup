//
//  TanAlertController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class TanAlertController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    var refineView:RefineAlertView?
    
    func setUI() {
        let arr:[String] = ["上到下","下到上","右到左","左到右","上到下弹性"]
        for index in 0...arr.count-1 {
            let btn = UIButton.kCreatBtn(target: self, action: #selector(btnClick(btn:)), image: "", title: arr[index], rect: CGRect(x: 15 , y: (Int(kTopHeight + 15 + CGFloat(index*54))), width: Int(kScreenWidth-30), height: 44))
            btn.tag = index + 1
            btn.setTitleColor(kRandomColor, for: .normal)
            KViewRadiusShadow(view: btn, Radius: 5)
            self.view.addSubview(btn)
        }
    }
    
    @objc func btnClick(btn:UIButton){
        print(btn.tag)
        var style:RefineAlertViewStyle?
        var viewSub:UIView?
        var top:CGFloat = 0
        
        switch btn.tag {
        case 1:
            viewSub  = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
            style = .RefineAlertViewStyleTop
            top = kTopHeight
            break
        case 2:
            viewSub  = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
            style = .RefineAlertViewStyleDown
            break
        case 3:
            viewSub  = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth-100, height: kScreenHeight))
            style = .RefineAlertViewStyleRight
            break
        case 4:
            viewSub  = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth-100, height: kScreenHeight))
            style = .RefineAlertViewStyleLeft
            break
        case 5:
            viewSub  = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
            style = .RefineAlertViewStyleSpring
            break
        default:
            break
        }
        viewSub!.backgroundColor = kRandomColor
        let reView = RefineAlertView.init(frame: CGRect(x: 0, y: top, width: kScreenWidth, height: kScreenHeight-top), viewB: viewSub!, style: style!)
        reView.alertSelectViewshow()
        refineView = reView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if refineView != nil {
            refineView!.tapClose()
        }
    }
    
}
