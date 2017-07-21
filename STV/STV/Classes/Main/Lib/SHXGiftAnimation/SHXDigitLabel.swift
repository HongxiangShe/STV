//
//  SHXDigitLabel.swift
//  STV
//
//  Created by 佘红响 on 2017/7/11.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class SHXDigitLabel: UILabel {

    override func draw(_ rect: CGRect) {
        
        // 0.记录之前的颜色
        let oldColor = textColor
        
        // 1.获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        // 2.设置画边框的属性
        ctx?.setTextDrawingMode(.stroke)
        ctx?.setLineWidth(5)
        ctx?.setLineJoin(.round)
        textColor = UIColor.orange
        super.draw(rect)
        
        // 3.画出里面的内容
        ctx?.setTextDrawingMode(.fill)
        textColor = oldColor
        super.draw(rect)
    }
    
    func startAnimation(_ completetion: (()->Void)? = nil) {
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            })
            
        }) { (_) in
            completetion?()
        }
    }

}
