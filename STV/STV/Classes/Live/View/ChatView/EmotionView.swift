//
//  EmotionView.swift
//  STV
//
//  Created by 佘红响 on 2017/7/6.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

private let CELL_ID = "EMOTIONVIEW_CELL_ID"

class EmotionView: UIView {
    
    var emotionClickCallback: ((Emotion)->Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        
        // style
        var pageStyle = SHXPageStyle()
        pageStyle.isShowBottomLine = true
        pageStyle.isTitleInTop = false
        // layout
        let layout = SHXPageCollectionLayout()
        layout.rows = 3
        layout.cols = 7
        layout.itemMargin = 0
        layout.lineMargin = 0
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        // pageCollectionView
        let pageCollectionView = SHXPageCollectionView(frame: bounds, titles: ["普通", "粉丝专属"], style: pageStyle, layout: layout)
        addSubview(pageCollectionView)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.registerNib(UINib(nibName: "EmotionViewCell", bundle: nil), forCellWithReuseIdentifier: CELL_ID)
    }
    
}

extension EmotionView: SHXPageCollectionViewDataSource, SHXPageCollectionViewDelegate {
    // 有多少组数据
    func numberOfSectionInPageCollectionView(_ pageCollectionView: SHXPageCollectionView) -> Int {
        return EmotionViewModel.shareInstance.packages.count
    }
    
    // 每组里面有多少个数组
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmotionViewModel.shareInstance.packages[section].emotions.count
    }
    
    // 返回的每个cell
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, _ collectionView: UICollectionView, cellAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmotionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! EmotionViewCell
        cell.emotion = EmotionViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmotionViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        if let emotionClickCallback = emotionClickCallback {
            emotionClickCallback(emoticon)
        }
        
    }
}
