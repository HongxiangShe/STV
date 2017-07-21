//
//  HXPageCollectionLayout.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/23.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class SHXPageCollectionLayout: UICollectionViewLayout {
    
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    var itemMargin: CGFloat = 0
    var lineMargin: CGFloat = 0
    var cols: Int = 4
    var rows: Int = 2
    
    fileprivate lazy var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var totalWidth: CGFloat = 0.0
}

extension SHXPageCollectionLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let sections = collectionView.numberOfSections
        
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - itemMargin*CGFloat(cols-1)) / CGFloat(cols)
        let itemH = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - lineMargin*CGFloat(rows-1)) / CGFloat(rows)
        
        // 之前的所有页数
        var previousNumOfPage = 0
        
        for section in 0..<sections {
            
            let items = collectionView.numberOfItems(inSection: section)
        
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 该组内的页码
                let currentPage = item / (cols * rows)
                // 每一页的item的索引
                let currentIndex = item % (cols * rows)
                // 每一页的col
                let currentCol = currentIndex % cols
                // 每一页的row
                let currentRow = currentIndex / cols
                
                let itemX = CGFloat(previousNumOfPage + currentPage) * collectionView.bounds.width + sectionInset.left + (itemMargin + itemW) * CGFloat(currentCol)
                let itemY = sectionInset.top + CGFloat(currentRow) * (lineMargin + itemH)
                
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                attributes.append(attribute)
            }
            
            previousNumOfPage += (items - 1) / (cols * rows) + 1
        }
        totalWidth = CGFloat(previousNumOfPage) * collectionView.bounds.width
    }
}

extension SHXPageCollectionLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

extension SHXPageCollectionLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: totalWidth, height: 0)
    }
}
