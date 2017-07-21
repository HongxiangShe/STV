//
//  EmotionViewModel.swift
//  STV
//
//  Created by 佘红响 on 2017/7/6.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class EmotionViewModel {
    
    static let shareInstance: EmotionViewModel = EmotionViewModel()
    lazy var packages: [EmotionPackage] = [EmotionPackage]()
    
    private init() {
        packages.append(EmotionPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmotionPackage(plistName: "QHSohuGifSort.plist"))
    }
}
