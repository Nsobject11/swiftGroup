//
//  CustomCollectionView.swift
//  SwiftDemo
//
//  Created by john on 2019/11/15.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
class CustomCollectionView: UICollectionView {
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
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout,isRefresh:Bool,showNoData:Bool) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.isNeedMJRefresh = isRefresh
        self.isShowNoData = showNoData
        Mydelegate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Mydelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func Mydelegate() {
        if (self.isShowNoData) {
            self.emptyDataSetSource = self;
            self.emptyDataSetDelegate = self;
        }
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        self.backgroundColor = UIColor.clear;
        //头部刷新
        if (self.isNeedMJRefresh) {
            let header:MJRefreshNormalHeader
            let footer:MJRefreshAutoNormalFooter;
            header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRereshing))
            footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRereshing))
            header.isAutomaticallyChangeAlpha = true;
            header.lastUpdatedTimeLabel.isHidden = false;
            // 设置文字
            footer.setTitle("", for: .idle)
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
extension CustomCollectionView:EmptyDataSetSource,EmptyDataSetDelegate{
    
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
