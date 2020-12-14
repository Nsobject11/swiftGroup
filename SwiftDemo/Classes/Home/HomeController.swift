//
//  HomeController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
class HomeController: BaseViewController {

    @IBOutlet weak var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kRandomColor;
        view.addSubview(searchBar);
        
        let txt = CustomTxt.init(frame: CGRect(x: 0, y: 118, width: kScreenWidth, height: 44))
        txt.backgroundColor = KWitheColor
        txt.placeholder = "请输入手机号"
        txt.maxLength = 11
        txt.limitedType = .LimitedTextFieldTypeEmail
        txt.textAlignment = .left
        txt.limitDelegate = self
        self.view.addSubview(txt)

        let x = CustomTextView.init(frame: CGRect(x: 15, y: 172, width: kScreenWidth-30, height: 100))
        x.SetPlaceholder("请输入...")
        x.SetMaxLength(100)
        self.view.addSubview(x)


        let arr = ["1","2","2"]
        for (index,value) in arr.enumerated() {
            print("哈哈:" + String(index) + String(value))
        }
        
        payView.payBlock { (flag) in
            print(flag)
        }
    }
    @IBAction func btnC(_ sender: UIButton) {
        
        payView.ThridBlock!(sender.tag)
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
//        AlertUtil.showTempInfo(info: "哈哈");
        
//        MBProgressHUD.an_showActivity()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//             MBProgressHUD.an_dismiss()
//        }
        
//        let arr:[String]? = nil
//        print("ARR" + String(kValidArray(f: arr as AnyObject)))
//
//        let str = "123"
//        print("str" + String(kValidStr(str: str)))
//
//        let dic = ["name":"123"]
//        print("dic" + String(kValidDict(f: dic as AnyObject)))
        
        UserManager.sharedInstance.userLoginWithPhone(phone: "123", psw: "123", flag: false) { (flag) in

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        NetWorkRequest(.login(account: "13162338295", password: "abc123"), completion: { (responseString) -> (Void) in
//            if let object = UserModel.deserialize(from: responseString){
//                print("Data:" + (object.data)!);
//            }
//        }, hud: false)
    }
    
    lazy var searchBar:RefineSearchBar = {
        let searchBar = RefineSearchBar(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: 44));
        searchBar.delegate = self
        searchBar.placeholder = "测试placeholder"
        searchBar.backgroundColor = KWitheColor;
        return searchBar;
    }()
}
 

extension HomeController:RefineSearchBarDelegate{
    func reSearchBarShouldBeginEditing(searchBar: RefineSearchBar) -> Bool {
        return true;
    }
    
    func reSearchBarTextDidBeginEditing(searchBar: RefineSearchBar) {
        print("did:" + searchBar.text! );
    }
    
    func reSearchBarShouldEndEditing(searchBar: RefineSearchBar) -> Bool {
        return true;
    }
    
    func reSearchBarTextDidEndEditing(searchBar: RefineSearchBar) {
        print("DidEnd:" + searchBar.text!);
    }
    
    func searchBarTextClear(searchBar: RefineSearchBar) {
        print("Clear:" + searchBar.text!);
    }
    
    func searchBar(searchBar: RefineSearchBar, searchText: String) {
        print("Bar:" + searchBar.text!);
    }
    
    func searchBar(searchBar: RefineSearchBar, range: NSRange, searchText: String) -> Bool {
        return true;
    }
    
    func searchBarSearchButtonClicked(searchBar: RefineSearchBar, searchText: String) {
        print("SearchButtonClicked:" + searchBar.text!);
    } 
}

extension HomeController:LimitedTextFieldDelegate{
    func limitedTextFieldDidChange(textField: UITextField) {
        print("XXXX:" + textField.text!)
    }
}
