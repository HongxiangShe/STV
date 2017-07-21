//
//  Nibloadable.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/5.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol Nibloadable {
    
}

// 表明该协议只能被UIView实现
extension Nibloadable where Self: UIView {

    // 协议,结构体都用static
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        
//        let nib = nibname == nil ? "\(self)" : nibname!
        let nib = nibname ?? "\(self)";
        
        return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
    }
    
}
