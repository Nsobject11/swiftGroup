//
//  SwitchController.swift
//  SwiftDemo
//
//  Created by john on 2019/12/24.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class SwitchController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let CusSwitch = CustomSwitch.init(frame: CGRect(x: 55, y: kTopHeight+20, width: 40, height: 20))
        CusSwitch.onBackLabel.textColor = UIColor.white
        CusSwitch.setTintColor(color: KHexColor(color: "E8EAED"))
        CusSwitch.setOnTintColor(color: KHexColor(color: "FEA376"))
        CusSwitch.setThumbTintColor(color: UIColor.white)
        CusSwitch.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        view.addSubview(CusSwitch)
        
        let CusSwitch1 = CustomSwitch.init(frame: CGRect(x: 55, y: kTopHeight+60, width: 40, height: 20))
        CusSwitch1.onBackLabel.textColor = UIColor.white
        CusSwitch1.onBackLabel.text = "开"
        CusSwitch1.offBackLabel.text = "关"
        CusSwitch1.setTintColor(color: KHexColor(color: "E8EAED"))
        CusSwitch1.setOnTintColor(color: KHexColor(color: "FEA376"))
        CusSwitch1.setThumbTintColor(color: UIColor.white)
        CusSwitch1.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        view.addSubview(CusSwitch1)
    }
    
    @objc func switchPressed(sender:CustomSwitch){
        AlertUtil.showTempInfo(info: "\(sender.on)")
    }
}
