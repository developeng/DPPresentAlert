//
//  DPOverlayWindow.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/12/10.
//

import UIKit

class DPOverlayWindow: NSObject {
    // 保存对新窗口的引用
    private static var windowsArr: Array<UIWindow> = Array()
    
    static func removeWindow() {
        if let window = windowsArr.last {
            window.isHidden = true
            window.removeFromSuperview()
            windowsArr.removeLast()
        }
    }
    // 显示弹窗
    static func show(customView:UIView, popupProperty:OverlayPopupProperty? = nil, block:((_ vc:DPOverlayViewController)->Void)? = nil) {
        let overlayWindow:UIWindow
        // 获取当前的应用场景
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            // 创建一个新的 UIWindow，关联到当前的 UIWindowScene (采用 UIWindowScene)
            overlayWindow = UIWindow(windowScene: windowScene)
        } else {
            // 创建一个新的 UIWindow （未采用UIWindowScene）
            overlayWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        // 设置 windowLevel 为 .alert 或更高，以确保它位于所有其他窗口之上
        overlayWindow.windowLevel = UIWindow.Level.statusBar + 1
        overlayWindow.isHidden = false
        // 创建一个新的 ViewController 实例作为根视图控制器
        let overlayVC = DPOverlayViewController.init(customView: customView, popupProperty: popupProperty)
        overlayVC.overlayWindow = overlayWindow // 保存对窗口的引用
        // 如果没有现有的导航控制器，则包装在一个新的导航控制器中
        let navController = UINavigationController(rootViewController: overlayVC)
        // 设置新的窗口的 rootViewController
        overlayWindow.rootViewController = navController
        // 让新的窗口可见
        overlayWindow.makeKeyAndVisible()
        
        if block != nil {
            block!(overlayVC)
        }
        // 保存对新窗口的引用，以便稍后可以移除它
        windowsArr.append(overlayWindow)
    }
    // 移除弹窗
    static func hide(_ type:String,windowKey:String) {
        if let window = windowsArr.last {
            if let nav = window.rootViewController as? UINavigationController {
                if let rootVC = nav.viewControllers.first as? DPOverlayViewController {
                    rootVC.closeTapped()
                }
                return
            }
        } else {
            self.removeWindow()
        }
    }
}


