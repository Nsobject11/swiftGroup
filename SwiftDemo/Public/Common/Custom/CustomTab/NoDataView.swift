//
//  NoData.swift
//  SwiftDemo
//
//  Created by john on 2019/11/15.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
class NoDataView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(viewBottom)
        viewBottom.addSubview(image)
        viewBottom.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewBottom.snp.makeConstraints { (make) in
            make.height.width.equalTo(150)
            make.center.equalTo(self.snp_center)
        }
        image.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(viewBottom)
            make.height.equalTo(130)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(image.snp_bottom)
            make.left.right.bottom.equalTo(viewBottom)
        }
    }
    
    lazy var viewBottom:UIView = {
        let viewBottom = UIView()
        viewBottom.backgroundColor = UIColor.clear
        return viewBottom
    }()
    
    lazy var image:UIImageView={
        let image = UIImageView()
        image.image = kImage_Named(name: "支付成功");
        return image
    }()
    
    lazy var label:UILabel = {
        let label = UILabel()
        label.text = "暂无数据"
        label.font = kSystemFont(size: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = KHexColor(color: "8B909A")
        return label
    }()

}
