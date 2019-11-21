//
//  UIImage+Extension.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import CoreFoundation

extension UIImage{
    public static func kImageWithColor(_ color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let ref = UIGraphicsGetCurrentContext()
        ref?.setFillColor(color.cgColor)
        ref?.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
    public static func thumbnailOfAVAsset(url:NSURL) -> UIImage{
        let avAsset = AVAsset.init(url: url as URL)
        let generator = AVAssetImageGenerator.init(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600) // 取第0秒， 一秒600帧
        var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
        let cgImage: CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        return UIImage.init(cgImage: cgImage)
        
    }
}
