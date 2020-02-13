//
//  RefineSearchBar.swift
//  SwiftDemo
//
//  Created by john on 2019/11/11.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class RefineSearchBar: UIView {
    var text:String?{
        set{
            self.textField.text = newValue ?? ""
        }
        get{
            return self.textField.text
        }
    }
    var placeholder:String?{
        didSet{
           self.textField.placeholder = placeholder ?? "请输入搜索内容";
        }
    }
    var textColor:UIColor?{
        didSet{
          self.textField.textColor = textColor ?? UIColor.black
        }
    }
    var font:UIFont?{
        didSet{
            self.textField.font = font ?? UIFont.systemFont(ofSize: 12)
        }
    }
    var BGColor:UIColor?{
        didSet{
            self.textField.backgroundColor = BGColor ?? UIColor.white
        }
    }
    var cornerS:Int?{
        didSet{
            self.textField.layer.cornerRadius = CGFloat(cornerS ?? 0)
            self.textField.layer.masksToBounds = true;
        }
    }
    var placeholderColor:UIColor?{
        didSet{
            self.textField.attributedText = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor as Any])
        }
    }
    weak var delegate : RefineSearchBarDelegate?
    static  let RefineSearchBarMargin:CGFloat = 5;

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI();
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI();
    }
    
    
    func setUI() {
        self.addSubview(self.textField);
        self.addSubview(self.imageIcon);
        self.backgroundColor = UIColor.kColorWith(r: 201, g: 201, b: 206);
        
    }
    
    /**文本改变**/
    @objc func textFieldDidChange(textField:UITextField) {
        if((self.delegate != nil) && ((self.delegate?.responds(to:#selector(RefineSearchBarDelegate.searchBar(searchBar:searchText:))))!)){
            self.delegate?.searchBar!(searchBar: self, searchText: textField.text!);
        }
    }
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    private lazy var textField:UITextField = {
        
        let textField = UITextField(frame: CGRect(x: 25, y: 0, width: k_width-25, height: k_height));
        textField.delegate = self;
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.borderStyle = UITextField.BorderStyle.none;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center;
        textField.returnKeyType = UIReturnKeyType.search;
        textField.enablesReturnKeyAutomatically = true;
        textField.font = UIFont.systemFont(ofSize: 13);
        textField.addTarget(self, action: #selector(RefineSearchBar.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged);
        textField.placeholder = "请输入搜索内容";
        textField.autoresizingMask = UIView.AutoresizingMask.flexibleWidth;
        textField.backgroundColor = UIColor.clear;
        return textField
    }()
    
    private lazy var imageIcon:UIImageView = {
        let imageIcon = UIImageView(image: UIImage(named: "pinpai_tubiao_sousuo_da"));
        imageIcon.frame = CGRect(x: RefineSearchBar.RefineSearchBarMargin, y: (k_height-15)/2, width: 15, height: 15);
        return imageIcon;
    }()
    
}

/**UITextFieldDelegate**/
extension RefineSearchBar:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if((self.delegate != nil) && (self.delegate?.responds(to: #selector(RefineSearchBarDelegate.reSearchBarShouldBeginEditing(searchBar:))))!){
            return (self.delegate?.reSearchBarShouldBeginEditing!(searchBar: self))!;
        }
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if((self.delegate != nil) && (self.delegate?.responds(to: #selector(RefineSearchBarDelegate.reSearchBarTextDidBeginEditing(searchBar:))))!){
            self.delegate?.reSearchBarTextDidBeginEditing!(searchBar: self);
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if((self.delegate != nil) && ((self.delegate?.responds(to:#selector(RefineSearchBarDelegate.reSearchBarShouldEndEditing(searchBar:))))!)){
            return (self.delegate?.reSearchBarShouldEndEditing!(searchBar: self))!;
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((self.delegate != nil) && (self.delegate?.responds(to: #selector(RefineSearchBarDelegate.reSearchBarTextDidEndEditing(searchBar:))))!) {
            self.delegate?.reSearchBarTextDidEndEditing?(searchBar: self);
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //    禁止输入框输入空格
        let item = string.components(separatedBy: NSCharacterSet.whitespaces).joined(separator: "")
        if string != item {
            return false
        }
        if((self.delegate != nil) && (self.delegate?.responds(to: Selector.init(("searchBar::"))))!) {
            return (self.delegate?.searchBar!(searchBar: self, range: range, searchText: string))!
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.textField.text = ""
        self.textField.resignFirstResponder()
        if ((self.delegate != nil) && ((self.delegate?.responds(to:#selector(RefineSearchBarDelegate.searchBarTextClear(searchBar:))))!)) {
            self.delegate?.searchBarTextClear!(searchBar: self)
        }
        return true;
    }
}

/**RefineSearchBarDelegate**/
@objc protocol RefineSearchBarDelegate : NSObjectProtocol {
    
    // return NO to not become first responder
   @objc optional func reSearchBarShouldBeginEditing(searchBar:RefineSearchBar) -> Bool;
    // called when text starts editing
    
   @objc optional func reSearchBarTextDidBeginEditing(searchBar:RefineSearchBar);
    // return NO to not resign first responder
    
   @objc optional func reSearchBarShouldEndEditing(searchBar:RefineSearchBar) -> Bool;
    // called when text ends editing
    
   @objc optional func reSearchBarTextDidEndEditing(searchBar:RefineSearchBar);
    
   @objc optional func searchBarTextClear(searchBar:RefineSearchBar);
    // called when text changes (including clear)
    
   @objc optional func searchBar(searchBar:RefineSearchBar,searchText:String);
    // called before text changes
    
   @objc optional func searchBar(searchBar:RefineSearchBar,range:NSRange,searchText:String)->Bool;
    
    @objc optional func searchBarSearchButtonClicked(searchBar:RefineSearchBar,searchText:String);
}
