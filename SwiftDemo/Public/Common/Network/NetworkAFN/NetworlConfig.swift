//
//  NetworlConfig.swift
//  SwiftDemo
//
//  Created by john on 2019/12/5.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

/**
 1.状态码
 **/
enum HttpCode : Int {
    case success = 1 //请求成功的状态吗
    case needLogin = -1  // 返回需要登录的错误码
}

/**
 2.为了统一处理错误码和错误信息，在请求回调里会用这个model尝试解析返回值
 **/
struct BaseModel: Decodable {
    var code: Int
    var data: Content
    struct Content: Decodable {
        var message: String
    }
}

//下面的错误码及错误信息用来在HttpRequest中使用
extension BaseModel {
    var generalCode: Int {
        return code
    }

    var generalMessage: String {
        return data.message
    }
}
