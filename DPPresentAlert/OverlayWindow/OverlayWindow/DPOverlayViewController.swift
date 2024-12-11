//
//  DPOverlayViewController.swift
//  DPPresentAlert
//
//  Created by developeng on 2024/12/10.
//

import UIKit

class DPOverlayViewController: UIViewController {
    var hideBlock:(()->Void)?
    // window
    var overlayWindow:UIWindow?

    public var arrowSize: CGSize = CGSize(width: 16, height: 10)
    private var property:OverlayPopupProperty =  OverlayPopupProperty()

    // 底部背景试图
    private var customView: UIView!
    private var customInitHeight: CGFloat = 0
    
    lazy var topView:UIView = {
        let bgV:UIView = UIView()
        bgV.backgroundColor =  UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        tapGesture.delegate = self // 确保设置了代理
        bgV.addGestureRecognizer(tapGesture)
        return bgV
    }()
    
    lazy var arrowView:DPArrowView = {
        let view:DPArrowView = DPArrowView()
        return view
    }()
    
    lazy var bgView:UIView = {
        let bgV:UIView = UIView()
        bgV.backgroundColor =  UIColor.black.alpha(0.3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        tapGesture.delegate = self // 确保设置了代理
        bgV.addGestureRecognizer(tapGesture)
        return bgV
    }()
    
    // 初始化方法，接收一个自定义视图作为参数
    init(customView: UIView,popupProperty: OverlayPopupProperty? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let property = popupProperty {
            self.property = property
        }
        self.customView = customView
        self.customInitHeight = customView.frame.size.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // 设置背景颜色为半透明黑色
        self.view.backgroundColor = UIColor.clear

        self.view.addSubview(self.topView)
        self.view.addSubview(self.arrowView)
        self.view.addSubview(self.bgView)
        self.setInitFrame()
        self.customView.isUserInteractionEnabled = true
        self.customView.clipsToBounds = true
        self.bgView.addSubview(self.customView)
        self.showOverlayWithAnimation()
    }
    
    func setInitFrame() {
        let edgeTop:CGFloat = self.property.topContentEdge.top
        self.topView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: edgeTop)
        self.arrowView.frame = CGRect(x: 0, y: edgeTop, width: ScreenWidth, height: 10)
        self.bgView.frame = CGRect(x: 0, y: edgeTop + 10, width: ScreenWidth, height: ScreenHeight - edgeTop - 10)
        let arrowVertexX = (ScreenWidth - self.arrowSize.width) * self.property.popupArrowVertexScaleX
        arrowView.arrowVertexX = arrowVertexX
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func closeTapped() {
        hideOverlayWithAnimation {[weak self] in
            DPOverlayWindow.removeWindow()
            if self?.hideBlock != nil {
                self?.hideBlock!()
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DPOverlayViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 如果触摸点在 customView 内，则不允许手势识别器接收触摸
        if let touchedView = touch.view, touchedView.isDescendant(of: customView) {
            return false
        }
        return true
    }
}

extension DPOverlayViewController {
    func showOverlayWithAnimation() {
        self.bgView.alpha = 0
        self.customView.frame = CGRectMake(0, 0, ScreenWidth, 0)
        UIView.animate(withDuration: 0.3) { [self] in
            self.bgView.alpha = 1
            self.customView.frame = CGRectMake(0, 0, ScreenWidth, self.customInitHeight)
        }
    }
    
    func hideOverlayWithAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0
            self.customView.frame = CGRectMake(0, 0, ScreenWidth, 0)
        }, completion: { _ in
            completion?()
        })
    }
}


class DPArrowView: UIView {
    
    var arrowVertexX:CGFloat = 0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let path = UIBezierPath()
        let point1 = CGPoint(x: 0, y: 10)
        let point2 = CGPoint(x: arrowVertexX, y: 10)
        let point3 = CGPoint(x: arrowVertexX + 8, y: 0)
        let point4 = CGPoint(x: arrowVertexX + 16, y: 10)
        let point5 = CGPoint(x: ScreenWidth, y: 10)
        let point10 = CGPoint(x: ScreenWidth, y: 11)
        let point6 = CGPoint(x: arrowVertexX + 16, y: 11)
        let point7 = CGPoint(x: arrowVertexX + 8, y: 1)
        let point8 = CGPoint(x: arrowVertexX, y: 11)
        let point9 = CGPoint(x: 0, y: 11)
        let point11 = CGPoint(x: 0, y: 10)
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point10)
        path.addLine(to: point6)
        path.addLine(to: point7)
        path.addLine(to: point8)
        path.addLine(to: point9)
        path.addLine(to: point11)
  
        context.saveGState()

        let shadow = UIColor.hex(0x666666,alpha: 0.3).cgColor
        let shadowOffset = CGSize(width: 0, height: -1)
        let shadowRadius: CGFloat = 2

        context.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadow)
        UIColor.white.setFill()
        path.fill()
        
        context.restoreGState()
    }
}


