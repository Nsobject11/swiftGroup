//
//  CustomSwitch.swift
//  SwiftDemo
//
//  Created by john on 2019/12/5.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import QuartzCore
enum CustomWitchType: Int{
    case CustomWitchTypeOval
    case CustomWitchTypeRectangle
    case CustomWitchTypeRectangleNoCorner
}
class CustomSwitch: UIControl {
    var shape:CustomWitchType = .CustomWitchTypeOval
    var shadow:Bool = false
    let kHorizontalAdjustment:CGFloat = 3.0
    let kThumbShadowOpacity:Float = 0.3
    let kSwitchBorderWidth:CGFloat = 1.75
    let kRectShapeCornerRadius:CGFloat = 4.0
    let kThumbShadowRadius:CGFloat = 0.5
    let kAnimateDuration:TimeInterval = 0.3
    var on:Bool = true {
        didSet{
            if on {
                self.onBackgroundView.alpha = 1.0
                self.offBackgroundView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                self.thumbView.center = CGPoint(x: self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: self.thumbView.center.y)
            }else{
                self.onBackgroundView.alpha = 0.0
                self.offBackgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.thumbView.center = CGPoint(x: (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: self.thumbView.center.y)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib() 
    }
    
    private func setupUI(){
        self.backgroundColor = .clear
        self.sendActions(for: .valueChanged)
        self.addSubview(onBackgroundView)
        onBackgroundView.addSubview(onBackLabel)
        self.addSubview(offBackgroundView)
        offBackgroundView.addSubview(offBackLabel)
        self.addSubview(thumbView)
        
        /**添加手势*/
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleSwitchTap(recognizer:)))
        tapGestureRecognizer.delegate = self
        thumbView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapBgGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleBgTap(recognizer:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapBgGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
        panGestureRecognizer.delegate = self
        thumbView.addGestureRecognizer(panGestureRecognizer)
        self.on = true
    }
    
    @objc private func handleSwitchTap(recognizer:UIPanGestureRecognizer){
        if (recognizer.state == .ended)
        {
            if (self.on)
            {
                // Animate move to left
                self.animateToDestination(centerPoint: CGPoint(x: (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: (recognizer.view?.center.y)!), duration: kAnimateDuration, on: false)
            }
            else
            {
                // Animate move to right
                self.animateToDestination(centerPoint: CGPoint(x: self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: (recognizer.view?.center.y)!), duration: kAnimateDuration, on: true)
            }
        }
    }
    
    @objc private func handleBgTap(recognizer:UIPanGestureRecognizer){
        if recognizer.state == .ended {
            if (self.on){
                // Animate move to left
                self.animateToDestination(centerPoint: CGPoint(x: (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: self.thumbView.center.y), duration: kAnimateDuration, on: false)
            }else{
                // Animate move to right
                self.animateToDestination(centerPoint: CGPoint(x: self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: self.thumbView.center.y), duration: kAnimateDuration, on: true)
            }
        }
    }
    
    @objc private func handlePan(recognizer:UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.thumbView)
        let newCenter = CGPoint(x: (recognizer.view?.center.x)! + translation.x, y: (recognizer.view?.center.y)!)
        
        if newCenter.x < ((recognizer.view?.frame.size.width ?? 0)+kHorizontalAdjustment)/2 || newCenter.x > self.onBackgroundView.frame.size.width-((recognizer.view?.frame.size.width)!+kHorizontalAdjustment)/2 {
            if recognizer.state == .began || recognizer.state == .changed{
                let velocity:CGPoint = recognizer.velocity(in: self.thumbView)
                if velocity.x >= 0{
                    // Animate move to right
                    self.animateToDestination(centerPoint: CGPoint(x: self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: (recognizer.view?.center.y)!), duration: kAnimateDuration, on: true)
                }else{
                    // Animate move to left
                    self.animateToDestination(centerPoint: CGPoint(x: (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: self.thumbView.center.y), duration: kAnimateDuration, on: false)
                }
            }
            return
        }
        // Only allow vertical pan
        recognizer.view?.center = CGPoint(x: (recognizer.view?.center.x)!+translation.x, y: (recognizer.view?.center.y)!)
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.thumbView)
        let velocity:CGPoint = recognizer.velocity(in: self.thumbView)
        if recognizer.state == .ended {
            if velocity.x >= 0{
                if ((recognizer.view?.center.x)! < self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2){
                    // Animate move to right
                    self.animateToDestination(centerPoint: CGPoint(x: self.onBackgroundView.frame.size.width - (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: (recognizer.view?.center.y)!), duration: kAnimateDuration, on: true)
                }
            }else{
                // Animate move to left
                self.animateToDestination(centerPoint: CGPoint(x: (self.thumbView.frame.size.width+kHorizontalAdjustment)/2, y: (recognizer.view?.center.y)!), duration: kAnimateDuration, on: false)
            }
        }
    }
    
    private func animateToDestination(centerPoint:CGPoint,duration:TimeInterval,on:Bool){
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.thumbView.center = centerPoint;
            if (on){
                self.onBackgroundView.alpha = 1.0
            }
            else{
                self.onBackgroundView.alpha = 0.0
            }
        }) {(finished) in
            if finished {
                self.updateSwitch(on: on)
            }
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            if (on){
                self.offBackgroundView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
            }
            else{
                self.offBackgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }
        }) {(finished) in
        }
    }
    
    private func updateSwitch(on:Bool){
        if self.on != on {
            self.on = on
        }
        self.sendActions(for: UIControl.Event.valueChanged)
    }
    
    // Background view for ON
    lazy var onBackgroundView:UIView = {
        let onBackgroundView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        onBackgroundView.backgroundColor = UIColor.init(red: 19.0/255.0, green: 121.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        onBackgroundView.layer.cornerRadius = frame.size.height/2
        onBackgroundView.layer.shouldRasterize =  true
        onBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        return onBackgroundView
    }()
    
    //打开时候的文字
    lazy var onBackLabel:UILabel = {
        let onBackLabel = UILabel(frame: CGRect(x: 0, y: 0, width: VW(view: self.onBackgroundView)-VW(view: self.thumbView), height: VH(view: self.onBackgroundView)))
        onBackLabel.textColor = .white
        onBackLabel.font = UIFont.systemFont(ofSize: 12);
        onBackLabel.textAlignment = .center
        return onBackLabel
    }()
    
    // Background view for OFF
    lazy var offBackgroundView:UIView = {
        let offBackgroundView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        offBackgroundView.backgroundColor = .white
        offBackgroundView.layer.cornerRadius = frame.size.height/2
        offBackgroundView.layer.shouldRasterize =  true
        offBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        return offBackgroundView
    }()
    
    //关闭时候的文字
    lazy var offBackLabel:UILabel = {
        let offBackLabel = UILabel(frame: CGRect(x: self.thumbView.frame.size.width, y: 0, width: VW(view: self.onBackgroundView)-VW(view: self.thumbView), height: VH(view: self.onBackgroundView)))
        offBackLabel.textColor = .white
        offBackLabel.font = UIFont.systemFont(ofSize: 12);
        offBackLabel.textAlignment = .center
        return offBackLabel
    }()
    
    // Background view for OFF
    lazy var thumbView:UIView = {
        let thumbView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.height - kHorizontalAdjustment, height: self.frame.size.height-kHorizontalAdjustment))
        thumbView.isUserInteractionEnabled = true
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = (self.frame.size.height - kHorizontalAdjustment)/2
        thumbView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thumbView.layer.shadowOpacity = kThumbShadowOpacity
        thumbView.layer.shouldRasterize =  true
        thumbView.layer.rasterizationScale = UIScreen.main.scale
        thumbView.center = CGPoint(x: thumbView.frame.size.width/2, y: frame.size.height/2)
        return thumbView
    }()
    
