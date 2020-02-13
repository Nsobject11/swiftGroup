//
//  ProfileController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
class ProfileController: BaseViewController {

    @IBOutlet weak var tab_B: CustomTab!
    var arrData:[String] = ["图片加载","弹窗","轮播图","图片选择","自定义swiftch","侧滑列表","自定义尺子","3D模型简单演示", "Apple登录"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = kRandomColor;
        self.tab_B.isShowNoData = true 
        self.tab_B.UpRefreshBlock {
            self.tab_B.mj_footer.beginRefreshing()
            _ = delay(2, task: {
                self.tab_B.mj_footer.endRefreshing()
            })
        }
        self.tab_B.DownRefreshBlock {
            self.tab_B.mj_header.beginRefreshing()
            _ = delay(2, task: {
                self.tab_B.mj_header.endRefreshing()
            })
        };
    }

    @IBAction func btnNext(_ sender: UIButton) {
        let other = OtherViewController();
        self.navigationController?.pushViewController(other, animated: true);
    }
}

extension ProfileController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = arrData[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==0 {
            let pic = PicController()
            navigationController?.pushViewController(pic, animated: true)
        }else if(indexPath.row==1){
            let pic = TanAlertController()
            pic.title = "弹窗"
            navigationController?.pushViewController(pic, animated: true)
        }else if(indexPath.row==2){
            let bannerC = BannerController()
            bannerC.title = "轮播o图"
            navigationController?.pushViewController(bannerC, animated: true)
        }else if(indexPath.row == 3){
            let pic = PicSelectController()
            pic.title = "选择图片"
            navigationController?.pushViewController(pic, animated: true)
        }else if(indexPath.row == 4){
            let swi = SwitchController()
            swi.title = "自定义Switch"
            navigationController?.pushViewController(swi, animated: true)
        }else if(indexPath.row == 5){
            let swip = SwipCellVC()
            swip.title = "侧滑列表"
            navigationController?.pushViewController(swip, animated: true)
        }else if(indexPath.row == 6){
            let rule = RuleController()
            rule.title = "自定义尺子刻度"
            navigationController?.pushViewController(rule, animated: true)
        }else if(indexPath.row == 7) {
            let rule = DModelController()
            rule.title = "3D模型加载与演示"
            navigationController?.pushViewController(rule, animated: true)
        }else if(indexPath.row == 8){
            let login = AppleLoginController()
            login.title =  "苹果登录"
            navigationController?.pushViewController(login, animated: true)
        }
    }
}
