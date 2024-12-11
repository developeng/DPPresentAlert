//
//  OverlayPopupProperty.swift
//  WeiHong
//
//  Created by developeng on 2024/12/10.
//
// MARK: - 弹窗的相关配置属性

import Foundation
import UIKit

enum WHPopupAnimation {
    // 下拉
    case PullDown
    //
    case Alert
    //
    case Sheet
}

class OverlayPopupProperty: NSObject {
    ///  弹窗动画类型
     var type: WHPopupAnimation = .Alert
    /// 弹窗开始坐标点
     var topContentEdge: UIEdgeInsets = UIEdgeInsets.zero
    /// 弹窗箭头偏移-范围0-1，0=最左 1=最右 0.5=居中
     var popupArrowVertexScaleX: CGFloat = 0.5
   
    public override init() {
        super.init()
    }
}
