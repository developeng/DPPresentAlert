//
//  WHReportEnumItemModel.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/12/10.
//

import UIKit

class WHReportEnumItemModel: NSObject {
    //功能编码
    var code:String?
    //功能名称
    var name:String?
    //跳转地址
    var url:String?
    //排序
    var sortNo:String?
    //子数据list
    var subpageData:Array<WHReportEnumItemModel>?
    //是否选中
    var isSel:Bool = false
    required override init() {}
}
