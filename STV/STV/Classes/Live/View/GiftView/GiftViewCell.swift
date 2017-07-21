//
//  GiftViewCell.swift
//  STV
//
//  Created by 佘红响 on 2017/7/7.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class GiftViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var giftModel: GiftModel? {
        didSet {
            iconImageView.setImage(giftModel?.img2, "room_btn_gift")
            subjectLabel.text = giftModel?.subject
            priceLabel.text = "\(giftModel?.coin ?? 0)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 5
        selectedView.layer.masksToBounds = true
        selectedView.layer.borderWidth = 1
        selectedView.layer.borderColor = UIColor.orange.cgColor
        selectedView.backgroundColor = UIColor.clear
        
        selectedBackgroundView = selectedView
    }

}
