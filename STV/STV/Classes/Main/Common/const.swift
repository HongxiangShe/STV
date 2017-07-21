//
//  const.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

let kNavigationBarH : CGFloat = 44
let kStatusBarH : CGFloat = 20
