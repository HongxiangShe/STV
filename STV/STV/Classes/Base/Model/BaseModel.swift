//
//  BaseModel.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/12.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    override init() {
        super.init()
    }
    
    init(_ dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    // 实现了该方法, 当找不到key的时候程序不至于崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
