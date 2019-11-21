//
//  NetWorkManager.swift
//  SwiftDemo
//
//  Created by john on 2019/11/9.
//  Copyright © 2019 qt. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import HandyJSON
/// 超时时长
private var requestTimeOut:Double = 30
///成功数据的回调
typealias successCallback = ((Any) -> (Void))
///失败的回调
typealias failedCallback = ((Any) -> (Void))
///网络错误的回调
typealias errorCallback = (() -> (Void))

///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: NetRequstApi) -> Endpoint in
    
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
    //    let additionalParameters = ["token":"888888"]
    //    let defaultEncoding = URLEncoding.default
    //    switch target.task {
    //        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    //    case .requestPlain:
    //        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    //    case .requestParameters(var parameters, let encoding):
    //        additionalParameters.forEach { parameters[$0.key] = $0.value }
    //        task = .requestParameters(parameters: parameters, encoding: encoding)
    //    default:
    //        break
    //    }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */
    
    
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30//每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    switch target {
//    case .easyRequset:
//        return endpoint
//    case .register:
//        requestTimeOut = 5
//        return endpoint
        
    default:
        return endpoint
    }
}

///网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
//}


/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
///但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
    case .began:
        print("开始请求网络")
        
    case .ended:
        print("结束")
    }
}

////网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider<NetRequstApi>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)



/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func NetWorkRequest(_ target: NetRequstApi, completion: @escaping successCallback ,hud:Bool=true){
    NetWorkRequest(target, hud: hud, completion: completion, failed: nil, errorResult: nil) 
}


/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failed: 请求失败的回调
func NetWorkRequest(_ target: NetRequstApi, completion: @escaping successCallback , failed:failedCallback?,hud:Bool=true) {
    NetWorkRequest(target, hud: hud, completion: completion, failed: failed, errorResult: nil)
}


///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
func NetWorkRequest(_ target: NetRequstApi,hud:Bool=true, completion: @escaping successCallback , failed:failedCallback?, errorResult:errorCallback?) {
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        AlertUtil.showTempInfo(info: "网络似乎出现了问题")
        return
    }
    if hud {
        MBProgressHUD.an_showActivity()
    }
    //这里显示loading图
    Provider.request(target) { (result) in
        //隐藏hud
        switch result {
        case let .success(response):
            MBProgressHUD.an_dismiss()
            do {
                let jsonData = dataToDictionary(data: response.data)!;
                print(jsonData)
                print("message:"+"\(jsonData[RESULT_MESSAGE] ?? "")")
                
                if let code = jsonData[RESULT_CODE] as? Int{
                    let codeString = String(code);
                    if(codeString == "200"){
                        completion(jsonData["data"] as Any)
                    }
                }else if(failed != nil) {
                    failed!(response.data);
                }
            
            }
        case let .failure(error):
            MBProgressHUD.an_dismiss()
            guard (error as? CustomStringConvertible) != nil else {
                //网络连接失败，提示用户
                AlertUtil.showTempInfo(info: "网络连接失败")
                break
            }
            if errorResult != nil {
                errorResult!()
            }
        }
    }
    
    
}

/***利用自带的方法data转DIC*/
func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dic = json as? NSDictionary
        return (dic as? Dictionary<String, Any>)
    } catch _ {
        AlertUtil.showTempInfo(info: "请求失败")
        return [:];
    }
}

/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}
