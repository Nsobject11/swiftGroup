//
//  PhotoSelect.swift
//  SwiftDemo
//
//  Created by john on 2019/11/19.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
import Kingfisher
class PhotoSelect: UIView {
    var control:UIViewController = UIViewController()
    var collectionView:UICollectionView?
    var isSelectOriginalPhoto:Bool = false
    var operationQueue:OperationQueue?
    var selectedPhotos:[Any] = [] //选择的图片数组
    var selectedAssets:[Any] = [] // 选择asset数组
    var allowTakePicture:Bool = true /// 默认为YES，如果设置为NO, 用户将不能拍摄照片
    var allowTakeVideo:Bool = false /// 默认为YES，如果设置为NO, 用户将不能拍摄视频
    var showTakePhotoBtnSwitch:Bool = true ///< 在内部显示拍照按钮
    var showTakeVideoBtnSwitch:Bool = true ///< 在内部显示拍视频按钮
    var sortAscendingSwitch:Bool = true ///< 照片排列按修改时间升序
    var allowPickingVideoSwitch:Bool = false ///< 不允许选择视频
    var allowPickingImageSwitch:Bool = true ///< 允许选择图片
    var allowPickingGifSwitch:Bool = false ///< 不允许选择GIF
    var allowPickingOriginalPhotoSwitch:Bool = true ///< 允许选择原图
    var showSheetSwitch:Bool = true //显示一个sheet,把拍照按钮放在外面
    var maxCountTF:Int = 10 ///< 照片最大可选张数，设置为1即为单选模式
    var maxCountForRow:Int = 10 ///<界面上一行最多显示几张
    var columnNumberTF:Int = 4 ///<选择相册里图片时一行显示几张
    var allowCropSwitch:Bool = false //允许剪切图片
    var needCircleCropSwitch:Bool = false // 圆型裁剪
    var allowPickingMuitlpleVideoSwitch:Bool = false //允许选择多个视频
    var showSelectedIndexSwitch:Bool = true
    
    weak var delegate : PhotoSelectDelegate?
    
    init(frame: CGRect,controll:UIViewController) {
        super.init(frame: frame)
        control = controll
        configCollectionView()
    }
    
    /**初始化选择collectionview**/
    func configCollectionView() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumInteritemSpacing = 6
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.k_width, height: self.k_height), collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.addSubview(collectionView!)
        
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imagePickerVc:UIImagePickerController = {
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.navigationBar.barTintColor = control.navigationController?.navigationBar.barTintColor
        imagePickerVc.navigationBar.tintColor = control.navigationController?.navigationBar.tintColor
        imagePickerVc.delegate = self 

//        let tzBarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [TZImagePickerController.self])
//        let BarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIImagePickerController.self])
//        let titleTextAttributes:Dictionary = tzBarItem.titleTextAttributes(for: .normal)!
//        BarItem.setTitleTextAttributes(titleTextAttributes, for: .normal)
        return imagePickerVc
    }()
}


