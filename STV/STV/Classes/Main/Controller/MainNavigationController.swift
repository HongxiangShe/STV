//
//  MainNavigationController.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, UIGestureRecognizerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let target = interactivePopGestureRecognizer?.delegate
        let action = Selector(("handleNavigationTransition:"))
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        panGes.delegate = self
        view.addGestureRecognizer(panGes)
        
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // 判断何时启用手势(当非导航控制器的根控制器时启用interactivePopGestureRecognizer手势)
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }

}
