//
//  AppDelegate+LifeCycle.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import Foundation
import UIKit
extension AppDelegate{
    
    func setRootController() {
        if (window == nil) {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = UIColor.white
        }
        let vc = BaseTabbarController();
        self.window?.rootViewController = vc;
    }
    
}
