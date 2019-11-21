//
//  payModel.swift
//  SwiftDemo
//
//  Created by john on 2019/11/21.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class PayModel: NSObject {
    
    var appid:String?
    var noncestr:String?
    var package:String?
    var partnerid:String?
    var prepayid:String?
    var sign:String?
    var timestamp:String?
    
    /**支付宝*/
    var alipayStr:String?
}
