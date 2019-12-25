//
//  Router.swift
//  NetworkTool
//
//  Created by OrderPlus on 2018/7/17.
//  Copyright © 2018年 zhaofengYue. All rights reserved.
//

import UIKit
import Alamofire

enum Router: String, URLConvertible {
    
    case getuserinfo = "getuserinfo"
    
    /// 实现协议方法
    func asURL() throws -> URL {
        return URL(string: urlString())!
    }
    
    /// 主机地址
    static var baseUrl: String  = "http://121.196.206.172:8510/api/v1/"
    
    /// 请求方法
    static var httpMethod: HTTPMethod = .post
    
    /// 接口拼接
    ///
    /// - Returns: 返回拼接好的接口地址字符
    private func urlString() -> String {
        return Router.baseUrl.appending(rawValue)
    }
}
