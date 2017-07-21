//
//  GiftViewModel.swift
//  STV
//
//  Created by 佘红响 on 2017/7/7.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class GiftViewModel: Requestable {
    
    var URLString: String = "http://qf.56.com/pay/v4/giftList.ios"
    var type: MethodType = MethodType.get
    var parameters: [String : Any] = ["type" : 0, "page" : 1, "rows" : 150]
    
    typealias ResultData = [GiftPackage]
    lazy var data = [GiftPackage]()

}

extension GiftViewModel {
    
    func parseResult(_ result: Any) {
        
        guard let resultDict = result as? [String : Any] else { return }
        guard let messageDict = resultDict["message"] as? [String : Any] else { return }
        
        for i in 0..<messageDict.count {
            guard let dict: [String : Any] = messageDict["type\(i+1)"] as? [String : Any] else { return }
            self.data.append(GiftPackage(dict))
        }
        
        self.data = self.data.filter({ $0.t != 0 && $0.t != 1 }).sorted(by: { return $0.t > $1.t })
        
    }
    
}
