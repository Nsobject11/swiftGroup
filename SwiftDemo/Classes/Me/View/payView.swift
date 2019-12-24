//
//  payView.swift
//  SwiftDemo
//
//  Created by john on 2019/12/4.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
typealias ThridPayClick = (_ paySuccess:Int) -> Void
class payView: NSObject {
    static var ThridBlock:ThridPayClick?
    static func payBlock(block:@escaping ThridPayClick){
        payView.ThridBlock = block
    }
}
