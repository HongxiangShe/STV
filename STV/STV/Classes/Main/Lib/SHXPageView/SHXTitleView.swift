//
//  SHXTitleView.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/5/10.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol SHXTitleViewDelegate: class {
    func titleView(_ titleView: SHXTitleView, targetIndex: Int)
}

class SHXTitleView: UIView {
    
    weak var delegate: SHXTitleViewDelegate?

    fileprivate var titles: [String]
    fileprivate var style: SHXPageStyle
    fileprivate var currentIndex: Int = 0
    
    // MARK: 懒加载
    fileprivate lazy var normalRGB: (CGFloat, CGFloat, CGFloat) = self.style.normalColor.getRGBValue()
    
    fileprivate lazy var selectRGB: (CGFloat, CGFloat, CGFloat) = self.style.selectColor.getRGBValue()
    
    fileprivate lazy var deltaRGB: (CGFloat, CGFloat, CGFloat) = {
        let deletaR = self.selectRGB.0 - self.normalRGB.0
        let deletaG = self.selectRGB.1 - self.normalRGB.1
        let deletaB = self.selectRGB.2 - self.normalRGB.2
        return (deletaR, deletaG, deletaB)
    }()
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    
    
    init(frame: CGRect, titles: [String], style: SHXPageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SHXTitleView {
    
    fileprivate func setupUI() {
        addSubview(scrollView)
        setupTitleLabels()
        
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    // MARK: 处理coverView
    private func setupCoverView() {
        
        scrollView.insertSubview(coverView, at: 0)
        
        guard let firstLabel = titleLabels.first else {
            return
        }
        
        var coverW: CGFloat = firstLabel.frame.width
        let coverH: CGFloat = style.coverViewHeight
        var coverX: CGFloat = firstLabel.frame.origin.x
        let coverY: CGFloat = (firstLabel.frame.height - coverH) * 0.5
        if (style.isScrollEnabel) {
            coverX -= style.coverViewMargin
            coverW += style.coverViewMargin * 2
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
    }
    
    // MARK: 处理bottomLine
    private func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineHeight
    }
    
    // MARK: 处理label
    private func setupTitleLabels() {
        
        // 创建label
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.isUserInteractionEnabled = true
            titleLabel.tag = i
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = style.titleFont
            titleLabel.textColor = i==0 ? style.selectColor : style.normalColor
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
        }
        
        
        // 计算frame
        let labelH: CGFloat = style.titleHeight
        var labelW: CGFloat = bounds.width / CGFloat(titles.count)
        let labelY: CGFloat = 0
        var labelX: CGFloat = 0
    
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnabel {   // 能滚动
                labelW = (titleLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                labelX = i == 0 ? style.titleMargin : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else {   // 不能滚动
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        // 设置contentSize
        if style.isScrollEnabel {
            guard let titleLabel = titleLabels.last else {
                return
            }
            scrollView.contentSize = CGSize(width: titleLabel.frame.maxX + style.titleMargin, height: 0)
        }
        
        // 设置文字缩放
        if style.isNeedScale {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
    
    }
    
}

// MARK: 事件处理
extension SHXTitleView {
    
    @objc fileprivate func titleLabelClick(_ tagGes: UITapGestureRecognizer) {
        guard let targetLabel = tagGes.view as? UILabel else {
            return
        }
        
        // 如果点击的是被选中的label, 直接返回
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        // 调用代理方法
        delegate?.titleView(self, targetIndex: targetLabel.tag)
        
        adjustTitles(targetLabel)
    }
    
    fileprivate func adjustTitles(_ targetLabel: UILabel) {
        // 改变label的样式, 并且记录tag
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        currentIndex = targetLabel.tag
        
        // 处理滚动
        adjustLabelPosition()
        
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            })
        }
        
        if style.isNeedScale {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        if style.isShowCover {
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x = self.style.isScrollEnabel ? (targetLabel.frame.origin.x - self.style.coverViewMargin) : targetLabel.frame.origin.x
                self.coverView.frame.size.width = self.style.isScrollEnabel ? (targetLabel.frame.width) + self.style.coverViewMargin * 2 : targetLabel.frame.width
            })
        }
    }
    
    fileprivate func adjustLabelPosition() {
        
        guard style.isScrollEnabel else {
            return
        }
        
        let targetLabel = titleLabels[currentIndex]
        // 处理不滚动的情况
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        // 滚动
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
}


// MARK: 暴露给外界直接设置titles的当前位置
extension SHXTitleView {
    
    func setCurrentIndex(_ index: Int) {
        let targetLabel = titleLabels[index]
        adjustTitles(targetLabel)
    }
    
}

// MARK: SHXContentViewDelegate
extension SHXTitleView: SHXContentViewDelegate {
    
    func contentView(_ contentView: SHXContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
    
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        sourceLabel.textColor = UIColor(r:selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r:normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
    
        if style.isNeedScale {
            let deletaScale = style.maxScale - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: self.style.maxScale - deletaScale*progress, y: self.style.maxScale - deletaScale*progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deletaScale*progress, y: 1.0 + deletaScale*progress)
        }
        
        let deletaWidth = targetLabel.frame.width - sourceLabel.frame.width
        let deletaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        if style.isShowBottomLine {
            bottomLine.frame.size.width = deletaWidth * progress + sourceLabel.frame.size.width
            bottomLine.frame.origin.x = deletaX * progress + sourceLabel.frame.origin.x
        }
        
        if style.isShowCover {
            coverView.frame.origin.x = style.isScrollEnabel ? (sourceLabel.frame.origin.x - style.coverViewMargin + deletaX * progress) : (sourceLabel.frame.origin.x + deletaX * progress)
            coverView.frame.size.width = style.isScrollEnabel ? (sourceLabel.frame.width + style.coverViewMargin * 2 + deletaWidth * progress) : (sourceLabel.frame.width + deletaWidth * progress)
        }
        
    }

    func contentView(_ contentView: SHXContentView, didEndScorll inIndex: Int) {
        currentIndex = inIndex
        adjustLabelPosition()
    }
}
