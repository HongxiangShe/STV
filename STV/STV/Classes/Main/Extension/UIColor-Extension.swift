//
//  UIColor-Extension.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/11.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func getRandomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    convenience init?(hexString: String) {
        // ## # 0x 0X
        
        // 1.判断字符串的长度是否大于等于6
        guard hexString.characters.count >= 6 else {
            return nil
        }
        
        // 2.将字符串转换成大写
        var hexTempString = hexString.uppercased()
        
        // 3.判断字符串是否是 0X/## 开头
        if (hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##")) {
            hexTempString = (hexTempString as NSString).substring(from: 2)
        }
        
        // 4.判断字符串是否是以 # 开头
        if (hexTempString.hasPrefix("#")) {
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        // 5.获取RGB对应的16进制
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        // 6.将16进制转换成数值
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    
}

// MARK: - 从颜色中获取RGB的值
extension UIColor {
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        guard let coms = cgColor.components else {
            fatalError("重大错误!请确定该颜色是通过RGB创建的")
        }
        return (coms[0] * 255, coms[1] * 255, coms[2] * 255)
    }
}
