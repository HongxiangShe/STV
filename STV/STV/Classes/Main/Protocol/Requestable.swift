//
//  Requestable.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/12.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit
import Alamofire

protocol Requestable {
    
    var URLString: String { get }
    var type: MethodType { get }
    var parameters: [String : Any] { get set }
    
    associatedtype ResultData
    var data: ResultData { get set }
    
    
    func parseResult(_ result: Any)
  
}


extension Requestable {
    
    func requestData(_ completion: @escaping () -> Void) {
        // (参数列表) -> (返回值)/(void)    闭包格式
        let method = type == MethodType.get ? HTTPMethod.get : HTTPMethod.post
        
        HXPrint("method: \(type)" + "\nURLString" + URLString)
        HXPrint("\nparameters: ")
        for (key, value) in parameters {
            HXPrint(" [\(key) : \(value)] ")
        }
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response: DataResponse<Any>) in
            
            // 1.校验是否有结果
            guard let result = response.result.value else {
                print(response.result.error ?? "没有数据")
                return
            }
            
            // 2.解析结果
            self.parseResult(result)
            
            // 3.将结果回调出去
            completion()
        }
        
    }
}
