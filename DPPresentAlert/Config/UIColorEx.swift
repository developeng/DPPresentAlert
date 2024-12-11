//
//  UIColorEx.swift
//  WeiHong
//
//  Created by 赵朋 on 2021/5/13.
//

import UIKit

public extension UIColor {
    //背景色
    static let backGroundColor:UIColor = .hex(0xf6f6f6)
    //主题色
    static let themeColor:UIColor = .hex(0x5792F9)
    //分割线
    static let lineColor:UIColor = .hex(0xEEEEEE)
    //提示颜色
    static let tipColor:UIColor = .hex(0xF5A623)
    //文字颜色
    static let textMainColor:UIColor = .hex(0x333333)
    static let textNormalColor:UIColor = .hex(0x666666)
    static let textSubColor:UIColor = .hex(0x999999)
    // 橘黄色
    static let orangeColor:UIColor = .hex(0xFD7022)
    


    // MARK: - extension 适配深色模式 浅色模式 非layer
    ///light 浅色模式的颜色（十六进制）
    ///dark   深色模式的颜色（十六进制）为nil时，默认为浅色
    ///return    返回一个颜色（UIColor）
    
    static func hex(_ light:UInt32,dark:UInt32? = nil, alpha:CGFloat = 1.0) -> UIColor{
        
        let dark:UInt32 =  light
        let lightColor = UIColor(red: ((CGFloat)((light & 0xFF0000) >> 16)) / 255.0,
                            green: ((CGFloat)((light & 0xFF00) >> 8)) / 255.0,
                            blue: ((CGFloat)(light & 0xFF)) / 255.0,
                            alpha: alpha)
        let darkColor = UIColor(red: ((CGFloat)((dark & 0xFF0000) >> 16)) / 255.0,
                                      green: ((CGFloat)((dark & 0xFF00) >> 8)) / 255.0,
                                      blue: ((CGFloat)(dark & 0xFF)) / 255.0,
                                      alpha: alpha)
        return hex(light: lightColor, dark: darkColor)
    }
    
    // MARK: - extension 适配深色模式 浅色模式 非layer
    ///light 浅色模式的颜色（十六进制）
    ///dark   深色模式的颜色（十六进制）为nil时，默认为浅色
    ///return    返回一个颜色（UIColor）
    
    static func hex(_ light:String,dark:String? = nil, alpha:CGFloat = 1.0) -> UIColor{
        
        let dark:String = dark ?? light
        let lightColor = UIColor(hex: light, alpha) ?? UIColor.black
        let darkColor =  UIColor(hex: dark, alpha)  ?? UIColor.white
        return hex(light: lightColor, dark: darkColor)
        
    }
    
    // MARK: - extension 适配深色模式 浅色模式 非layer
    ///light  浅色模式的颜色（UIColor）
    ///dark  深色模式的颜色（UIColor）
    ///return    返回一个颜色（UIColor）
   static func hex(light: UIColor,
                   dark: UIColor = UIColor.white)
       -> UIColor {
       if #available(iOS 13.0, *) {
          return UIColor { (traitCollection) -> UIColor in
               if traitCollection.userInterfaceStyle == .dark {
                   return dark
               }else {
                   return light
               }
           }
       } else {
          return light
       }
   }
    
    func alpha( _ alpha : CGFloat = 1.0)  -> UIColor{
        return self.withAlphaComponent(alpha)
    }
    
    // MARK: - 构造函数（十六进制）
     ///hex  颜色（十六进制）
     ///alpha   透明度
    convenience init?(hex : String,
                      _ alpha : CGFloat = 1.0) {
        var cHex = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        guard cHex.count >= 6 else {
            return nil
        }
        if cHex.hasPrefix("0X") {
            cHex = String(cHex[cHex.index(cHex.startIndex, offsetBy: 2)..<cHex.endIndex])
        }
        if cHex.hasPrefix("#") {
            cHex = String(cHex[cHex.index(cHex.startIndex, offsetBy: 1)..<cHex.endIndex])
        }

        var r : UInt64 = 0
        var g : UInt64  = 0
        var b : UInt64  = 0

        let rHex = cHex[cHex.startIndex..<cHex.index(cHex.startIndex, offsetBy: 2)]
        let gHex = cHex[cHex.index(cHex.startIndex, offsetBy: 2)..<cHex.index(cHex.startIndex, offsetBy: 4)]
        let bHex = cHex[cHex.index(cHex.startIndex, offsetBy: 4)..<cHex.index(cHex.startIndex, offsetBy: 6)]

        Scanner(string: String(rHex)).scanHexInt64(&r)
        Scanner(string: String(gHex)).scanHexInt64(&g)
        Scanner(string: String(bHex)).scanHexInt64(&b)

        self.init(red:CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
