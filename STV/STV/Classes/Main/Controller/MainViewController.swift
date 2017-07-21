//
//  MainViewController.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        addChildVC("Home")
        addChildVC("Rank")
        addChildVC("Discover")
        addChildVC("Profile")
    }

    fileprivate func addChildVC(_ storyName: String) {
        let vc = UIStoryboard.init(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }
    
}
