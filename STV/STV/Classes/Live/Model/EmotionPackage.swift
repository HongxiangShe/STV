//
//  EmotionPackage.swift
//  STV
//
//  Created by 佘红响 on 2017/7/6.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

class EmotionPackage {
    
    lazy var emotions: [Emotion] = [Emotion]()
    
    init(plistName: String) {
        
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emotions.append(Emotion(emotionName: str))
        }
    }

}