    private func VW(view:UIView) -> CGFloat {
        return view.frame.size.width
    }
    
    private func VH(view:UIView) -> CGFloat {
        return view.frame.size.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomSwitch{
    /* The color used to tint the appearance of the switch when it is turned on. */
    func setOnTintColor(color:UIColor) {
        self.onBackgroundView.backgroundColor = color
    }
    
    /* The border color used to tint the appearance when the switch is disabled. */
    func setOnTintBorderColor(color:UIColor?) {
        self.onBackgroundView.layer.borderColor = color?.cgColor
        if color != nil {
            self.onBackgroundView.layer.borderWidth = kSwitchBorderWidth
        }else{
            self.onBackgroundView.layer.borderWidth = 0.0
        }
    }
    
    /* The color used to tint the appearance when the switch is disabled. */
    func setTintColor(color:UIColor) {
        self.offBackgroundView.backgroundColor = color
    }
    
    /* The border color used to tint the appearance when the switch is disabled. */
    func setTintBorderColor(color:UIColor?) {
        self.offBackgroundView.layer.borderColor = color?.cgColor
        if color != nil {
            self.offBackgroundView.layer.borderWidth = kSwitchBorderWidth
        }else{
            self.offBackgroundView.layer.borderWidth = 0.0
        }
    }
    
    /* The color used to tint the appearance of the thumb. */
    func setThumbTintColor(color:UIColor) {
        self.thumbView.backgroundColor = color
    }
    
    /* A value that determines the shape of the switch control */
    func setShape(newShape:CustomWitchType) {
        if newShape ==  .CustomWitchTypeOval{
            self.onBackgroundView.layer.cornerRadius = self.frame.size.height/2
            self.offBackgroundView.layer.cornerRadius = self.frame.size.height/2
            self.thumbView.layer.cornerRadius = (self.frame.size.height - kHorizontalAdjustment)/2
        }else if(newShape ==  .CustomWitchTypeRectangle){
            self.onBackgroundView.layer.cornerRadius = kRectShapeCornerRadius
            self.offBackgroundView.layer.cornerRadius = kRectShapeCornerRadius
            self.thumbView.layer.cornerRadius = kRectShapeCornerRadius
        }else if(newShape ==  .CustomWitchTypeRectangleNoCorner){
            self.onBackgroundView.layer.cornerRadius = 0
            self.offBackgroundView.layer.cornerRadius = 0
            self.thumbView.layer.cornerRadius = 0
        }
    }
    
    /* Thumb drop shadow on/off */
    func setShadow(showShadow:Bool) {
        if showShadow {
            self.thumbView.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.thumbView.layer.shadowRadius = kThumbShadowRadius
            self.thumbView.layer.shadowOpacity = kThumbShadowOpacity
        }else{
            self.thumbView.layer.shadowRadius = 0.0
            self.thumbView.layer.shadowOpacity = 0.0
        }
    }
}


extension CustomSwitch:UIGestureRecognizerDelegate{
    
}
