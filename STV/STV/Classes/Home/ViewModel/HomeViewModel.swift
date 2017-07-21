//
//  HomeViewModel.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject, Requestable {
    
    var index: Int!
    
    var homeType: HomeType! {
        didSet {
            parameters = ["type" : homeType!.type, "index" : index, "size" : 48]
        }
    }
    
    var URLString: String = "http://qf.56.com/home/v4/moreAnchor.ios"
    var type: MethodType = .get
    var parameters: [String : Any] = [String : Any]()
    
    typealias ResultData = [AnchorModel]
    lazy var data = [AnchorModel]()

}

extension HomeViewModel {
    
    func parseResult(_ result: Any) {
        
        guard let resultDict = result as? [String : Any] else { return }
        guard let messageDict = resultDict["message"] as? [String : Any] else { return }
        guard let dataArr = messageDict["anchors"] as? [[String : Any]] else { return }
        
        for (index, dict) in dataArr.enumerated() {
            let anchor = AnchorModel(dict)
            anchor.isEvenIndex = index % 2 == 0
            data.append(anchor)
        }
    }
    
}
