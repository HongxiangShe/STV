//
//  AppDelegate.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }


}

//// MARK: - 全局打印函数
//func HXPrint<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
//    
//    #if DEBUGSWIFT
//        print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息\(message)");
//    #endif
//}

// MARK: - 全局打印函数
func HXPrint<T>(_ message: T){
    
    #if DEBUGSWIFT
        print("\(message)");
    #endif
}
