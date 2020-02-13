//
//  UserManager.swift
//  SwiftDemo
//
//  Created by john on 2019/11/15.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
let UserinfoFile = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!  + "/userInfo.data"
class UserManager: NSObject {
    static let sharedInstance: UserManager = {
        let instance = UserManager()
        return instance
    }()
    
    /**用户登录*/
    func userLoginWithPhone(phone:String,psw:String,flag:Bool,completion:(_ isLoginSuccess:Bool)->Void) {
        let user = UserInfo()
        user.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI4Njk1ZjU5YS0zNTM1LTQ5MTMtYTUzNS04NTE5MjQ1ZjQzNTciLCJuYmYiOjE1NzM4MDM1MDIsImV4cCI6MTYwNTQyNTkwMiwiaXNzIjoiQWRpbm5ldCIsImF1ZCI6IkFkaW5uZXQifQ.o-fE_zRG91PqvjMNb1A95DLwvz03hoLrCRFBoKTNPwI"
        UserManager.saveUserinfo(userInfo: user)
//        NetWorkRequest(.getuserinfo, completion: { (dic) -> (Void) in
//            let dic:NSDictionary = dic as! NSDictionary
//            if let object = UserInfo.deserialize(from: dic){
//                print("Data:" + object.nick_name!);
//            }
//        }, hud: true)
        UserInfo().fetchSkyData().subscribe(onNext: { [weak self] model in
            
        }, onError: { (error) in
                
        }).disposed(by: DisposeBag())
        
       
    }
    
    /** 取出当前用户信息 */
    class func userInfo()->UserInfo{
        let fileManager:FileManager = FileManager()
        if fileManager.fileExists(atPath: UserinfoFile) {
            return (NSKeyedUnarchiver.unarchiveObject(withFile: UserinfoFile) as! UserInfo)
        }
        return UserInfo()
    }
    
    /** 保存用户信息 */
    class func saveUserinfo(userInfo:UserInfo) {
        NSKeyedArchiver.archiveRootObject(userInfo, toFile: UserinfoFile)
    }
    
    /** 删除用户信息 */
    class func deleteUserinfo(){
        let fileManager:FileManager = FileManager()
        if fileManager.fileExists(atPath: UserinfoFile) {
            do{
                try fileManager.removeItem(atPath: UserinfoFile)
            }catch{}
        }
    }
}

/**model类**/
class UserInfo: NSObject,HandyJSON,NSCoding {
    var ID:String?
    var token:String?
    var phone:String?
    var head_photo:String?
    var nick_name:String?
    var birth_date:String?
    var gender:Int?
    
    required override init() {}
    
    required init(coder aDecoder:NSCoder){
        self.nick_name = aDecoder.decodeObject(forKey: "nick_name") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.token = aDecoder.decodeObject(forKey: "token") as? String
        self.head_photo = aDecoder.decodeObject(forKey: "head_photo") as? String
        self.birth_date = aDecoder.decodeObject(forKey: "birth_date") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? Int
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(nick_name ?? "", forKey: "nick_name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(head_photo, forKey: "head_photo")
        aCoder.encode(birth_date, forKey: "birth_date")
        aCoder.encode(gender, forKey: "gender")
    }
    
    func fetchSkyData() -> Observable<UserInfo> {
        return APIUtil.fetchData(with: .getuserinfo, .get, nil, returnType: UserInfo.self).map({ (response: UserInfo) -> UserInfo in
            return response
        })
    }
}
