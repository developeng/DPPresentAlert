//
//  JHToolsDefine.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 15/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

// MARK: ===================================常量-宏定义============================

// MARK:- 屏幕
/// 当前屏幕状态 高度
public let ScreenHeight = UIScreen.main.bounds.height
/// 当前屏幕状态 宽度
public let ScreenWidth = UIScreen.main.bounds.width

/// 弹窗宽度
public let AlertWidth = 303.auto()

//安全区域
func deviceSafeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 13.0, *) {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: \.isKeyWindow) {
            return keyWindow.safeAreaInsets
        }
    } else {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    return .zero
}

/// 信号栏高度
/// - Returns: 高度
public func StatusBarHeight() ->CGFloat {
    if #available(iOS 13.0, *){
        let window = UIApplication.shared.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }else{
        return UIApplication.shared.statusBarFrame.height
    }
}

/// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度--44
public func NavBarHeight() ->CGFloat {
    return UINavigationController().navigationBar.frame.size.height
}

/// 获取屏幕导航栏+信号栏总高度--64:88
public let NavAndStatusHeight = StatusBarHeight() + NavBarHeight()
/// 获取刘海屏底部home键高度,普通屏为0
public func BottomHomeHeight() ->CGFloat {
    if #available(iOS 11.0, *){
        return UIApplication.shared.windows[0].safeAreaInsets.bottom
    }else{
        return 0
    }
}
/// TabBar高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度
public func TabbarHeight() ->CGFloat {
    return UITabBarController().tabBar.frame.size.height
}
//刘海屏=TabBar高度+Home键高度, 普通屏幕为TabBar高度

public let TabBarHeight = TabbarHeight() + BottomHomeHeight()



/// 判断是否iphoneX 带刘海
public func IsBangs_iPhone() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
    return isX
}

public var isX: Bool {
        var isX = false
        if #available(iOS 11.0, *) {
            let bottom: CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
            isX = bottom > 0.0
        }
        return isX
    }

///判断是否iPad
public let IsIPAD: Bool = (UIDevice.current.userInterfaceIdiom == .pad) ? true: false


// MARK:- 系统版本
public let SystemVersion: String = UIDevice.current.systemVersion

public func Later_iOS11() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return true
}

public func Later_iOS12() -> Bool {
    guard #available(iOS 12.0, *) else {
        return false
    }
    return true
}

public func Later_iOS13() -> Bool {
    guard #available(iOS 13.0, *) else {
        return false
    }
    return true
}

public func Later_iOS14() -> Bool {
    guard #available(iOS 14.0, *) else {
        return false
    }
    return true
}

// MARK:- 字体
/// 系统默认字体
public let Font11 = UIFont.systemFont(ofSize: 11)
/// 系统默认字体
public let Font12 = UIFont.systemFont(ofSize: 12)
/// 系统默认字体
public let Font13 = UIFont.systemFont(ofSize: 13)
/// 系统默认字体
public let Font14 = UIFont.systemFont(ofSize: 14)
/// 系统默认字体
public let Font15 = UIFont.systemFont(ofSize: 15)
/// 系统默认字体
public let Font16 = UIFont.systemFont(ofSize: 16)

///根据屏幕自适应字体参数 16*FontFit
public let FontFit = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375

/// 系统默认字体
public func SystemFont(_ size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size)
}
/// 系统默认字体
public func SystemFontBold(_ size: CGFloat) -> UIFont {
    return .boldSystemFont(ofSize: size)
}
/// 系统默认字体
public func SystemFont(_ size: CGFloat, weight: UIFont.Weight) -> UIFont {
    return .systemFont(ofSize: size, weight: weight)
}

public enum Weight {
    case medium
    case semibold
    case light
    case ultralight
    case regular
    case thin
}
/// pingfang-sc 字体
public func Font(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .regular)
}
/// pingfang-sc 字体
public func FontMedium(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .medium)
}
/// pingfang-sc 字体
public func FontBold(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .semibold)
}
/// pingfang-sc 字体
public func FontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
    var name = ""
    switch weight {
    case .medium:
        name = "PingFangSC-Medium"
    case .semibold:
        name = "PingFangSC-Semibold"
    case .light:
        name = "PingFangSC-Light"
    case .ultralight:
        name = "PingFangSC-Ultralight"
    case .regular:
        name = "PingFangSC-Regular"
    case .thin:
        name = "PingFangSC-Thin"
    }
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}

// MARK:- App信息

/// App 显示名称
public var AppDisplayName: String? {
    return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
}

public var AppName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

/// app 的bundleid
public var AppBundleID: String? {
    return Bundle.main.bundleIdentifier
}

/// build号
public var AppBuildNumber: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
}

/// app版本号
public var AppVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

// MARK:- 打印输出
public func wh_log<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\n<><><><><>-「WH-LOG」-<><><><><>\n\n所在类----- \(fileName)\n所在行----- \(lineNum)\ndevelopeng打印信息----- \n\(message)\n\n<><><><><>-「END」-<><><><><>\n")
    #endif
}

