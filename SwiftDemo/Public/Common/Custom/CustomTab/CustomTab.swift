//
//  CustomTab.swift
//  SwiftDemo
//
//  Created by john on 2019/11/15.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
class CustomTab: UITableView {
    
    var isNeedMJRefresh:Bool = false{
        didSet{
            Mydelegate()
        }
    }
    var isShowNoData:Bool = false{
        didSet{
            Mydelegate()
        }
    }
    
    typealias swiftBlock = () -> Void
    typealias swiftBlockUp = () -> Void
    var DownRefreshBlock: swiftBlock?
    var UpRefreshBlock: swiftBlockUp?
    func DownRefreshBlock(block: @escaping swiftBlock) {
        DownRefreshBlock = block
    }
    func UpRefreshBlock(block: @escaping swiftBlockUp) {
        UpRefreshBlock = block
    }
    var name:String = "暂无数据"{
        didSet{
            self.noDataView.label.text = name
        }
    }
    
    var imgName:String = "支付成功"{
        didSet{
            self.noDataView.image.image = kImage_Named(name: imgName)
        }
    }

    init(frame: CGRect, style: UITableView.Style,isRefresh:Bool=false,showNoData:Bool=false) {
        super.init(frame: frame, style: style)
        self.isNeedMJRefresh = isRefresh
        self.isShowNoData = showNoData
        Mydelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Mydelegate()
    }
    
    func Mydelegate() {
        if self.isShowNoData {
            self.emptyDataSetSource = self;
            self.emptyDataSetDelegate = self;
        }
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.estimatedRowHeight = 0;
        self.rowHeight = UITableView.automaticDimension;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.separatorStyle = .none;
        self.backgroundColor = UIColor.clear;
        if self.isNeedMJRefresh {
            let header:MJRefreshNormalHeader
            let footer:MJRefreshAutoNormalFooter;
            header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRereshing))
            footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRereshing))
            self.mj_header = header;
            self.mj_footer = footer;
        }
        self.scrollsToTop = true;
    }
    //头部上拉
    @objc func headerRereshing() {
        if (self.DownRefreshBlock != nil){
            self.DownRefreshBlock!()
        }
    }
    //底部下拉
    @objc func footerRereshing()  {
        if (self.UpRefreshBlock != nil){
            self.UpRefreshBlock!()
        }
    }
    
    lazy var noDataView:NoDataView={
        let noDataView = NoDataView.init()
        return noDataView
    }()
}


extension CustomTab:EmptyDataSetSource,EmptyDataSetDelegate{
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return self.noDataView
    }
    
    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5) {
         scrollView.contentOffset = .zero
        }
    }
    
    
}
