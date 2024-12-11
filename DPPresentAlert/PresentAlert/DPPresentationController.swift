//
//  WHPresentationController.swift
//  WeiHong
//
//  Created by developeng on 2024/5/9.
//

import UIKit
import SnapKit


fileprivate var viewMinH:CGFloat = (ScreenHeight - StatusBarHeight()) * 0.7
fileprivate var viewMaxH:CGFloat = (ScreenHeight - StatusBarHeight()) * 0.9


enum AlertType {
    case alert
    case sheet
}
// sheet 弹窗
class DPSheetPresentVC: UIPresentationController {
    
    var viewHeight:CGFloat = viewMinH
    
    var contentView:UIView!
    var bgView:UIView!

    override func presentationTransitionWillBegin() {
        
        self.contentView = {
            let view:UIView = UIView(frame: containerView!.bounds)
            view.backgroundColor = UIColor(white: 0, alpha: 0)
            let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:  #selector(dismissAction))
            tap.numberOfTapsRequired = 1
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap)
          
            return view
        }()
        containerView?.addSubview(self.contentView)
        
        self.bgView = {
            let view:UIView = UIView(frame: containerView!.bounds)
            view.isUserInteractionEnabled = false
            return view
        }()
        containerView?.addSubview(self.bgView)
        
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return
        }
        transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in//动画0.4秒
            self.contentView?.backgroundColor = UIColor(white: 0, alpha: 0.4)
        })
        
    }
    
    //呈现动画已结束
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // 如果呈现没有完成，那就移除背景 View，没有完成就是出了错误
        if !completed {
            self.contentView?.removeFromSuperview()
            bgView?.removeFromSuperview()
        }
    }
    
    //消失动画将要开始
    override func dismissalTransitionWillBegin() {
        //背景色变动画，使用present or dismiss默认的动画实现
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return
        }
        transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.contentView?.backgroundColor = UIColor(white: 0, alpha: 0.0)
        })
    }
    
    //消失动画已结束
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.contentView?.removeFromSuperview()
            bgView?.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var viewHeight = self.viewHeight
        if viewHeight < viewMinH {
            viewHeight = viewMinH
        }
        if viewHeight > viewMaxH {
            viewHeight = viewMaxH
        }
        return CGRect(x: 0, y: ScreenHeight-viewHeight, width: ScreenWidth, height: viewHeight)
    }
    
    //当前横竖屏变换时调用，调整自己写的视图，presentedView == presentedViewController.view
    open override func containerViewWillLayoutSubviews() {
        contentView?.frame = containerView!.frame
        bgView?.frame = containerView!.frame
        //当屏幕旋转后presentedView的frame需要自己调整，所以下面一行是必须的
        presentedView?.frame = frameOfPresentedViewInContainerView  //这行是必须的
    }
    
    @objc func dismissAction() {
        presentedViewController.dismiss(animated: true)
    }
}

// alert 弹窗
class DPAlertPresentVC: UIPresentationController {

    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerBounds = containerView?.bounds ?? UIScreen.main.bounds
        let width = containerBounds.width * 0.8
        let height = containerBounds.height * 0.7
        let x = (containerBounds.width - width) / 2
        let y = (containerBounds.height - height) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        // 添加遮罩层
        containerView.addSubview(dimmingView)
        dimmingView.frame = containerView.bounds
        
        // 动画开始前的初始状态
        dimmingView.alpha = 0.0
        presentedView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        presentedView?.alpha = 0.0
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
                self.presentedView?.transform = .identity
                self.presentedView?.alpha = 1.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 1.0
            presentedView?.transform = .identity
            presentedView?.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
                self.presentedView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.presentedView?.alpha = 0.0
            }, completion: { _ in
                self.dimmingView.removeFromSuperview()
            })
        } else {
            dimmingView.alpha = 0.0
            presentedView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            presentedView?.alpha = 0.0
            dimmingView.removeFromSuperview()
        }
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}


