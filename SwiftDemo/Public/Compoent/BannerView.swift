//
//  BannerView.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import FSPagerView
enum BannerViewControlType: Int{
    case BannerViewControlTypeNormal
    case BannerViewControlTypeNum //数字
}
class BannerView: UIView {
    var controlType:BannerViewControlType = .BannerViewControlTypeNormal
    var bannerPicArray:Array<String> = []{
        didSet{
            pageControl.numberOfPages = bannerPicArray.count
            if controlType == .BannerViewControlTypeNum {
                labSum.text = " / " + String(bannerPicArray.count)
            }
            cycleScrollView.reloadData()
        }
    }
    
    init(frame: CGRect,cType:BannerViewControlType = .BannerViewControlTypeNormal) {
        super.init(frame: frame)
        controlType = cType
        setUI()
    }
    
    func setUI(){
        self.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self);
        }
        if controlType == .BannerViewControlTypeNormal { //默认指示器
            setNornalControl()
        }else if(controlType == .BannerViewControlTypeNum){//数字指示器
            setNumControl()
        }
    }
   
    /**FSPagerView开始**/
    lazy var cycleScrollView:FSPagerView = {
        let cycleScrollView = FSPagerView()
        cycleScrollView.backgroundColor = UIColor.clear
        cycleScrollView.dataSource = self
        cycleScrollView.delegate = self
//        cycleScrollView.itemSize = FSPagerView.automaticSize
        cycleScrollView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        cycleScrollView.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
//        cycleScrollView.interitemSpacing = 8.0
       //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        cycleScrollView.isInfinite = true
        //设置转场的模式
//        cycleScrollView.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)
        return cycleScrollView
    }()
    /**FSPagerView默认的control**/
    lazy var pageControl:FSPageControl = {
        let pageControl = FSPageControl()
//        pageControl.backgroundColor = UIColor.cyan
        pageControl.contentHorizontalAlignment = .center
//        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
//        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5),                 cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
//        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .selected)
        return pageControl
    }()
    /**默认的指示器**/
    func setNornalControl() {
        self.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(cycleScrollView.snp_bottom)
            make.left.right.equalTo(cycleScrollView)
            make.height.equalTo(25)
        }
    }
    /**数字control**/
    func setNumControl() {
        self.addSubview(labSum)
        self.addSubview(labCurrent)
        labSum.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-15);
            make.bottom.equalTo(self.snp_bottom).offset(-15);
        }
        labCurrent.snp.makeConstraints { (make) in
            make.right.equalTo(labSum.snp_left);
            make.bottom.equalTo(labSum.snp_bottom);
        }
    }
    lazy var labCurrent:UILabel = {
        let labCurrent  = UILabel()
        labCurrent.text = "1"
        labCurrent.font = kFont(name: "PingFangSC-Semibold", size: 17);
        labCurrent.textColor = KRGB(r: 12, g: 1, b: 4)
        return labCurrent
    }()
    
    lazy var labSum:UILabel = {
        let labSum  = UILabel()
        labSum.text = " / 1"
        labSum.font = kSystemFont(size: 11)
        labSum.textColor = KRGB(r: 7, g: 5, b: 7)
        return labSum
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerView:FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerPicArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL.init(string: bannerPicArray[index]), placeholder: kImage_Named(name: "支付成功"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true 
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
        if controlType == .BannerViewControlTypeNum {
            labCurrent.text = String(pagerView.currentIndex+1)
        }
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        if controlType == .BannerViewControlTypeNum {
            labCurrent.text = String(pagerView.currentIndex+1)
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
}
