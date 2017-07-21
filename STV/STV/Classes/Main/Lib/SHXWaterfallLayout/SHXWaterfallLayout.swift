//
//  SHXWaterfallLayout.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/22.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol SHXWaterfallLayoutDataSource : class {
    func waterfallLayout(_ layout: SHXWaterfallLayout, itemIndex: Int) -> CGFloat
}

class SHXWaterfallLayout: UICollectionViewFlowLayout {
    
    fileprivate var cols = 2
    
    weak var dataSource : SHXWaterfallLayoutDataSource?
    
    fileprivate lazy var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var maxHeight : CGFloat = self.sectionInset.top + self.sectionInset.bottom
    
    fileprivate lazy var heights :[CGFloat] = Array(repeating: self.sectionInset.top, count:self.cols)
    
}

// MARK: - 准备所有cell的布局
extension SHXWaterfallLayout {
    override func prepare() {
        super.prepare()
        
        // 校验collectionView是否有值
        guard let collectionView = collectionView else { return }
        
        // 获取cell的个数
        let count = collectionView.numberOfItems(inSection: 0)
        
        let itemW = ((collectionView.bounds.size.width - sectionInset.left - sectionInset.right) - (CGFloat(cols)-1)*minimumInteritemSpacing) / CGFloat(cols)
        
        for i in attributes.count..<count {

            let indexPath = IndexPath(item: i, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let itemH = dataSource?.waterfallLayout(self, itemIndex: i) ?? 100

            // 计算x和y
            let minH = (heights.min())!
            let minIndex = heights.index(of: minH)!
            let x = sectionInset.left + (minimumInteritemSpacing + itemW) * CGFloat(minIndex)
            let y = minH;
            
            attribute.frame = CGRect(x: x, y: y, width: itemW, height: itemH)

            attributes.append(attribute)
            
            // 重新计算改变maxIndex位置的高度
            heights[minIndex] = attribute.frame.maxY + minimumInteritemSpacing
        }
        
        maxHeight = heights.max()!
    }
}


// MARK: - 告知系统准备好的布局
extension SHXWaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

// MARK: - 告知系统滚动的范围(contentSize)
extension SHXWaterfallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (collectionView?.bounds.size.width)!, height: maxHeight)
    }
}
