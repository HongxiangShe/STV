//
//  GiftPackage.swift
//  STV
//
//  Created by 佘红响 on 2017/7/7.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class GiftPackage: BaseModel {
    
    // 礼物数量
    var t: Int = 0
    // 组标题
    var title: String = ""
    // 礼物模型
    var list : [GiftModel] = [GiftModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            if let listArr = value as? [[String : Any]] {
                for listDict in listArr {
                    list.append(GiftModel(listDict))
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }

}
