//
//  SHXGiftContainerView.swift
//  STV
//
//  Created by 佘红响 on 2017/7/11.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class SHXGiftContainerView: UIView {

    fileprivate lazy var channelViews: [SHXGiftChannelView] = [SHXGiftChannelView]()
    fileprivate lazy var cacheGiftModels: [GiftModel] = [GiftModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
}

extension SHXGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建HYGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = 40
        let x : CGFloat = -w
        for i in 0..<2 {
            let y = (h + 10) * CGFloat(i)
            let channelView = SHXGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.finishCallback = { [weak self] (channelView) in
            
                guard let weakSelf = self else { return }
                
                // 1.检查缓存中是否有内容
                guard weakSelf.cacheGiftModels.count != 0 else {
                    return
                }
                
                // 2.取出模型
                let firstGiftModel = weakSelf.cacheGiftModels[0]
                weakSelf.cacheGiftModels.removeFirst()
                
                // 3.取出和giftModel相同模型的个数
                var cacheNumber = 0
                for i in (0..<weakSelf.cacheGiftModels.count).reversed() {
                    let giftModel = weakSelf.cacheGiftModels[i]
                    if giftModel.user.name == firstGiftModel.user.name && giftModel.subject == firstGiftModel.subject {
                        cacheNumber += 1
                        weakSelf.cacheGiftModels.remove(at: i)
                    }
                }
                
                // 4.让闲置的channelView执行缓存中礼物模型的动画
                channelView.cacheNumber = cacheNumber
                channelView.giftModel = firstGiftModel
            }
        }
    }
}

extension SHXGiftContainerView {
    
    func insertGiftModel(giftModel: GiftModel) {
        // 1.判断是否有正在执行动画的, 其用户为同一人且礼物相同的, 通道
        if let channelView = checkSameModelInChannelView(giftModel) {
            channelView.addOnceToCache()
            return
        }
        
        // 2.检查是否有闲置的通道可以用于展示礼物
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        
        // 3.将模型添加到缓存中
        cacheGiftModels.append(giftModel)
    }
    
    
    /// 判断是否有正在执行动画的, 其用户为同一人且礼物相同的, 通道
    fileprivate func checkSameModelInChannelView(_ newModel: GiftModel) -> SHXGiftChannelView? {
        
        for channelView in channelViews {
            if channelView.giftModel?.user.name == newModel.user.name && channelView.giftModel?.subject == newModel.subject && channelView.state != .ending {
                return channelView
            }
        }
        return nil
    }
    
    /// 检查是否有闲置的通道可以用于展示礼物
    fileprivate func checkIdleChannelView() -> SHXGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}
