//
//  SHXContentView.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/10.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

private let kContentCellId = "kContentCellId"

protocol SHXContentViewDelegate: class {
    
    func contentView(_ contentView: SHXContentView, didEndScorll inIndex: Int)
    
    func contentView(_ contentView: SHXContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class SHXContentView: UIView {

    weak var delegate: SHXContentViewDelegate?
    
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var startOffestX: CGFloat = 0
    fileprivate var isForbidDelegate: Bool = false
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:kContentCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SHXContentView {
    fileprivate func setupUI() {
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        addSubview(collectionView)
    }
}

extension SHXContentView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.isScrollEnabled = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 开始调用代理方法
        isForbidDelegate = false
        startOffestX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffestX = scrollView.contentOffset.x
        
        // 判断最终有没有进行滑动
        guard contentOffestX != startOffestX && !isForbidDelegate else {
            return
        }
        
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        var progress: CGFloat = 0
        
        
        let contentWidth = scrollView.bounds.width
        if contentOffestX > startOffestX {  // 左滑动
            sourceIndex = Int(contentOffestX / contentWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            progress = (contentOffestX - startOffestX)/contentWidth
            if (contentOffestX - startOffestX) == contentWidth {
                targetIndex = sourceIndex
            }
        } else {    // 右滑动
            targetIndex = Int(contentOffestX/contentWidth)
            sourceIndex = targetIndex + 1
            progress = (startOffestX - contentOffestX)/contentWidth
        }
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    private func scrollViewDidEndScroll() {
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(self, didEndScorll: index)
        
        collectionView.isScrollEnabled = false
    }
}

extension SHXContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.contentView.addSubview(childVcs[indexPath.item].view)
        
        return cell
    }
}

extension SHXContentView: SHXTitleViewDelegate {
    
    func titleView(_ titleView: SHXTitleView, targetIndex: Int) {
        // 禁止调用代理方法
        isForbidDelegate = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
}
