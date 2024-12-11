//
//  DPMainViewController.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/11/14.
//

import UIKit

class DPMainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "主页"

        
        
        let button = UIButton(type: .system)
        button.setTitle("显示sheet弹窗", for: .normal)
        button.addTarget(self, action: #selector(showCustomAlert1), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width:ScreenWidth/3 , height: 50)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        
        let buttonI = UIButton(type: .system)
        buttonI.setTitle("显示alert弹窗", for: .normal)
        buttonI.addTarget(self, action: #selector(showCustomAlert2), for: .touchUpInside)
        buttonI.frame = CGRect(x: ScreenWidth/3, y: 0, width:ScreenWidth/3 , height: 50)
        buttonI.backgroundColor = UIColor.gray
        self.view.addSubview(buttonI)
        
        let buttonII = UIButton(type: .system)
        buttonII.setTitle("下拉框", for: .normal)
        buttonII.addTarget(self, action: #selector(showOverlayWindow(_:)), for: .touchUpInside)
        buttonII.frame = CGRect(x: ScreenWidth/3 * 2, y: 0, width:ScreenWidth/3 , height: 50)
        buttonII.backgroundColor = UIColor.green
        self.view.addSubview(buttonII)
        
    }
    
    @objc func showCustomAlert1() {
        
        let headView:UIView = UIView()
        headView.backgroundColor = UIColor.red
        
        let customView:DPCustomView = DPCustomView()
        customView.backgroundColor = UIColor.blue
        // 第一个弹窗
        _ = DPPresentAlert.sheet(titleView: headView, contentView: customView,contentHeight: 300,titleHeight: 64)
        customView.selectBlock = {
            // 第二个弹窗
            let headViewII:UIView = UIView()
            headViewII.backgroundColor = UIColor.yellow
            let customViewII:DPCustomView = DPCustomView()
            customViewII.backgroundColor = UIColor.black
            let alertVCII = DPPresentAlert.sheet(titleView: headViewII, contentView: customViewII,contentHeight: 500,titleHeight: 100)
            customViewII.selectBlock = {
                // 恢复全屏
                let vc:DPDetailViewController = DPDetailViewController()
                DPPresentAlert.pushNext(alertVC: alertVCII, nextVC:vc)
            }
        }
    }
    @objc func showCustomAlert2() {
        let headView:UIView = UIView()
        headView.backgroundColor = UIColor.red
        
        let customView:DPCustomView = DPCustomView()
        customView.backgroundColor = UIColor.blue
        // 第一个弹窗
        _ = DPPresentAlert.alert(titleView: headView, contentView: customView,contentHeight: 300,titleHeight: 64)
        customView.selectBlock = {
            // 第二个弹窗
            let headViewII:UIView = UIView()
            headViewII.backgroundColor = UIColor.yellow
            let customViewII:DPCustomView = DPCustomView()
            customViewII.backgroundColor = UIColor.black
            let alertVCII = DPPresentAlert.sheet(titleView: headViewII, contentView: customViewII,contentHeight: 500,titleHeight: 100)
            customViewII.selectBlock = {
                // 恢复全屏
                let vc:DPDetailViewController = DPDetailViewController()
                DPPresentAlert.pushNext(alertVC: alertVCII, nextVC:vc)
            }
            
        }
    }
    
    @objc func showOverlayWindow(_ button:UIButton) {
        let vFrame = button.frame
        var arr:Array<WHReportEnumItemModel> = Array()
        
        for i in 0..<8 {
            let model = WHReportEnumItemModel()
            model.name = "标题 \(i)"
            model.subpageData = Array()
            for j in 0..<(6+i) {
                let item = WHReportEnumItemModel()
                item.name = "左侧\(i)右侧 \(j)"
                model.subpageData?.append(item)
            }
            arr.append(model)
        }
        
        let view = OverlayTestView()
        view.itemArray = arr
        
        let top:CGFloat = vFrame.origin.y + vFrame.height + NavAndStatusHeight
        let property:OverlayPopupProperty = OverlayPopupProperty()
        property.topContentEdge = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        property.popupArrowVertexScaleX = 5.0/6.0
        
        
        
        DPOverlayWindow.show(customView: view, popupProperty: property) {[weak view] vc in
            DispatchQueue.main.async {
                view?.didSelectBlock = {
                    let newVC = DPDetailViewController()
                    newVC.view.backgroundColor = .white
                    // 如果当前有导航控制器，则推送新页面
                    if let navController = vc.navigationController {
                        navController.isNavigationBarHidden = false
                        newVC.navigationItem.title = "New Page"
                        navController.pushViewController(newVC, animated: true)
                    } else {
                        // 否则创建一个新的导航控制器并设置为窗口的根视图控制器
                        let navController = UINavigationController(rootViewController: vc)
                        navController.isNavigationBarHidden = false
                        newVC.navigationItem.title = "New Pag"
                        vc.overlayWindow?.rootViewController = navController
                        navController.pushViewController(newVC, animated: true)
                    }
                }
            }
        }
    }
    
}

class DPCustomView: UIView {
    
    var selectBlock:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        let button = UIButton(type: .system)
        button.setTitle("跳转下一页", for: .normal)
        button.addTarget(self, action: #selector(selectTap), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        self.addSubview(button)
        
    }
    
    @objc func selectTap() {
        if self.selectBlock != nil {
            self.selectBlock!()
        }
    }
    
}


