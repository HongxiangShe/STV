//
//  SHXPageView.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/10.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class SHXPageView: UIView {
    
    // MARK: 属性
    var titles: [String]
    var style: SHXPageStyle
    var childVcs: [UIViewController]
    var parentVc: UIViewController
    
    // MARK: 构造方法
    init(frame: CGRect, titles: [String], style: SHXPageStyle, childVcs: [UIViewController], parentVc: UIViewController) {
        self.titles = titles
        self.style = style
        self.childVcs = childVcs
        self.parentVc = parentVc
        // 加上这个就不会是titles中label位置改变了
        parentVc.automaticallyAdjustsScrollViewInsets = false
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI界面
extension SHXPageView {
    fileprivate func setupUI() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = SHXTitleView(frame: titleFrame, titles: titles, style: style)
//        titleView.backgroundColor = UIColor.gray
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: titleFrame.width, height: bounds.height - titleFrame.maxY)
        let contentView = SHXContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        titleView.delegate = contentView as SHXTitleViewDelegate
        contentView.delegate = titleView as SHXContentViewDelegate
        
    }
}
