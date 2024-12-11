//
//  DPNavViewController.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/11/14.
//

import UIKit

class DPNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = UIColor.white
    }
    
    func setNavBarAppearence() {
        
    }
}

extension DPNavViewController{
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if animated {
            let popController = viewControllers.last
            popController?.hidesBottomBarWhenPushed = false
        }
        return super.popToRootViewController(animated: animated)
    }
}

