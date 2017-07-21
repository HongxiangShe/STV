//
//  HomeViewController.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension HomeViewController {
    
    fileprivate func setupUI() {
        setupNavigationBar()
        setupContentView()
    }
    
    fileprivate func setupNavigationBar() {
        
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        searchBar.placeholder = "主播昵称/房间号/链接";
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        
        let searchField = searchBar.value(forKey: "_searchField") as! UITextField
        searchField.textColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    fileprivate func setupContentView() {
        automaticallyAdjustsScrollViewInsets = false;
        
        let typeArr = loadTypeDatas()
        
        var style = SHXPageStyle()
        style.isShowCover = true
        style.isScrollEnabel = true
        style.normalColor = UIColor(r: 40, g: 40, b: 40)
        
        let frame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - style.titleHeight)
        
        /*
        let titles = typeArr.map { (type: HomeType) -> String in
            return type.title
        }
        */
        let titles = typeArr.map({ $0.title })
        
        var childVcs = [AnchorViewController]()
        for type in typeArr {
            let child = AnchorViewController()
            child.homeType = type
            childVcs.append(child)
        }
        
        let pageView = SHXPageView(frame: frame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    // 从plist中加载数据
    fileprivate func loadTypeDatas() -> [HomeType] {
        
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let arr = NSArray(contentsOfFile: path) as! [[String : Any]]
        
        var typeArr = [HomeType]()
        for dict in arr {
            typeArr.append(HomeType(dict))
        }
        
        return typeArr
    }
    
}

extension HomeViewController {
    
    @objc fileprivate func collectItemClick() {
        HXPrint("点击了收藏按钮")
    }
    
    
}
