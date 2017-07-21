//
//  GiftModel.swift
//  STV
//
//  Created by 佘红响 on 2017/7/7.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class GiftModel: BaseModel {
    
    var user: User = User("")
    
    /// 图片
    var img2: String = ""
    
    /// gif图片
    var gUrl: String = ""
    
    /// 价格
    var coin: Int = 0
    
    /// 标题
    var subject: String = "" {
        didSet {
            if subject.contains("有声") {
                subject = subject.replacingOccurrences(of: "有声", with: "")
            }
        }
    }

}
