//
//  SHXGiftChannelView.swift
//  STV
//
//  Created by 佘红响 on 2017/7/11.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

enum ChannerlViewState {
    case idle
    case animating
    case endWating
    case ending
}

class SHXGiftChannelView: UIView, Nibloadable {

    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: SHXDigitLabel!
    
    var cacheNumber: Int = 0
    var state : ChannerlViewState = .idle
    var finishCallback: ((SHXGiftChannelView)->Void)?
    fileprivate var currentNumber: Int = 0
    
    
    var giftModel: GiftModel? {
        didSet {
            
            // 1.校验模型是否有值
            guard let giftModel = giftModel else { return }
            
            // 2.将giftModel中属性设置到控件中
//            iconImageView.setImage(giftModel.user., nil)
            senderLabel.text = giftModel.user.name
            giftDescLabel.text = "送出礼物【\(giftModel.subject)】"
            giftImageView.setImage(giftModel.gUrl, "room_btn_gift")
            
            // 3.将channelView展示出来
            performShowAnimating()
            
        }
    }

}

extension SHXGiftChannelView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.backgroundColor = UIColor(r: 26, g: 26, b: 26)
        bgView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.orange.cgColor
    }
    
}

extension SHXGiftChannelView {
    func addOnceToCache() {
        if state == .endWating {
            state = .animating
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            performDigitAnimating()
        } else {
            cacheNumber += 1
        }
    }
}

extension SHXGiftChannelView {
    
    fileprivate func performShowAnimating() {
        state = .animating
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.frame.origin.x = 0
            self.alpha = 1.0
        }) { (_) in
            self.performDigitAnimating()
        }
    }
    
    fileprivate func performDigitAnimating() {
        // 1.将digitLabel的alpha值设置为1
        digitLabel.alpha = 1.0
        
        // 2.设置digitLabel上面显示的数字
        currentNumber += 1
        digitLabel.text = " x\(currentNumber)"
        
        digitLabel.startAnimation { 
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimating()
            } else {
                self.state = .endWating
                self.perform(#selector(self.performEndAnimating), with: self, afterDelay: 3.0)
            }
        }
    }
    
    @objc fileprivate func performEndAnimating() {
        state = .ending
        UIView.animate(withDuration: 1, animations: { 
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0
        }) { (_)  in
            self.state = .idle
            self.digitLabel.alpha = 0
            self.currentNumber = 0
            self.cacheNumber = 0
            self.giftModel = nil
            self.frame.origin.x = -self.frame.width
            
            self.finishCallback?(self)
        }
    }
}
