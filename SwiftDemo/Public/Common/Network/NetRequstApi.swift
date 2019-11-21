//
//  YShareApI.swift
//
//
//  Created by bruce yao on 2019/4/10.
//  Copyright © 2019 bruce yao. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import Result
import RxSwift
import HandyJSON
//初始rovider
let NetApiProvider = MoyaProvider<NetRequstApi>(plugins: [RequestLoadingPlugin()])

//请求分类
enum NetRequstApi {
    case login(account: String, password : String)
    case shareNavList(pageNum : Int , pageSize : Int)
    case uploadHeadImage(parameters: [String:Any],imageDate:Data)
    case getuserinfo
}

//请求配置
extension NetRequstApi: TargetType {
    
    //服务器地址
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: Moya_baseURL)!
        }
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .shareNavList:
            return "manage/navigation/getNavigationList"
        case .login:
            return "/login"
        case .uploadHeadImage( _):
            return "/file/user/upload.jhtml"
        case .getuserinfo:
            return "/getuserinfo"
        }
        
    }
    
    //请求类型
    public var method: Moya.Method {
        switch self {
        case .shareNavList:
            return .get
        case .getuserinfo:
            return .get
        default:
            return .post
        }
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .shareNavList(let pageNum, let pageSize):
            var params: [String: Any] = [:]
            params["pageSize"] = pageSize
            params["pageNum"] = pageNum
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .login(let account, let password):
            return .requestData(jsonToData(jsonDic: ["phone":account  ,"password":password])!) //参数放在HttpBody中
        case .getuserinfo:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        //图片上传
        case .uploadHeadImage(let parameters, let imageDate):
            ///name 和fileName 看后台怎么说，   mineType根据文件类型上百度查对应的mineType
            let formData = MultipartFormData(provider: .data(imageDate), name: "file",
                                             fileName: "hangge.png", mimeType: "image/png")
            return .uploadCompositeMultipart([formData], urlParameters: parameters)

        }
        
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //    只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json","token":UserManager.userInfo().token!]
        }
    }
    
    //字典转Data
    private func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        //Data转换成String打印输出
        let str = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        print("Json Str:\(str!)")
        return data
    }
}

extension ObservableType where Element == Response {
    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(response.mapModel(T.self))
        }
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        return JSONDeserializer<T>.deserializeFrom(json: jsonString)!
    }
}
