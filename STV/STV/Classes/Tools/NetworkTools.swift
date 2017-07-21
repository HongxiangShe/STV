//
//  NetworkTools.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/12.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    
    static let shareInstance: NetworkTools = NetworkTools()
    
    private init() {}
}

extension NetworkTools {
    
    // swift中的闭包有两种：逃逸闭包和非逃逸闭包，前者表示闭包将在函数返回之后执行；而后者则表示在函数返回前，即函数内部执行。
    // @escaping 逃逸闭包, 声明函数时，在闭包参数名前加上@escape，
    // @noescape 非逃逸闭包，从而最大限度进行优化; 访问属性或方法不需要使用self; 不需要担心使用self的引用循环问题; 闭包在函数返回之前执行，即同步执行
    func requestData(_ urlStr: String, _ type : MethodType, _ parameters: [String: Any], _ completion: @escaping (Any) -> Void) {
        
        // (参数列表) -> (返回值)/(void)    闭包格式
        
        let method = type == MethodType.get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(urlStr, method: method, parameters: parameters).responseJSON { (response: DataResponse<Any>) in
            // 1.校验是否有结果
            guard let result = response.result.value else {
                print(response.result.error ?? "没有数据")
                return
            }
            
            // 2.将结果回调出去
            completion(result)
        }
        
    }
}
