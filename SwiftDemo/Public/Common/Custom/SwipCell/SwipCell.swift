//
//  SwipCell.swift
//  SwiftDemo
//
//  Created by john on 2019/12/25.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
enum SwipeCellActionStyle: Int{
    case SwipeCellActionStyleDefault
    case SwipeCellActionStyleDestructive //// 删除 红底
    case SwipeCellActionStyleNormal // 正常 灰底
}

enum SwipeCellActionAnimationStyle: Int{
    case SwipeCellActionAnimationStyleDefault // 正常 点击就执行
    case SwipeCellActionAnimationStyleAnimation // 动画
        //点击就执行动画，寻求再次确认 : 注意 Destructive|Default 属性默认执行动画
}

//MARK -SwipeCellAction
class SwipeCellAction: NSObject {
    var style:SwipeCellActionStyle?
    var animationStyle:SwipeCellActionAnimationStyle? //是否需要执行确认动画. 默认Default
    var title:String? //文字内容
    var image:UIImage? //按钮图片. 默认无图
    var titleColor:UIColor? //文字颜色. 默认白色
    var backgroundColor:UIColor? // 背景颜色. 默认透明 : 级别优先于 style
    var cornerRadius:CGFloat = 0 /// view圆角
    var margin:CGFloat = 10  // 内容左右间距. 默认10
    var font:UIFont? //字体大小. 默认17
    var confirmTitle:String? //设置需要显示confirm的text和icon
    var confirmIcon:String? //再次确认的图片icon. 默认空
    var handler:((_ action:SwipeCellAction,_ indexPath:IndexPath)->())?
    class func rowActionWithStyle(style: SwipeCellActionStyle, title: String?, handler:@escaping (_ action:SwipeCellAction,_ indexPath:IndexPath)->()) -> SwipeCellAction{
        let action = SwipeCellAction()
        action.title = title
        action.handler = handler
        action.style = style
        return action
    }
}

//MARK: -SwipeActionButton
enum SwipeActionButtonStyle: Int{
    case SwipeActionButtonStyleNormal //正常状态：动画前
    case SwipeActionButtonStyleSelected //选中状态：动画后
}

class SwipeActionButton: UIButton {
    var animationStyle:SwipeCellActionAnimationStyle = .SwipeCellActionAnimationStyleDefault//属性赋值来自[SwipeCellAction class]实例
    var logStyle:SwipeActionButtonStyle = .SwipeActionButtonStyleNormal//记录当前动画状态,仅仅在有动画效果下生效
}

