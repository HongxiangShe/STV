//
//  Flashable.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/5.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol Flashable {
    
}


extension Flashable where Self: UIView {
    
    func flash() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.alpha = 1.0
        }) { (isFinished) in
            UIView.animate(withDuration: 0.25, delay: 2.0, options: [], animations: { 
                self.alpha = 0.0
            }, completion: nil)
        }
    }
    
}
