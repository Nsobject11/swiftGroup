//
//  PhotoCell.swift
//  SwiftDemo
//
//  Created by john on 2019/11/19.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var asset:PHAsset = PHAsset() {
        didSet{
            self.videoImageView.isHidden = asset.mediaType !=  .video
            let GIF:String = asset.value(forKey: "filename") as! String
            self.gifLable.isHidden = !GIF.contains("GIF")
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        self.backgroundColor = UIColor.white;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        self.addSubview(imageView)
        self.addSubview(videoImageView)
        self.addSubview(deleteBtn)
        self.addSubview(gifLable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds;
        gifLable.frame = CGRect(x: self.tz_width - 25, y: self.tz_height - 14, width: 25, height: 14)
        deleteBtn.frame = CGRect(x: self.tz_width - 31, y: -5, width: 36, height: 36)
        let width:CGFloat = self.tz_width / 3.0;
        videoImageView.frame = CGRect(x:width, y:width,width: width,height:width);
    }
    
    lazy var imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        imageView.contentMode = UIView.ContentMode.scaleToFill
        return imageView
    }()
    
    lazy var videoImageView:UIImageView = {
        let videoImageView = UIImageView.init(image: UIImage.tz_imageNamed(fromMyBundle: "MMVideoPreviewPlay"))
        videoImageView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        videoImageView.contentMode = UIView.ContentMode.scaleToFill
        videoImageView.isHidden = true
        return videoImageView
    }()
    
    lazy var deleteBtn:UIButton = {
       let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.setImage(UIImage(named: "关闭2"), for: .normal)
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: -10)
        deleteBtn.alpha = 0.6
        return deleteBtn
    }()
    
    lazy var gifLable:UILabel = {
        let gifLable = UILabel.init()
        gifLable.text = "GIF"
        gifLable.textColor = UIColor.white
        gifLable.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        gifLable.textAlignment = NSTextAlignment.center
        gifLable.font = UIFont.systemFont(ofSize: 10)
        return gifLable
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
