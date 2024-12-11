//
//  DPDetailViewController.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/11/14.
//

import UIKit

class DPDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        self.navigationItem.title = "详情"
        
        let button = UIButton(type: .system)
        button.setTitle("返回", for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        self.view.addSubview(button)
        
        let buttonI = UIButton(type: .system)
        buttonI.setTitle("下一页", for: .normal)
        buttonI.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        buttonI.frame = CGRect(x: 50, y: 200, width: 200, height: 50)
        self.view.addSubview(buttonI)
        
        let buttonII = UIButton(type: .system)
        buttonII.setTitle("返回到跟视图", for: .normal)
        buttonII.addTarget(self, action: #selector(backRootPage), for: .touchUpInside)
        buttonII.frame = CGRect(x: 50, y: 300, width: 200, height: 50)
        self.view.addSubview(buttonII)
    }
    
    @objc func back() {
        self.dismiss(animated: true)
    }
    
    @objc func nextPage() {
        let vc:DPMineViewController = DPMineViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backRootPage() {
        self.resetToInitialViewController()
    }

    func getCurrentSceneAndWindow() -> (UIWindowScene?, UIWindow?) {
        let scenes = UIApplication.shared.connectedScenes
        let activeScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = activeScene?.windows.first { $0.isKeyWindow }
        return (activeScene, window)
    }

    func resetToInitialViewController() {
        let (_, window) = getCurrentSceneAndWindow()
        
        if let window = window {
            let tabbarVC = DPTabBarController() // 替换为你的初始视图控制器
            window.rootViewController = tabbarVC
            window.makeKeyAndVisible()
        }
    }
}