//MARK -SwipCell
enum SwipeCellState: Int{
    case SwipeCellStateNormal
    case SwipeCellStateAnimating
    case SwipeCellStateOpen
}
class SwipCell: UITableViewCell {
    var btnContainView:UIView?//按钮容器
    var SwipDelegate:SwipeCellDelegate?//代理
    var sideslip:Bool = true
    var state:SwipeCellState?{
        didSet{
            if (state == .SwipeCellStateNormal) {
                for cell in self.tableView.visibleCells {
                    if (cell.isKind(of: SwipCell.self)) {
                        let c = cell as! SwipCell
                        c.sideslip = false;
                    }
                }
            } else if (state == .SwipeCellStateAnimating) {
                NSLog("----->>%@", self);
            } else if (state == .SwipeCellStateOpen) {
                for cell in self.tableView.visibleCells {
                    if cell.isKind(of: SwipCell.self) {
                        let c = cell as! SwipCell
                        c.sideslip = true;
                    }
                }
            }
        }
    }
    var _actions:[SwipeCellAction]?
    var _panGesture:UIPanGestureRecognizer?
    var _tableViewPan:UIPanGestureRecognizer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSideslipCell()
    }
    
    override func layoutSubviews() {
        var x:CGFloat = 0
        if (sideslip){
            x = self.contentView.frame.origin.x
        }
        
        super.layoutSubviews()
        var totalWidth:CGFloat = 0
        if btnContainView != nil {
            for btn in btnContainView!.subviews {
                btn.frame = CGRect(x: totalWidth, y: 0, width: btn.frame.size.width, height: self.frame.size.height)
                totalWidth += btn.frame.size.width;
            }
        }
        btnContainView?.frame = CGRect(x: self.frame.size.width - totalWidth, y: 0, width: totalWidth, height: self.frame.size.height)
        // 侧滑状态旋转屏幕时, 保持侧滑
        if (sideslip){setContentViewX(x: x)}
        
        var frame = self.contentView.frame
        frame.size.width = self.bounds.size.width
        self.contentView.frame = frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if (sideslip){hiddenSideslip(animate: false)}
    }
    
    private func setupSideslipCell(){
        _panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(contentViewPan(pan:)))
        _panGesture?.delegate = self;
        self.contentView.addGestureRecognizer(_panGesture!)
        self.contentView.backgroundColor = UIColor.white;
    }
    
    //隐藏侧滑按钮
    func hiddenAllSideslip()  {
         self.tableView.hiddenAllSidesli()
    }
    
    func hiddenSideslip(animate:Bool) {
        if (self.contentView.frame.origin.x == 0){
            self.sideslip = false;
            self.state = .SwipeCellStateNormal;
            return;
        }
        self.state = .SwipeCellStateAnimating;
        weak var weakSelf = self
        UIView.animate(withDuration: animate ? 0.2 : 0, delay: 0, options: .curveLinear, animations: {
            weakSelf?.setContentViewX(x: 0)
        }) { (finished) in
            DispatchQueue.main.async {
                self.btnContainView?.removeFromSuperview()
                self.btnContainView = nil
                self.state = .SwipeCellStateNormal
            }
        }
    }
    /* Response Events */
    @objc func tableViewPan(pan:UIPanGestureRecognizer) {
        if !self.tableView.isScrollEnabled && pan.state == .began {
            hiddenAllSideslip()
        }
    }
    
    @objc func contentViewPan(pan:UIPanGestureRecognizer){
        let point = pan.translation(in: pan.view)
        let state = pan.state
        pan.setTranslation(.zero, in: pan.view)
        if state == .changed {
            var frame = self.contentView.frame
            frame.origin.x += point.x
            if (frame.origin.x > 15) {
                frame.origin.x = 15;
            } else if (frame.origin.x < -30 - (btnContainView?.frame.size.width ?? 0)) {
                frame.origin.x = -30 - (btnContainView?.frame.size.width ?? 0)
            }
            self.contentView.frame = frame
        }else if(state == .ended){
            let velocity = pan.velocity(in: pan.view)
            if (self.contentView.frame.origin.x == 0) {
                return;
            } else if (self.contentView.frame.origin.x > 5) {
                hiddenWithBounceAnimation()
            } else if (abs(self.contentView.frame.origin.x) >= 40 && velocity.x <= 0) {
                showSideslip()
            } else {
                hiddenSideslip(animate: true)
            }
        }else if (state == .cancelled) {
            hiddenAllSideslip()
        }
    }
    
    private func hiddenWithBounceAnimation(){
        self.state = .SwipeCellStateAnimating
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.setContentViewX(x: -10)
        }) { (finished) in
            self.hiddenSideslip(animate: true)
        }
    }
    
    private func showSideslip(){
        self.state = .SwipeCellStateAnimating
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            weakSelf?.setContentViewX(x: -(weakSelf?.btnContainView?.frame.size.width)!-10)
        }) { (finished) in
            DispatchQueue.main.async {
                weakSelf?.state = .SwipeCellStateOpen
            }
        }
    }
    
    private func setContentViewX(x:CGFloat){
        var frame = self.contentView.frame;
        frame.origin.x = x;
        self.contentView.frame = frame;
    }
    
    private func setActions(actions:[SwipeCellAction]){
        _actions = actions
        if (btnContainView != nil) {
            btnContainView?.removeFromSuperview()
            btnContainView = nil;
        }
        btnContainView = UIView()
        self.insertSubview(btnContainView!, belowSubview: self.contentView)
        for (index,_) in actions.enumerated() {
            let action:SwipeCellAction = actions[index]
            let btn:SwipeActionButton = SwipeActionButton.init(type: .custom)
            btn.tag = index
            btn.adjustsImageWhenHighlighted = false
            btn.setTitle(action.title != nil ? action.title : "", for: .normal)
            btn.titleLabel?.font = action.font != nil ? action.font : UIFont.systemFont(ofSize: 17)
            btn.addTarget(self, action: #selector(actionBtnDidClicked(btn:)), for: .touchUpInside)
            if ((action.backgroundColor) != nil){
                btn.backgroundColor = action.backgroundColor
            }else{
                btn.backgroundColor = action.style == .SwipeCellActionStyleNormal ? UIColor.kColorWith(r: 200, g: 199, b: 205, alpha: 1) : UIColor.red
            }
            if action.image != nil{
                btn.setImage(action.image, for: .normal)
            }
            if action.titleColor != nil{
                btn.setTitleColor(action.titleColor, for: .normal)
            }
            
            var width = action.title != nil ? (((action.title ?? "") as NSString).boundingRect(with: CGSize(width: 0, height: self.frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:btn.titleLabel?.font as Any], context: nil).size.width) : 0
            width += ((action.image != nil) ? (action.image?.size.width)! : 0);
            btn.frame = CGRect(x: 0, y: 0, width: width + action.margin*2, height: self.frame.size.height)
            btn.layer.cornerRadius = action.cornerRadius
            btn.titleLabel?.lineBreakMode = .byWordWrapping;//换行模式自动换行
            btn.titleLabel?.numberOfLines = 0;
            //记录需要扩展动画的条件
            if (action.style == .SwipeCellActionStyleDefault ||
                action.animationStyle == .SwipeCellActionAnimationStyleAnimation) {
                btn.animationStyle = .SwipeCellActionAnimationStyleAnimation;
            }
            btnContainView?.addSubview(btn)
        }
    }
    
    @objc private func actionBtnDidClicked(btn:SwipeActionButton){
        let action = _actions?[btn.tag]
        if (btn.animationStyle == .SwipeCellActionAnimationStyleAnimation) {
            if (btn.logStyle == .SwipeActionButtonStyleSelected) {
                self.actionBtnDidClickToDule(tag: btn.tag)
                return;
            }
            
            if (((action?.confirmTitle) != nil) || ((action?.confirmIcon) != nil)) {
                btn.setTitle(action?.confirmTitle, for: .normal)
                btn.setImage(UIImage(named: action?.confirmIcon ?? ""), for: .normal)
            }else{
                btn.setTitle("确认删除", for: .normal)
            }
            if _actions?.count == 1{
                let width = ((btn.currentTitle ?? "") as NSString).boundingRect(with: CGSize(width: 0, height: self.frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:btn.titleLabel?.font as Any], context: nil).size.width
                btn.frame = CGRect(x: 0, y: 0, width: width + action!.margin * 2, height: self.frame.size.height);
                btn.logStyle = .SwipeActionButtonStyleSelected;
                self.layoutSubviews()
                showSideslip()
            }else{
                let width = btnContainView?.frame.size.width
                btn.frame = CGRect(x: 0, y: 0, width: (width ?? 0), height: self.frame.size.height)
                for button in btnContainView!.subviews{
                    if (button.tag != btn.tag) {
                        button.removeFromSuperview()
                    }
                }
                btn.logStyle = .SwipeActionButtonStyleSelected
                self.layoutSubviews()
                self.showSideslip()
            }
        }else{
            self.actionBtnDidClickToDule(tag: btn.tag)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if sideslip {
            self.hiddenAllSideslip()
        }
    }
    
    private func actionBtnDidClickToDule(tag:NSInteger){
        if (self.SwipDelegate != nil) && (self.SwipDelegate?.responds(to: #selector(SwipDelegate?.swipeSelectCell(swipeCell:indexPath:index:))))! {
            self.SwipDelegate?.swipeSelectCell?(swipeCell: self, indexPath: self.indexPath(), index: tag)
        }
        if tag < _actions!.count {
            let action:SwipeCellAction = (_actions?[tag])!
            if action.handler != nil{
                action.handler!(action, self.indexPath())
            }
        }
        self.hiddenAllSideslip()
        self.state = .SwipeCellStateNormal
    }
    
    private func indexPath()->IndexPath{
        guard let indexP = self.tableView.indexPath(for: self) else {
            return IndexPath()
        }
        return indexP
    }
    
    lazy var tableView:UITableView = {
        var view = self.superview
        while((view != nil) && !(view?.isKind(of: UITableView.self))!){
            view = view?.superview
        }
        let tableView = view as? UITableView
        _tableViewPan = UIPanGestureRecognizer.init(target: self, action: #selector(tableViewPan(pan:)))
        _tableViewPan?.delegate = self
        return tableView!
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

////MARK -UIGestureRecognizerDelegate
extension SwipCell{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == _panGesture){
//            if sideslip {
               hiddenAllSideslip()
//            }
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let translation = gesture.translation(in: gesture.view)
            // 如果手势相对于水平方向的角度大于45°, 则不触发侧滑
            var shouldBegin = abs(translation.y) <= abs(translation.x)
            if !shouldBegin {return false}
            // 询问代理是否需要侧滑
            if (self.SwipDelegate != nil) && (self.SwipDelegate?.responds(to: #selector(SwipDelegate?.swipCanSwipeRowAtIndexPath(swipeCell:indexPath:))))!{
                shouldBegin = (self.SwipDelegate?.swipCanSwipeRowAtIndexPath?(swipeCell: self, indexPath: self.indexPath()))! || sideslip
            }
            if (shouldBegin) {
                // 向代理获取侧滑展示内容数组
                if (self.SwipDelegate != nil) && (self.SwipDelegate?.responds(to: #selector(SwipDelegate?.swipeEditActionsForRowAtIndexPath(swipeCell:indexPath:))))!{
                    let actions:[SwipeCellAction]? = self.SwipDelegate?.swipeEditActionsForRowAtIndexPath?(swipeCell: self, indexPath: self.indexPath());
                    if actions != nil || actions?.count != 0{
                        self.setActions(actions: actions!)
                    }else{
                        return false
                    }
                }
                return shouldBegin
            }
        }else if(gestureRecognizer == _tableViewPan){
            if (self.tableView.isScrollEnabled) {
                return false;
            }
        }
        return true
    }
}

//MARK -SwipeCellDelegate
@objc protocol SwipeCellDelegate : NSObjectProtocol{
    /**
     选中了侧滑按钮
     
     @param swipeCell 当前响应的cell
     @param indexPath cell在tableView中的位置
     @param index 选中的是第几个action
     */
    @objc optional func swipeSelectCell(swipeCell:SwipCell,indexPath:IndexPath,index:NSInteger)
    /**
     告知当前位置的cell是否需要侧滑按钮
     
     @param swipeCell 当前响应的cell
     @param indexPath cell在tableView中的位置
     @return YES 表示当前cell可以侧滑, NO 不可以
     */
    @objc optional func swipCanSwipeRowAtIndexPath(swipeCell:SwipCell,indexPath:IndexPath)->Bool
    /**
     返回侧滑事件
     
     @param swipeCell 当前响应的cell
     @param indexPath cell在tableView中的位置
     @return 数组为空, 则没有侧滑事件
     */
    @objc optional func swipeEditActionsForRowAtIndexPath(swipeCell:SwipCell,indexPath:IndexPath)->[SwipeCellAction]
}



//MARK -UITableView(SwipeCell)
extension UITableView{
    func hiddenAllSidesli() {
        for cell in self.visibleCells {
            if cell.isKind(of: SwipCell.self){
                let c:SwipCell = cell as! SwipCell
                c.hiddenSideslip(animate: true)
            }
        }
    }
}
