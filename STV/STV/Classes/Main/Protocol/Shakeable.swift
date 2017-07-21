//
//  Shakeable.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/5.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol Shakeable {
    
}

extension Shakeable where Self: UIView {
    
    func shake() {
        // 创建动画
        let shakeAni = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        // 给动画设置属性
        shakeAni.values = [-8, 0, 8, 0]
        shakeAni.repeatCount = 5
        shakeAni.duration = 0.05
        
        // 将动画添加到layer中
        layer.add(shakeAni, forKey: nil)
    }
    
}
