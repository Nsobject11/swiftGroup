//
//  CustomTxt.swift
//  SwiftDemo
//
//  Created by john on 2019/11/14.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
enum LimitedTextFieldType: Int{
    case LimitedTextFieldTypeNomal
    case LimitedTextFieldTypeNumber //数字
    case LimitedTextFieldTypeNumberOrLetter//数字和字母
    case LimitedTextFieldTypeEmail //数字 字母 和 特定字符( '.'  '@')
    case LimitedTextFieldTypePassword //数字 字母 下划线
}
let kLetterNum:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
let kEmail:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@"
let kPassword:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

class CustomTxt: UITextField {
    weak var limitDelegate : LimitedTextFieldDelegate?
    var limitedType:LimitedTextFieldType = .LimitedTextFieldTypeNomal{
        didSet{
            if limitedType ==  .LimitedTextFieldTypeNomal{
                self.keyboardType = .default
                self.filter = ""
            }else{
                if(limitedType == .LimitedTextFieldTypeNumber){ //数字
                    self.keyboardType = .numberPad;
                    self.filter = "";
                }else if(limitedType == .LimitedTextFieldTypeNumberOrLetter){ //数字和字母
                    self.filter = kLetterNum
                }else if(limitedType == .LimitedTextFieldTypeEmail){ //email
                    self.filter = kEmail
                }else if(limitedType == .LimitedTextFieldTypePassword){ //密码 数字 字母 下划线组成
                    self.filter = kPassword
                }
            }
        }
    }
    var maxLength:Int = 200
    var leftPadding:CGFloat = 0{
        didSet{
            self.setValue(leftPadding, forKey: "paddingLeft");
        }
    }
    var rightPadding:CGFloat = 0{
        didSet{
            self.setValue(rightPadding, forKey: "paddingRight")
        }
    }
    var filter:String = ""
    var placeholderColor:UIColor?{
        didSet{
            if #available(iOS 13, *) {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor as Any])
            }else{
                self.setValue(placeholderColor, forKey: "_placeholderLabel.textColor")
            }
        }
    }
    var placeholderFont:UIFont?{
        didSet{
            if #available(iOS 13, *) {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.font:placeholderFont as Any])
            }else{
                self.setValue(placeholderFont, forKey: "_placeholderLabel.font")
            }
        }
    }
    var customLeftView:UIView?{
        didSet{
            self.leftView = customLeftView;
            self.leftViewMode = .always;
        }
    }
    var customRightView:UIView?{
        didSet{
            self.rightView = customLeftView;
            self.rightViewMode = .always;
        }
    }
//    let tagStr:String
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    /**修改光标及输入开始位置*/
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: updateInputPosition(bounds: bounds))
    }
    /**修改编辑时光标及输入开始位置*/
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: updateInputPosition(bounds: bounds))
    }
    
    func updateInputPosition(bounds:CGRect) -> CGRect {
        if #available(iOS 11.0, *) {
            //如果是左对齐 则+leftPadding
            //右对齐      则-rightPadding
            //中间对其    则pading设置为0
            var padding:CGFloat = 0
            if(self.textAlignment == .right){
                padding = -rightPadding
            }else if(self.textAlignment == .left){
                padding = leftPadding
            }
            let rect:CGRect = CGRect(x: bounds.origin.x+padding, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            return rect
        }else{
            return bounds
        }
    }
    
    /*初始化**/
    func initialize() {
        self.textAlignment = NSTextAlignment.left
        //设置边框和颜色
        self.layer.borderColor = KHexColor(color: "F3F4F6").cgColor;
        self.textColor =  KHexColor(color: "313235");
        self.font = kSystemFont(size: 13);
        
        //设置代理 这里delegate = self 外面就不可以在使用textField的delegate 否则这个代理将会失效
        self.delegate = self;
        self.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField:UITextField) {
        if ((self.limitDelegate != nil) && (self.limitDelegate?.responds(to: #selector(LimitedTextFieldDelegate.limitedTextFieldDidChange(textField:))))!) {
            self.limitDelegate?.limitedTextFieldDidChange?(textField: self)
        }
    }
}

extension CustomTxt:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if((self.limitDelegate != nil) && (self.limitDelegate?.responds(to: #selector(LimitedTextFieldDelegate.limitedTextFieldShouldReturn(textField:))))!){
            return (self.limitDelegate?.limitedTextFieldShouldReturn?(textField: self))!
        }
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((self.limitDelegate != nil) && (self.limitDelegate?.responds(to: #selector(LimitedTextFieldDelegate.limitedTextFieldDidBeginEditing(textField:))))!) {
            self.limitDelegate?.limitedTextFieldDidBeginEditing?(textField: self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((self.limitDelegate != nil) && (self.limitDelegate?.responds(to: #selector(LimitedTextFieldDelegate.limitedTextFieldDidEndEditing(textField:))))!){
            self.limitDelegate?.limitedTextFieldDidEndEditing?(textField: self)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if ((self.limitDelegate != nil) && (self.limitDelegate?.responds(to: #selector(LimitedTextFieldDelegate.limitedTextFieldShouldBeginEditing(textField:))))!) {
            return (self.limitDelegate?.limitedTextFieldShouldBeginEditing?(textField: self))!
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //超过最大长度 并且不是取消键被点击了
        if(string.count >= self.maxLength && string != "" ){
            return false
        }
        
        if (kValidStr(str: self.filter as AnyObject)) {
            return true
        }
        
        let cs = NSCharacterSet.init(charactersIn: self.filter).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return string == filtered
    }
    
    
}

/**LimitedTextFieldDelegate**/
@objc protocol LimitedTextFieldDelegate : NSObjectProtocol {
    
    /**
     键盘return键点击调用
     
     @param textField LimitedTextField
     */
    @objc optional func limitedTextFieldShouldReturn(textField:UITextField) -> Bool;
    /**
     输入结束调用
     
     @param textField LimitedTextField
     */
    @objc optional func limitedTextFieldDidEndEditing(textField:UITextField);
    /**
     输入开始
     
     @param textField LimitedTextField
     */
    @objc optional func limitedTextFieldDidBeginEditing(textField:CustomTxt);
    /**
     输入内容改变调用(实时变化)
     
     @param textField LimitedTextField
     */
    @objc optional func limitedTextFieldDidChange(textField:UITextField);
    /**
     输入开始启动的时候调用
     
     @param textField LimitedTextField
     @return 是否允许编辑
     */
    @objc optional func limitedTextFieldShouldBeginEditing(textField:UITextField)->Bool;
}
