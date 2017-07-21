//
//  KingfisherExtension.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

import Kingfisher

extension UIImageView {
    
    func setImage(_ urlString: String?, _ placeHolderName: String?) {
        
        guard let urlStr = urlString else {
            return
        }
        
        var image: UIImage? = nil
        if let placeHN = placeHolderName {
            image = UIImage(named: placeHN)
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        kf.setImage(with: url, placeholder :image)
    }
    
    
}
