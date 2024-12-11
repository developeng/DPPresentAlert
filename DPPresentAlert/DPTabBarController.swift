//
//  DPTabBarController.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/11/14.
//
import UIKit

class DPTabBarController: UITabBarController,UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customIrregularityStyle()
    }
        
    // 加载底部tabbar样式
    func customIrregularityStyle() {
        let titleArr:Array = ["主页","个人中心"]
        let imageNamesArr:Array = ["tabbar_main", "tabbar_mine"]
        let selImageNamesArr:Array = ["tabbar_main_sel", "tabbar_mine_sel"]
        let VCArr:Array = [DPMainViewController(), DPMineViewController()]
        
        for (index, value) in titleArr.enumerated() {
            addChildController(ChildController: VCArr[index],
                               Title: value,
                               DefaultImage: UIImage(named: imageNamesArr[index])!,
                               SelectedImage: UIImage(named: selImageNamesArr[index])!,tag: index)
            
        }
                
        self.delegate = self
        self.tabBar.tintColor = .blue
        self.selectedIndex = 0
        self.tabBar.isTranslucent = true
        self.edgesForExtendedLayout = .init(rawValue: 0)
        
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    func addChildController(ChildController child:UIViewController,Title title:String,DefaultImage defaultImage:UIImage,SelectedImage selectedImage:UIImage,tag:Int) {
        
        child.tabBarItem = UITabBarItem.init(title: title, image: defaultImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysOriginal))
        child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.blue], for: .selected)
        child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        child.tabBarItem.tag = tag
        child.hidesBottomBarWhenPushed = false
        let nav = DPNavViewController(rootViewController: child)
        nav.navigationBar.isTranslucent = false
        nav.navigationItem.title = ""
        self.addChild(nav)
    }
}
