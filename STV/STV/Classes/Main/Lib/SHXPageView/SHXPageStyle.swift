//
//  SHXPageStyle.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/10.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

struct SHXPageStyle {
    
    var isTitleInTop: Bool = true                // title是否在顶部,否则底部
    var titleHeight: CGFloat = 44                // title控件的高度
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14)      // title的字体
    var normalColor: UIColor = UIColor(r: 255, g: 255, b: 255) // title的未选中的颜色
    var selectColor: UIColor = UIColor(r: 255, g: 127, b: 0)   // title的选中的颜色
    var isScrollEnabel: Bool = false                           // title控件上是否可以滚动
    var titleMargin: CGFloat = 20                              // 每个title的间隔
    
    var pageControlHeight: CGFloat = 20            // pageControl的高度
    
    
    var isShowBottomLine: Bool = true              // 是否显示下划线
    var bottomLineColor: UIColor = UIColor.orange  // 下划线的颜色
    var bottomLineHeight: CGFloat = 2              // 下划线的高度
    
    
    var isNeedScale: Bool = false
    var maxScale: CGFloat = 1.2
    
    var isShowCover: Bool = false                  // 是否显示遮盖
    var coverViewColor: UIColor = UIColor.black    // 遮盖的颜色
    var coverViewAlpha: CGFloat = 0.3              // 遮盖的透明度
    var coverViewHeight: CGFloat = 25              // 遮盖的高度
    var coverViewRadius: CGFloat = 12              // 遮盖的角弧度
    var coverViewMargin: CGFloat = 8               // 遮盖的margin
}
