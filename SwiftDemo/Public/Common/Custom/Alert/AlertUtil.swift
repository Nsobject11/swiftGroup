//
//  AlertUtil.swift
//  SwiftDemo
//
//  Created by john on 2019/11/11.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

///** 点击Alert action处理 */
typealias AlertUtilAlertHandler = ((UIAlertAction) -> (Void))
///** AlertController显示完成 */
typealias AlertUtilAlertCompletion = (() -> (Void))
///** 多个类似alert action处理 */
typealias AlertUtilMultiAlertHandler = ((UIAlertAction,[String],Int) -> (Void))


class AlertUtil: NSObject {
     
    /** pop单个按钮提示框 */
    class func alertSingleWithTitle(title:String,message:String,defaultTitle:String,defaultHandler:@escaping AlertUtilAlertHandler,completion:@escaping AlertUtilAlertCompletion){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert);
        AlertUtil().p_addActions(actions: [], alertController: alertController, cancelTitle: defaultTitle, cancelHandler: defaultHandler, completion: completion);
    }
    
    /** pop两个按钮提示框 */
    class func alertDualWithTitle(title:String,message:String,preferredStyle:UIAlertController.Style,cancelTitle:String,cancelHandler:@escaping AlertUtilAlertHandler,defaultTitle:String,defaultHandler:@escaping AlertUtilAlertHandler,completion:@escaping AlertUtilAlertCompletion){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle);
        AlertUtil().p_addActions(actions: AlertUtil().p_alertActionsWithTitles(titles: [defaultTitle], handlers: [defaultHandler]), alertController: alertController, cancelTitle: cancelTitle, cancelHandler: cancelHandler, completion: completion);
    }
    
    /** pop多个相似按钮提示框 */
    class func alertMultiWithTitle(title:String,message:String,preferredStyle:UIAlertController.Style,multiTitles:[String],multiHandler:@escaping AlertUtilMultiAlertHandler,cancelTitle:String,cancelHandler:@escaping AlertUtilAlertHandler,completion:@escaping AlertUtilAlertCompletion){
        if multiTitles.count==0 {
            return;
        }
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle);
        AlertUtil().p_addActions(actions: AlertUtil().p_alertActionsWithMuTitles(titles: multiTitles, multiHandler: multiHandler), alertController: alertController, cancelTitle: cancelTitle, cancelHandler: cancelHandler, completion: completion)
    }
    
    /** pop底部自动消失提示框(有键盘时在中间，没键盘时在底部) */
    class func showTempInfo(info:String){
        let bottom = UIScreen.main.bounds.size.height/2;
        AlertUtil.p_showTempInfo(info: info, bottom: bottom);
    }
    
    /**轻提示组件**/
    static var lastLabel:UILabel?
    class func p_showTempInfo(info:String,bottom:CGFloat){
        let screenSize = UIScreen.main.bounds.size;
        let duration = 1.5;
        let spareWidth = 8*4.0;
        let spareHeight = 8*1.5;
        let textColor = UIColor.white;
        let font = UIFont.init(name: "PingFangSC-Medium", size: 14);
        let alertLabelSize = NSString(string: info).boundingRect(with: CGSize(width: screenSize.width*0.8, height: screenSize.height*0.8), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font as Any], context: nil).size;
        let alertLabelW = Double(alertLabelSize.width) + spareWidth;
        let alertLabelH = Double(alertLabelSize.height) + spareHeight;
        let alertLabelX = Double(screenSize.width*0.5) - Double(alertLabelW * 0.5);
        let alertLabelY = Double(screenSize.height) - Double(bottom) - alertLabelH + 20;
        let alertLabel = UILabel.init(frame: CGRect(x: alertLabelX, y: alertLabelY, width: alertLabelW, height: alertLabelH));
        alertLabel.alpha = 0;
        alertLabel.backgroundColor = KHexColor(color: "000000", alpha: 1);
        alertLabel.text = info;
        alertLabel.textColor = textColor;
        alertLabel.textAlignment = .center;
        alertLabel.font = font;
        alertLabel.numberOfLines = 0;
        alertLabel.layer.cornerRadius = 3;
        alertLabel.layer.masksToBounds = true;
        
        /**
         *  1、添加本次label，移除上次label；
         *  2、时间间隔后移除本次label
         */
        let window = UIApplication.shared.windows.last;
        if (bottom == screenSize.height * 0.5) {
            alertLabel.center = window!.center;
        }
        window?.addSubview(alertLabel);
        UIView.animate(withDuration: 0.3, animations: {
            alertLabel.alpha = 1;
            alertLabel.k_y = screenSize.height - bottom - CGFloat(alertLabelH);
        })
        if (lastLabel != nil) {
            lastLabel!.removeFromSuperview();
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute:
            {
                UIView.animate(withDuration: 0.3, animations: {
                    alertLabel.k_y = CGFloat(alertLabelY + 20);
                    alertLabel.alpha = 0;
                }, completion: { (flag) in
                    alertLabel.removeFromSuperview()
                })
        })
        lastLabel = alertLabel;
        
    }
    
    private func p_alertActionsWithTitles(titles:[String],handlers:[AlertUtilAlertHandler])->([UIAlertAction]){
        
        if titles.count != handlers.count {
            return [];
        }
        var alertActions:[UIAlertAction] = [];
        for (index,item) in titles.enumerated() {
            let alerAction = UIAlertAction.init(title: item, style: .default) { (action) in
                handlers[index](action);
            }
            alertActions.append(alerAction);
        }
        return alertActions;
    }
    
    private func p_alertActionsWithMuTitles(titles:[String],multiHandler:@escaping AlertUtilMultiAlertHandler)->([UIAlertAction]){
        
        var alertActions:[UIAlertAction] = [];
        for (index,item) in titles.enumerated() {
            let alerAction = UIAlertAction.init(title: item, style: .default) { (action) in
                multiHandler(action, titles, index)
            }
            alertActions.append(alerAction);
        }
        return alertActions;
    }
    
    class func p_cancelActionWithTitle(cancelTitle:String,cancelHandler:@escaping AlertUtilAlertHandler)->(UIAlertAction){
        let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler(action);
        }
        return cancelAction;
    }
    
    
    private func p_addActions(actions:[UIAlertAction],alertController:UIAlertController,cancelTitle:String,cancelHandler:@escaping AlertUtilAlertHandler,completion:@escaping AlertUtilAlertCompletion){
        for action in actions {
            alertController.addAction(action);
        }
        alertController.addAction(AlertUtil.p_cancelActionWithTitle(cancelTitle: cancelTitle, cancelHandler: { (action) -> (Void) in
            cancelHandler(action);
        }))
        
        getCurrentVC().present(alertController, animated: true) {
            completion();
        }
    }
    
}
