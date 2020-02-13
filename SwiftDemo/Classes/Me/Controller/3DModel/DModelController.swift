//
//  DModelController.swift
//  SwiftDemo
//
//  Created by john on 2020/1/19.
//  Copyright © 2020 qt. All rights reserved.
//

import UIKit
import SceneKit
class DModelController: BaseViewController {
    var scnView: SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CommintInitUI()
    }
    //初始化UI
    func CommintInitUI() {
        let viewLeft: UIView = UIView()
        viewLeft.backgroundColor = .cyan
        view.addSubview(viewLeft)
        let viewRight: UIView = UIView()
        viewRight.backgroundColor = .grayColor
        view.addSubview(viewRight)
        viewLeft.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        viewRight.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(viewLeft)
            make.left.equalTo(viewLeft.snp_right)
            make.right.equalToSuperview()
        }
        
        let btnPurple = UIButton()
        btnPurple.backgroundColor = .red
        btnPurple.setTitle("紫色衣服", for: .normal)
        btnPurple.addTarget(self, action: #selector(purpleClcik), for: .touchUpInside)
        viewLeft.addSubview(btnPurple)
        let btnRed = UIButton()
        btnRed.setTitle("黑色衣服", for: .normal)
        btnRed.backgroundColor = .red
        btnRed.addTarget(self, action: #selector(redClick), for: .touchUpInside)
        viewLeft.addSubview(btnRed)
        btnPurple.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(80)
        }
        btnRed.snp.makeConstraints { (make) in
            make.top.equalTo(btnPurple.snp_bottom).offset(10)
            make.left.right.height.equalTo(btnPurple)
        }
        
        guard let urlPath = Bundle.main.url(forResource: "skinning", withExtension: ".dae") else { return }
        let sceneSource = SCNSceneSource.init(url: urlPath, options: nil)
        scnView = SCNView()
        scnView.backgroundColor = .white
        scnView.allowsCameraControl = true
        scnView.scene = sceneSource?.scene(options: nil, statusHandler: nil)
        viewRight.addSubview(scnView)
        scnView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 绕 y轴 一直旋转
        let node: SCNNode = (scnView.scene?.rootNode.childNodes.first)!
//        node.transform = SCNMatrix4MakeScale(1, 1, 1)
//        let action: SCNAction = SCNAction.repeat(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1), count: 0)
//        node.runAction(action)
        
        let cameranode = SCNNode()
        cameranode.camera = SCNCamera()
        cameranode.camera?.automaticallyAdjustsZRange = true
        cameranode.position = SCNVector3Make(0, 0, 0)
        scnView.scene?.rootNode.addChildNode(cameranode)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tabClici(tap:)))
        scnView.addGestureRecognizer(tap)
    }
    
    @objc func tabClici(tap: UITapGestureRecognizer)  {
        let projectedOrigin = scnView.projectPoint(SCNVector3Zero)
        let vp: CGPoint = tap.location(in: scnView)
        let vpWithZ: SCNVector3 = SCNVector3Make(Float(vp.x), Float(vp.y), projectedOrigin.z)
        let worldPoint: SCNVector3 = scnView.unprojectPoint(vpWithZ)
        print("x：\(worldPoint.x)\ny：\(worldPoint.y)\nz：\(worldPoint.z)")
    }
    
    @objc func purpleClcik() {
        let shirtNode = scnView.scene?.rootNode.childNode(withName: "shirt", recursively: true)
        shirtNode?.geometry?.firstMaterial?.diffuse.contents = "export_0_texture19.png"
    }
    
    @objc func redClick() {
         let shirtNode = scnView.scene?.rootNode.childNode(withName: "shirt", recursively: true)
        shirtNode?.geometry?.firstMaterial?.diffuse.contents = "export_0_texture22.png"
    }
}
