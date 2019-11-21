//
//  PicController.swift
//  SwiftDemo
//
//  Created by john on 2019/11/18.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import Kingfisher
class PicController: BaseViewController {

    let arrIMG:[String] = [
        "http://img.tupianzj.com/uploads/allimg/180808/23-1PPQ20220-50.jpg",
        "http://pic1.win4000.com/wallpaper/5/58a7f269a6de0.jpg",
        "http://pic1.win4000.com/wallpaper/8/589c2f0f014ba.jpg",
        "http://pic1.win4000.com/wallpaper/a/55349fb752abc.jpg",
        "http://img17.3lian.com/d/file/201702/09/54fa2e4df6867f09b2df42e411d3bbdf.jpg",
        "http://dpic.tiankong.com/6a/v7/QJ8662705219.jpg",
        "http://www.leawo.cn/attachment/201409/1/1723875_1409556793I3Eg.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片加载..."
        setUI()
    }
    
    func setUI() {
        self.setNavItem(imageName: "", title: "清除缓存", action: #selector(clearCache), index: 1)
        view.addSubview(collB)
        collB.register(PicCell.self, forCellWithReuseIdentifier: "cell")
    }
    
   @objc func clearCache()  {
    let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.backgroundColor = UIColor.black
        hud.contentColor = UIColor.white;
        _ = delay(3, task: {
            MBProgressHUD.an_showSuccessMessage(message: "清除成功")
            KingfisherManager.shared.cache.clearMemoryCache()
            KingfisherManager.shared.cache.clearDiskCache()
            self.collB.reloadData()
        })
    }
    
    lazy var collB:CustomCollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical;
        //设置最小间距
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSize(width: (kScreenWidth-30)/2, height: 229)
//        layout.sectionHeadersPinToVisibleBounds = true; //设置是否需要悬浮区头
        // 设置分区头视图和尾视图宽高
//        layout.headerReferenceSize = CGSize.init(width: ScreenWidth, height: 80)
//        layout.footerReferenceSize = CGSize.init(width: ScreenWidth, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0);
        layout.footerReferenceSize = CGSize.zero;
        let collB = CustomCollectionView(frame: CGRect(x: 0, y: kTopHeight, width: kScreenWidth, height: kScreenHeight-kTopHeight), collectionViewLayout: layout, isRefresh: false, showNoData: true)
        collB.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10);
        collB.delegate = self
        collB.dataSource = self
        return collB
    }()
}

extension PicController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrIMG.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PicCell
        cell.imageB.kf.setImage(with: URL.init(string: arrIMG[indexPath.row]), placeholder: kImage_Named(name: "支付成功"),
                 options: [.transition(.fade(0.2))])
        return cell
    }
//    //设定header和footer的方法，根据kind不同进行不同的判断即可
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader{
//            let headerView : CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! CollectionHeaderView
//            headerView.view.backgroundColor = UIColor.red
//            headerView.label.text = "This is HeaderView"
//            return headerView
//        }else{
//            let footView : CollectionFootView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footIdentifier, for: indexPath) as! CollectionFootView
//            footView.view.backgroundColor = UIColor.purple
//            footView.label.text = "This is Foot"
//            return footView
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.init(width: kScreenWidth, height: 10)
//    }
    //footer高度
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize.init(width: ScreenWidth, height: 80)
//    }
}

class PicCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageB)
        KViewRadiusShadow(view: self, Radius: 3)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    lazy var imageB:UIImageView = {
        let imageB = UIImageView(frame: CGRect(x: 0, y: 0, width: self.k_width, height: self.k_height))
        imageB.contentMode = UIView.ContentMode.scaleAspectFill;
        imageB.clipsToBounds = true
        return imageB
    }()
}
