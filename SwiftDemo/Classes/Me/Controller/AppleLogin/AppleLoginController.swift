//
//  AppleLoginController.swift
//  SwiftDemo
//
//  Created by john on 2020/2/13.
//  Copyright © 2020 qt. All rights reserved.
//

import UIKit

class AppleLoginController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btnLogin = UIButton(type: .custom)
        btnLogin.setTitle("Apple登录", for: .normal)
        btnLogin.setTitleColor(.red, for: .normal)
        btnLogin.addTarget(self, action: #selector(didCustomBtnClicked), for: .touchUpInside)
        view.addSubview(btnLogin)
        btnLogin.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
    }
    
    @objc func didCustomBtnClicked() {
        SignInApple.sharedInstance.handleAuthorizationAppleIDButtonPress { (token, code) in
            
        }
    }
}
