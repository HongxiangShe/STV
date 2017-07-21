//
//  EmotionViewCell.swift
//  STV
//
//  Created by 佘红响 on 2017/7/6.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class EmotionViewCell: UICollectionViewCell {

    @IBOutlet weak var giftImageView: UIImageView!
    
    var emotion: Emotion? {
        didSet {
            giftImageView.image = UIImage(named: emotion!.emotionName)
        }
    }

}
