//
//  DPPresentAlert.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/11/14.
//

import UIKit

class DPPresentAlert: NSObject {
    
    // 跳转页面可保留弹窗样式
    static func alert(titleView:UIView? = nil, contentView:UIView?,bottomView:UIView? = nil,contentHeight:CGFloat = 0,titleHeight:CGFloat = 0,bottomHeight:CGFloat = 0) -> UIViewController {
        
        let modalViewController = DPPresentationController(type: .alert,titleView: titleView, contentView: contentView,bottomView: bottomView,contentHeight: contentHeight, titleHeight: titleHeight,bottomHeight: bottomHeight)
        DPRouter.currentVC()?.present(modalViewController, animated: true, completion: nil)
        return modalViewController
    }
    
    // 跳转页面可保留弹窗样式
    static func sheet(titleView:UIView? = nil, contentView:UIView?,bottomView:UIView? = nil,contentHeight:CGFloat = 0,titleHeight:CGFloat = 0,bottomHeight:CGFloat = 0) -> UIViewController {
        
        let modalViewController = DPPresentationController(type: .sheet,titleView: titleView, contentView: contentView,bottomView: bottomView,contentHeight: contentHeight, titleHeight: titleHeight,bottomHeight: bottomHeight)
        DPRouter.currentVC()?.present(modalViewController, animated: true, completion: nil)
        return modalViewController
    }
    
    static func pushNext(alertVC:UIViewController, nextVC:UIViewController) {
        let nav:DPNavViewController = DPNavViewController.init(rootViewController: nextVC)
        nav.modalPresentationStyle = .fullScreen
        // 此步的作用是=>恢复全屏并push新页面
        alertVC.present(nav, animated: false) {
            //            nav.pushViewController(nextVC, animated: true)
        }
    }
}