// 弹窗试图
class DPPresentationController: UIViewController, UIViewControllerTransitioningDelegate {
    private var customTitleView:UIView?
    private var customView:UIView!
    private var customBottomView:UIView?
    private var customViewHeight:CGFloat = 0
    private var customTitleHeight:CGFloat = 0
    private var customBottomHeight:CGFloat = 44.0
    private var defaultBottomView:DPSheetBottomView = DPSheetBottomView()
    private var alertType:AlertType = .sheet
    
    init(type:AlertType,titleView:UIView? = nil, contentView:UIView?,bottomView:UIView? = nil,contentHeight:CGFloat = 0,titleHeight:CGFloat = 0,bottomHeight:CGFloat = 0) {
        super.init(nibName: nil, bundle: nil)
        //自定义呈现，这两个操作必须放在init方法中
        modalPresentationStyle = .custom  //这个很重要
        transitioningDelegate = self
        self.alertType = type
        self.customTitleView = titleView
        self.customView = contentView
        self.customBottomView = bottomView
        self.customViewHeight = contentHeight
        self.customTitleHeight = titleHeight
        self.customBottomHeight = bottomHeight == 0 ? 44.0 : bottomHeight
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let maskPath = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = maskPath.cgPath
        self.view.layer.mask = maskLayer
        self.view.backgroundColor = .white
    }
    func setupUI() {
        var topConstraintItem = self.view.snp.top
        var bottomConstraintItem = self.view.snp.bottom
        
        if let titleView = self.customTitleView {
            self.view.addSubview(titleView)
            titleView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(customTitleHeight).priority(.high)
            }
            topConstraintItem = self.customTitleView!.snp.bottom
        }
        
        if let bottomView = self.customBottomView {
            self.view.addSubview(bottomView)
            bottomView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-BottomHomeHeight())
                make.height.equalTo(customBottomHeight).priority(.high)
            }
            bottomConstraintItem = self.customBottomView!.snp.top
        } else {
            self.defaultBottomView.btnClickBlock = {[weak self] in
                self?.hide()
            }
            self.view.addSubview(self.defaultBottomView)
            self.defaultBottomView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-BottomHomeHeight())
                make.height.equalTo(customBottomHeight).priority(.high)
            }
            bottomConstraintItem = self.defaultBottomView.snp.top
        }
        self.view.addSubview(self.customView)
        self.customView.snp.makeConstraints { make in
            make.top.equalTo(topConstraintItem)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomConstraintItem)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hide() {
        dismiss(animated: true)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if self.alertType == .alert  {
            let pc = DPAlertPresentVC(presentedViewController: presented, presenting: presenting)
            return pc
        }
        let pc = DPSheetPresentVC(presentedViewController: presented, presenting: presenting)
        pc.viewHeight = (self.customViewHeight + self.customTitleHeight + self.customBottomHeight)
        return pc
    }
}

// 新根视图
class DPRedirectController: UIViewController, UINavigationControllerDelegate {
    
    var isPushEnter:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPushEnter = true
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isPushEnter {
            self.dismiss(animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isPushEnter = false
    }
}

// 弹窗底部UI
class DPSheetBottomView: UIView {
    
    var btnClickBlock:(() -> Void)?
    var btnTitle:String?{
        didSet {
            guard let btnTitle = btnTitle else {
                return
            }
            self.bottomBtn.setTitle(btnTitle, for: .normal)
        }
    }
    
    private var bottomBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        self.backgroundColor = .white
        self.bottomBtn = {
            let button = UIButton()
            button.setTitle("返 回", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.layer.cornerRadius = 4
            button.layer.backgroundColor =  UIColor.blue.cgColor
            button.addTarget(self, action: #selector(bottomBtnClick), for: .touchUpInside)
            return button
        }()
        self.addSubview(self.bottomBtn)
        
        self.bottomBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(36)
        }
    }
    
    @objc func bottomBtnClick() {
        if self.btnClickBlock != nil {
            self.btnClickBlock!()
        }
    }
}


