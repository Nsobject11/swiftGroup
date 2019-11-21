//
//  UIColor+Extension.swift
//  SwiftDemo
//
//  Created by john on 2019/11/7.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

extension UIColor{
    public static var theme: UIColor {
        return UIColor(hex: "#2CB65A")
    }
    
    public static var dark: UIColor {
        return UIColor(hex: "#323232")
    }
    
    public static var placeholder: UIColor {
        return UIColor(hex: "#969696")
    }
    
    public static var grayColor: UIColor {
        return UIColor(hex: "#666666")
    }
    
    public static var line: UIColor {
        return UIColor(hex: "#DDDDDD")
    }
    
    /// 随机色
    public class var kRandomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// rbg颜色
    ///
    /// - Parameters:
    ///   - r: 一个大于1的数 [0,255.0]
    ///   - g: 一个大于1的数 [0,255.0]
    ///   - b: 一个大于1的数 [0,255.0]
    ///   - alpha: 透明度 0.0~1.0
    /// - Returns: 新颜色
    public class func kColorWith(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 16进制颜色转为RGB颜色
    ///
    /// - Parameters:
    ///   - hexInt: 0x333333
    ///   - alpha: 透明度 默认 1.0
    /// - Returns: 颜色
    public class func kColorWith(hexInt: Int, alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hexInt & 0xFF0000) >> 16)
        let g = CGFloat((hexInt & 0x00FF00) >> 8)
        let b = CGFloat((hexInt & 0x0000FF))
        
        return UIColor.kColorWith(r: r, g: g, b: b, alpha: alpha)
    }
}


public extension UIColor {
    
    convenience init(hex string: String,alpha:CGFloat=1.0) {
        var hex = string.hasPrefix("#") ? String(string.dropFirst()) : string
        guard hex.count == 3 || hex.count == 6 else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(red: CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
                  green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
                  blue: CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: alpha)
    }
    
    func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }
}
