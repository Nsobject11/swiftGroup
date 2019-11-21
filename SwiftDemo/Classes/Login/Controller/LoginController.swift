//
//  LoginController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/15.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class LoginController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserManager.sharedInstance.userLoginWithPhone(phone: "123", psw: "123", flag: false) { (flag) in
            
        }
    }

}
