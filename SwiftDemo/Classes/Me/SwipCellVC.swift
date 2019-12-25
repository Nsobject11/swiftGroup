//
//  SwipCellVC.swift
//  SwiftDemo
//
//  Created by john on 2019/12/25.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class SwipCellVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.TabB)
    }
    
    lazy var TabB:CustomTab = {
       let TabB = CustomTab.init(frame: CGRect(x: 0, y: kTopHeight, width: kScreenWidth, height: kScreenHeight-kTopHeight), style: .plain, isRefresh: false, showNoData: false)
        TabB.rowHeight = 60
        TabB.delegate = self
        TabB.dataSource = self
        return TabB
    }()
}

extension SwipCellVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:TxtCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? TxtCell
        if cell == nil {
            cell = TxtCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.SwipDelegate = self
        cell?.lab.text = "我是第\(indexPath.row)"
        return cell!
    }
}

extension SwipCellVC:SwipeCellDelegate{
    func swipeEditActionsForRowAtIndexPath(swipeCell: SwipCell, indexPath: IndexPath) -> [SwipeCellAction] {
        let deleteAction = SwipeCellAction.rowActionWithStyle(style: .SwipeCellActionStyleNormal, title: nil) { (action, indexPath) in
            AlertUtil.showTempInfo(info: "点我z做甚\(indexPath.row)")
        }
        deleteAction.backgroundColor = UIColor.black
        deleteAction.image = UIImage(named: "lajitong48");
        deleteAction.cornerRadius = 0;
        
        let deleteAction1 = SwipeCellAction.rowActionWithStyle(style: .SwipeCellActionStyleNormal, title: "点点") { (action, indexPath) in
            AlertUtil.showTempInfo(info: "点我z做甚\(indexPath.row)")
        }
        deleteAction1.backgroundColor = UIColor.cyan
        deleteAction1.cornerRadius = 0;
        return [deleteAction,deleteAction1]
    }
    
    func swipCanSwipeRowAtIndexPath(swipeCell: SwipCell, indexPath: IndexPath) -> Bool {
        return true
    }
}

class TxtCell: SwipCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.selectionStyle = .none
        addSubview(lab)
        addSubview(viewLine)
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(15)
            make.centerY.equalTo(self.snp_centerY)
        }
        viewLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    lazy var lab:UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = kRandomColor
        return lab
    }()
    
    lazy var viewLine:UIView = {
        let viewLine = UIView()
        viewLine.backgroundColor = KHexColor(color: "CDCDCD")
        return viewLine
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
