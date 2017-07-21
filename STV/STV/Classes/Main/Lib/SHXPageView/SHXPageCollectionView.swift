//
//  HXPageCollectionView.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/23.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol SHXPageCollectionViewDataSource: class {
    
    // 有多少组数据
    func numberOfSectionInPageCollectionView(_ pageCollectionView: SHXPageCollectionView) -> Int
    
    // 每组里面有多少个数组
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, numberOfItemsInSection section: Int) -> Int
    
    // 返回的每个cell
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, _ collectionView: UICollectionView, cellAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    
}

protocol SHXPageCollectionViewDelegate: class {
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class SHXPageCollectionView: UIView {
    
    weak var dataSource : SHXPageCollectionViewDataSource?
    
    weak var delegate : SHXPageCollectionViewDelegate?
    
    var layout: SHXPageCollectionLayout
    
    fileprivate var titles: [String]
    fileprivate var style: SHXPageStyle
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var titleView: SHXTitleView!
    
    // 记录当前组的indexPath
    fileprivate var currentIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, titles: [String], style: SHXPageStyle, layout: SHXPageCollectionLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

// MARK: - 初始化方法
extension SHXPageCollectionView {
    fileprivate func setupUI() {
        
        // 1.titleView
        let titleY = style.isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        let titleView = SHXTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        self.titleView = titleView
        
        // 2.collectionView
        let collectionViewY = style.isTitleInTop ? style.titleHeight : 0
        let collectionViewH =  bounds.height - style.titleHeight - style.pageControlHeight
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: collectionViewH)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        
        // 3.pageControl
        let pageFrame = CGRect(x: 0, y: collectionViewFrame.maxY, width: bounds.width, height: style.pageControlHeight)
        let pageControl = UIPageControl(frame: pageFrame)
        self.pageControl = pageControl
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        
        pageControl.backgroundColor = collectionView.backgroundColor
        
    }
}

// MARK: - 暴露给外部collectionView的注册方法
extension SHXPageCollectionView {
    func registerCell(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension SHXPageCollectionView: UICollectionViewDelegate {
    
    // 有减速的时候
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    // 减速停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewEndScroll() {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        if indexPath.section != currentIndex.section {
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
            
            titleView.setCurrentIndex(indexPath.section)
            
            currentIndex = indexPath
        }
        
        pageControl.currentPage = indexPath.item / (layout.rows * layout.cols)
    }
    
}

// MARK: - UICollectionViewDataSource
extension SHXPageCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if (section == 0) {
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (dataSource?.pageCollectionView(self, collectionView, cellAtIndexPath: indexPath))!
    }
    
}

// MARK: - SHXTitleViewDelegate
extension SHXPageCollectionView: SHXTitleViewDelegate {
    func titleView(_ titleView: SHXTitleView, targetIndex: Int) {
        // 创建indexPath
        let indexPath = IndexPath(item: 0, section: targetIndex)
        
        // 记录当前组的indexPath
        currentIndex = indexPath
        
        // 大约滚动到对应位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        // 设置pageControl的页数
        let sectionNum = dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
        let sectionItemsNum = dataSource?.pageCollectionView(self, numberOfItemsInSection: targetIndex) ?? 0
        pageControl.numberOfPages = (sectionItemsNum - 1) / (layout.cols * layout.rows) + 1
        pageControl.currentPage = 0
        
        // 调整正确位置
        if targetIndex == sectionNum - 1 && sectionItemsNum <= layout.cols * layout.rows {
            return
        }
    
        collectionView.contentOffset.x -= layout.sectionInset.left
    }
}
