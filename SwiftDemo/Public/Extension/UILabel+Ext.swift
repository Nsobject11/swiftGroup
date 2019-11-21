//
//  UILabel+Ext.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

extension UILabel{
    /**创建UILabel**/
    func creatLab(title:String,fontSize:CGFloat,textColor:UIColor,frame:CGRect) -> UILabel {
        let lab = UILabel.init(frame: frame)
        lab.textColor = textColor
        lab.font = UIFont.systemFont(ofSize: fontSize)
        lab.text = title
        return lab
    }
    
    /**
     设置文本,并指定行间距
     
     @param text 文本内容
     @param lineSpacing 行间距
     */
    func setText(text:String,lineSpacing:CGFloat) {
        if(text.count<=0 || lineSpacing<0.01){
            self.text = text;
            return
        }
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString:NSMutableAttributedString = NSMutableAttributedString.init(string: text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        self.attributedText = attributedString
    }
}