extension PhotoSelect : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedPhotos.count >= maxCountTF {
            return selectedPhotos.count + 1
        }
        return selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.videoImageView.isHidden = true
        if indexPath.item == selectedPhotos.count {
            cell.imageView.image = UIImage.init(named: "添加图片");
            cell.deleteBtn.isHidden = true;
            cell.gifLable.isHidden = true;
        }else if(indexPath.item != selectedPhotos.count){
            let s:AnyObject = selectedPhotos[indexPath.item] as AnyObject
            if((s is String) && s.contains("http")){
                let asset:[String:String] = selectedAssets[indexPath.row] as! Dictionary
                let name:String = asset["filename"] ?? ""
                if(name.contains("video")){
                    let urlVideo:String  = (selectedPhotos[0]) as! String
                    cell.imageView.image = UIImage.thumbnailOfAVAsset(url: NSURL.init(string: urlVideo)!)
                }else{
                    cell.imageView.kf.setImage(with: selectedPhotos[indexPath.row] as? Resource,placeholder: kImage_Named(name: "支付成功"))
                }
            }else{
                cell.imageView.image = (selectedPhotos[indexPath.item] as! UIImage)
            }
            cell.deleteBtn.isHidden = false;
        }else{
            cell.imageView.image = (selectedPhotos[indexPath.item] as! UIImage);
            cell.asset = selectedAssets[indexPath.item] as! PHAsset;
            cell.deleteBtn.isHidden = false;
        }
        if (!self.allowPickingGifSwitch) {
            cell.gifLable.isHidden = true;
        }
        cell.deleteBtn.tag = indexPath.item;
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClik(btn:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.item == selectedPhotos.count) {
            if (self.maxCountTF==1) {
                AlertUtil.showTempInfo(info: "视频暂只能选择一个")
                return
            }
            let showSheet:Bool = self.showSheetSwitch
            if showSheet {
                TanAlertSheet(indexPath: indexPath)
            }else{
                self.pushTZImagePickerController()
            }
        }else{// preview photos or video / 预览照片或者视频
            let asset:PHAsset = selectedAssets[indexPath.item] as! PHAsset
            var isVideo:Bool = false
            if(asset.isKind(of: PHAsset.self)){
                isVideo = asset.mediaType == .video;
            }
            let GIF:String = asset.value(forKey: "filename") as! String
            if(GIF.contains("GIF") && self.allowPickingGifSwitch && !self.allowPickingMuitlpleVideoSwitch){
                let vc = TZGifPhotoPreviewController()
                let model:TZAssetModel = TZAssetModel.init(asset: asset, type: TZAssetModelMediaTypePhotoGif)
                vc.model = model
                self.control.present(vc, animated: true, completion: nil)
            }else if(isVideo && !self.allowPickingMuitlpleVideoSwitch){
                // perview video / 预览视频
                let vc = TZVideoPlayerController()
                let model:TZAssetModel = TZAssetModel.init(asset: asset, type: TZAssetModelMediaTypeVideo)
                vc.model = model
                self.control.present(vc, animated: true, completion: nil)
            }else{
                if(!asset.isKind(of: PHAsset.self) && GIF.contains("image")){
                    return
                }
                let AsserM:NSMutableArray = NSMutableArray.init(array: selectedAssets)
                let PhotoM:NSMutableArray = NSMutableArray.init(array: selectedPhotos)
                let imagePickerVc = TZImagePickerController.init(selectedAssets: AsserM, selectedPhotos: PhotoM, index: indexPath.item)
                imagePickerVc?.maxImagesCount = self.maxCountTF;
                imagePickerVc?.allowPickingGif = self.allowPickingGifSwitch;
                imagePickerVc?.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
                imagePickerVc?.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch;
                imagePickerVc?.showSelectedIndex = self.showSelectedIndexSwitch;
                imagePickerVc?.isSelectOriginalPhoto = isSelectOriginalPhoto;
                imagePickerVc?.didFinishPickingPhotosHandle = {(photos,assets,isSelectOriginalPhoto) in
                    self.selectedPhotos += photos ?? []
                    self.selectedAssets += assets ?? []
                    self.isSelectOriginalPhoto = isSelectOriginalPhoto;
                    self.collectionView?.reloadData()
                }
                self.control.present(imagePickerVc!, animated: true, completion: nil)
            }
        }
    }
    
    /*弹出选择相册or相机**/
    func TanAlertSheet(indexPath:IndexPath?) {
        var takePhotoTitle:String = "拍照"
        if (self.showTakeVideoBtnSwitch && self.showTakePhotoBtnSwitch) {
            takePhotoTitle = "相机";
        } else if (self.showTakeVideoBtnSwitch) {
            takePhotoTitle = "拍摄";
        }
        let alertVc = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction.init(title: takePhotoTitle, style: .default) { (action) in
            self.takePhoto()
        }
        alertVc.addAction(takePhotoAction)
        
        let imagePickerAction = UIAlertAction.init(title: "去相册选择", style: .default) { (action) in
            self.pushTZImagePickerController()
        }
        alertVc.addAction(imagePickerAction)
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .default, handler: nil)
        alertVc.addAction(cancelAction)
        
        if indexPath != nil {
            let popover = alertVc.popoverPresentationController
            let cell = collectionView?.cellForItem(at: indexPath!)
            if((popover) != nil){
                popover?.sourceView = cell
                popover?.sourceRect = cell!.bounds
                popover?.permittedArrowDirections = UIPopoverArrowDirection.any
            }
        }
        self.control.present(alertVc, animated: true, completion: nil)
    }
    
    /**TZImagePickerController**/
    /**从相册选择**/
    func pushTZImagePickerController() {
        if (self.maxCountTF <= 0) {
            return;
        }
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: self.maxCountTF, columnNumber: self.columnNumberTF, delegate: self,pushPhotoPickerVc: true)
        ///五类个性化设置，这些参数都可以不传，此时会走默认设置
        imagePickerVc!.isSelectOriginalPhoto = isSelectOriginalPhoto;
        if (self.maxCountTF > 1) {
            // 1.设置目前已经选中的图片数组
            imagePickerVc?.selectedAssets = selectedAssets as? NSMutableArray; // 目前已经选中的图片数组
        }
        imagePickerVc?.allowTakePicture = self.showTakePhotoBtnSwitch; // 在内部显示拍照按钮
        imagePickerVc?.allowTakeVideo = self.showTakeVideoBtnSwitch;   // 在内部显示拍视频按
        imagePickerVc?.videoMaximumDuration = 10; // 视频最大拍摄时间
        imagePickerVc?.uiImagePickerControllerSettingBlock = {(imagePickerController) in
             imagePickerController?.videoQuality = UIImagePickerController.QualityType.typeHigh
        }
        imagePickerVc?.iconThemeColor = UIColor.init(red: 31/255.0, green: 185/255.0, blue: 34/255.0, alpha: 1.0)
        imagePickerVc?.showPhotoCannotSelectLayer = true
        imagePickerVc?.cannotSelectLayerColor = UIColor.init(white: 1, alpha: 0.8)
        imagePickerVc?.photoPickerPageUIConfigBlock = {(collectionView,bottomToolBar,previewButton,originalPhotoButton,originalPhotoLabel,doneButton,numberImageView,numberLabel,divideLine) in
            doneButton?.setTitleColor(UIColor.red, for: .normal)
        }
        
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc?.allowPickingVideo = self.allowPickingVideoSwitch;
        imagePickerVc?.allowPickingImage = self.allowPickingImageSwitch;
        imagePickerVc?.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
        imagePickerVc?.allowPickingGif = self.allowPickingGifSwitch;
        imagePickerVc?.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch; // 是否可以多选视频
        
        // 4. 照片排列按修改时间升序
        imagePickerVc?.sortAscendingByModificationDate = self.sortAscendingSwitch;
        
        imagePickerVc?.showSelectBtn = false;
        imagePickerVc?.allowCrop = self.allowCropSwitch;
        imagePickerVc?.needCircleCrop = self.needCircleCropSwitch;
        
        let left = 30
        let widthHeight = self.tz_width - CGFloat(2 * left)
        let top = (self.tz_height - widthHeight) / 2
        imagePickerVc?.cropRect = CGRect(x: CGFloat(left), y: top, width: widthHeight, height: widthHeight)
        imagePickerVc?.statusBarStyle = .lightContent
        // 设置是否显示图片序号
        imagePickerVc?.showSelectedIndex = self.showSelectedIndexSwitch;
        imagePickerVc?.preferredLanguage = "zh-Hans";
        imagePickerVc?.didFinishPickingPhotosHandle = {(photos,assets,isSelectOriginalPhoto) in
            ///s图片回调
            if((self.delegate != nil) && (self.delegate?.responds(to: #selector(PhotoSelectDelegate.selectImageArr(imageArr:))))!){
                self.delegate?.selectImageArr?(imageArr: photos! as NSArray)
            }
            
        }
        self.control.present(imagePickerVc!, animated: true, completion: nil)
    }
    
    
    /**拍照**/
    func takePhoto() {
        let authStatus =  AVCaptureDevice.authorizationStatus(for: .video)
        if (authStatus == .restricted || authStatus == .denied){
            AlertUtil.alertDualWithTitle(title: "无法使用相机", message: "请在iPhone的设置-隐私-相机中允许访问相机", preferredStyle: .alert, cancelTitle: "取消", cancelHandler: { (action) -> (Void) in
                
            }, defaultTitle: "设置", defaultHandler: { (action) -> (Void) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
            }) { () -> (Void) in
                
            }
        }else if (authStatus == .notDetermined){
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if (granted) {
                    DispatchQueue.main.async {//串行、异步
                        self.takePhoto()
                    }
                }
            }
        }else if(PHPhotoLibrary.authorizationStatus().rawValue == 2){// 已被拒绝，没有相册权限，将无法保存拍的照片
            AlertUtil.alertDualWithTitle(title: "无法访问相册", message: "请在iPhone的设置-隐私-相册中允许访问相册", preferredStyle: .alert, cancelTitle: "取消", cancelHandler: { (action) -> (Void) in
                
            }, defaultTitle: "设置", defaultHandler: { (action) -> (Void) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
            }) { () -> (Void) in
                
            }
        }else if(PHPhotoLibrary.authorizationStatus().rawValue == 0){// 未请求过相册权限
            TZImageManager.default()?.requestAuthorization(completion: {
                self.takePhoto()
            })
        }else{
            self.pushImagePickerController()
        }
    }
    
    func pushImagePickerController() {
        let sourceType = UIImagePickerController.SourceType.camera
        if(UIImagePickerController.isSourceTypeAvailable(sourceType)){
            self.imagePickerVc.sourceType = sourceType;
            var mediaTypes:[String] = []
            if (self.allowTakeVideo) {
                mediaTypes.append(String(kUTTypeMovie))
            }
            if (self.allowTakePicture) {
                mediaTypes.append(String(kUTTypeImage))
            }
            if (mediaTypes.count>0) {
                imagePickerVc.mediaTypes = mediaTypes;
            }
            self.control.present(imagePickerVc, animated: true, completion: nil)
        }else{
            print("模拟器中无法打开照相机,请在真机中使用")
        }
    }
    
    func refreshCollectionViewWithAddedAsset(asset:PHAsset,image:UIImage)  {
        selectedAssets.append(asset)
        selectedPhotos.append(image)
        collectionView?.reloadData()
        if (asset.isKind(of: PHAsset.self)) {
            print(asset.location as Any);
        }
        ///图片回调
        if((self.delegate != nil) && (self.delegate?.responds(to: #selector(PhotoSelectDelegate.selectImageArr(imageArr:))))!){
            self.delegate?.selectImageArr?(imageArr: selectedPhotos as NSArray)
        }
        
    }
    
    func printAssetsName(assets:NSArray) {
        var fileName:String = ""
        for asset in assets {
            if((asset as AnyObject).isKind(of: PHAsset.self)){
                let ass:PHAsset = asset as! PHAsset
                fileName = ass.value(forKey: "filename") as! String;
                print(fileName)
            }
        }
    }
    
    /**删除按钮方法**/
    @objc func deleteBtnClik(btn:UIButton) {
        if(self.collectionView(collectionView!, numberOfItemsInSection: 0) <= selectedPhotos.count){
            selectedPhotos.removeAll()
            selectedAssets.removeAll()
            collectionView?.reloadData()
            //删除后图片回调
            if((self.delegate != nil) && (self.delegate?.responds(to: #selector(PhotoSelectDelegate.selectImageArr(imageArr:))))!){
                self.delegate?.selectImageArr?(imageArr: selectedPhotos as NSArray)
            }
            return
        }
        
        selectedAssets.remove(at: btn.tag)
        selectedPhotos.remove(at: btn.tag)
        collectionView?.performBatchUpdates({
            let indexPath = NSIndexPath.init(row: btn.tag, section: 0)
            collectionView?.deleteItems(at: [indexPath as IndexPath])
        }) { (finished) in
            self.collectionView?.reloadData()
            ///删除后图片回调
            if((self.delegate != nil) && (self.delegate?.responds(to: #selector(PhotoSelectDelegate.selectImageArr(imageArr:))))!){
                self.delegate?.selectImageArr?(imageArr: self.selectedPhotos as NSArray)
            }
        }
    }
}

extension PhotoSelect : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        let type:String = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.mediaType) as! String
        let tzImagePickerVc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
        tzImagePickerVc?.sortAscendingByModificationDate = self.sortAscendingSwitch;
        tzImagePickerVc?.showProgressHUD()
        if (type == "public.image") {
            let image:UIImage = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.originalImage) as! UIImage
            TZImageManager.default()?.savePhoto(with: image, completion: { (asset, error) in
                tzImagePickerVc?.hideProgressHUD()
                if((error) != nil){
                    print("图片保存失败" + String(error!.localizedDescription))
                }else{
                    let assetModel = TZImageManager.default()?.createModel(with: asset)
                    if (self.allowCropSwitch) { // 允许裁剪,去裁剪
                        let imagePicker = TZImagePickerController.init(cropTypeWith: assetModel?.asset, photo: image, completion: { (cropImage, asset) in
                            self.refreshCollectionViewWithAddedAsset(asset: asset!, image: image)
                        })
                        imagePicker?.allowPickingImage = true;
                        imagePicker?.needCircleCrop = self.needCircleCropSwitch;
                        imagePicker?.circleCropRadius = 100;
                        self.control.present(imagePicker!, animated: true, completion: nil)
                    }else{
                        self.refreshCollectionViewWithAddedAsset(asset: asset!, image: image)

                    }
                }
            })
        }else if(type == "public.movie"){
            let videoUrl:URL? = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.mediaURL) as? URL
            if(videoUrl != nil){
                TZImageManager.default()?.saveVideo(with: videoUrl, completion: { (asset, error) in
                    tzImagePickerVc?.hideProgressHUD()
                    if (!(error != nil)) {
                        let assetModel = TZImageManager.default()?.createModel(with: asset)
                        TZImageManager.default()?.getPhotoWith(asset, completion: { (photo, info, isDegraded) in
                            if (!isDegraded && (photo != nil)) {
                                self.refreshCollectionViewWithAddedAsset(asset: assetModel!.asset, image: photo!)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if(picker.isKind(of: UIImagePickerController.self)){
            picker.dismiss(animated: true, completion: nil)
        }
    }
}


extension PhotoSelect:TZImagePickerControllerDelegate{
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        print("点击了取消")
    }
    // 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
    // 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
    // 如果isSelectOriginalPhoto为YES，表明用户选择了原图
    // 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        selectedPhotos += photos
        selectedAssets += assets
        self.isSelectOriginalPhoto = isSelectOriginalPhoto;
        collectionView?.reloadData()
        self.printAssetsName(assets: assets! as NSArray)
        
        // 2.图片位置信息
        for phAsset in assets {
            let ass:PHAsset = (phAsset as? PHAsset) ?? PHAsset()
            if(ass.isKind(of: PHAsset.self)){
                print(ass.location as Any)
            }
        }
        
        // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
        self.operationQueue = OperationQueue()
        self.operationQueue?.maxConcurrentOperationCount = 1
        
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        selectedPhotos += [coverImage as Any]
        selectedAssets += [asset as Any]
        picker.showProgressHUD()
        
        TZImageManager.default()?.getVideoOutputPath(with: asset, presetName: AVAssetExportPreset640x480, success: { (outputPath) in
            print("视频导出到本地完成,沙盒路径为:" + (outputPath ?? ""))
            ///视频地址回调"
            if((self.delegate != nil) && (self.delegate?.responds(to: #selector(PhotoSelectDelegate.selectVideo(VideoUrl:))))!){
                self.delegate?.selectVideo?(VideoUrl: (outputPath ?? ""))
            }
            picker.hideProgressHUD()
        }, failure: { (errorMessage, error) in
            print("视频导出失败:" + (errorMessage ?? ""))
        })
        collectionView?.reloadData()
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {
        selectedPhotos += [animatedImage as Any]
        selectedAssets += [asset as Any]
        collectionView?.reloadData()
    }
    
    func isAlbumCanSelect(_ albumName: String!, result: PHFetchResult<AnyObject>!) -> Bool {
        return true
    }
    
    func isAssetCanSelect(_ asset: PHAsset!) -> Bool {
        return true
    }
}

///代理PhotoSelectDelegate
@objc protocol PhotoSelectDelegate : NSObjectProtocol{
    /**选择的图片**/
    @objc optional func selectImageArr(imageArr:NSArray)
    
    /**选择的视频地址**/
    @objc optional func selectVideo(VideoUrl:String)
}
