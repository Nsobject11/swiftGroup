//
//  BannerController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/19.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class BannerController: BaseViewController {
    let arrIMG:[String] = [
        "http://img.tupianzj.com/uploads/allimg/180808/23-1PPQ20220-50.jpg",
        "http://pic1.win4000.com/wallpaper/5/58a7f269a6de0.jpg",
        "http://pic1.win4000.com/wallpaper/8/589c2f0f014ba.jpg",
        "http://pic1.win4000.com/wallpaper/a/55349fb752abc.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        banner.bannerPicArray = arrIMG
    }
    
    func setUI() {
        view.addSubview(banner)
    }
    
    lazy var banner:BannerView = {
        let banner:BannerView = BannerView.init(frame: CGRect(x: 0, y: kTopHeight, width: kScreenWidth, height: 200),cType: .BannerViewControlTypeNum)
        banner.backgroundColor = kRandomColor
        return banner
    }()
}
