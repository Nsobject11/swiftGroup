//
//  PicSelectController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/20.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class PicSelectController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photoS)
    }
    
    
    lazy var photoS:PhotoSelect = {
       let photoS = PhotoSelect.init(frame: CGRect(x: 10, y: kTopHeight+10, width: kScreenWidth-20, height: 90), controll: self)
        photoS.delegate = self
        photoS.allowTakeVideo = true
        photoS.showTakeVideoBtnSwitch = true
        return photoS
    }()
}

extension PicSelectController:PhotoSelectDelegate{
    func selectImageArr(imageArr: NSArray) {
        print(imageArr)
    }
    
    func selectVideo(VideoUrl: String) {
        print("视频地址：" + VideoUrl)
    }
}
