//
//  WHRouter.swift
//  WeiHong
//
//  Created by developeng on 2021/6/1.
//

import Foundation
import UIKit

@objc open class DPRouter: NSObject {
    
    @objc static  func currentVC() -> (UIViewController?) {
        
        // 获取所有连接的场景
        let scenes = UIApplication.shared.connectedScenes
        // 找到当前活动的场景
        let activeScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        // 获取当前活动的窗口
        let window = activeScene?.windows.first { $0.isKeyWindow }
        // 获取根视图控制器
        let rootViewController = window?.rootViewController
        return currentViewController(rootViewController)
    }
        
    @objc static func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }
    
    /// 检查导航栈中是否含有指定类型的视图控制器
    /// 例如： WHRouter.containsVC(WHWebViewController.self)
    static func containsVC<T: UIViewController>(type: T.Type) -> Bool {
        if let vcs = DPRouter.currentVC()?.navigationController?.viewControllers {
            for viewController in vcs {
                if viewController is T {
                    return true
                }
            }
        }
        return false
    }
    
    /// 检查导航栈中是否含有指定名称的视图控制器
    /// 例如： WHRouter.containsVC(NSStringFromClass(WHWebViewController.self))
    static func containsVC(className: String) -> Bool {
        if let vcs = DPRouter.currentVC()?.navigationController?.viewControllers {
            for viewController in vcs {
                if NSStringFromClass(type(of: viewController)) == className {
                    return true
                }
            }
        }
        return false
    }
    
    //返回到指定控制器
    static func jumpToVc(toVC:UIViewController) {
        var targetVC : UIViewController!
        var vcArr:Array<UIViewController> = []
        DPRouter.currentVC()?.navigationController?.viewControllers.forEach({ controller in
            vcArr.append(controller)
            if controller.isKind(of: toVC.classForCoder) {
                targetVC = controller
            }
        })
        if targetVC != nil {
            DPRouter.currentVC()?.navigationController?.popToViewController(targetVC, animated: true)
        }else {
            vcArr.removeLast()
            DPRouter.currentVC()?.navigationController?.setViewControllers(vcArr, animated: false)
            DPRouter.currentVC()?.navigationController?.pushViewController(toVC, animated: true)
        }
    }
}





