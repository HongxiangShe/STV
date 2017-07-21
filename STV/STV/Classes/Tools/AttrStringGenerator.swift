//
//  AttrStringGenerator.swift
//  STV
//
//  Created by 佘红响 on 2017/7/10.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit
import Kingfisher

class AttrStringGenerator: NSObject {
    
}

extension AttrStringGenerator {
    
    class func generateJoinLeaveRoom(_ username: String, _ isJoin: Bool) -> NSAttributedString {
        let roomString = "\(username) " + (isJoin ? "进入房间" : "离开房间")
        let roomMAttr = NSMutableAttributedString(string: roomString)
        roomMAttr.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: NSRange(location:0 , length: username.characters.count))
        return roomMAttr
    }
    
    class func generateTextMessage(_ username: String, message: String) -> NSAttributedString {
        
        // 1.获取整个字符串
        let chatMessage = "\(username): \(message)"
        
        // 2.根据整个字符串创建NSMutableAttributedString
        let chatMessageMstr = NSMutableAttributedString(string: chatMessage)
        
        // 3.将名称修改成橘色
        chatMessageMstr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: username.characters.count))
        
        // 4.将所有表情匹配出来, 并且换成对应的图片进行展示
        // 4.1.创建正则表达式匹配表情 我是主播[哈哈], [嘻嘻][嘻嘻] [123444534545235]
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return chatMessageMstr
        }
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.characters.count))
        
        // 4.2.获取表情的结果
        for i in (0..<results.count).reversed() {
            let result = results[i]
            
            let emotionName = (chatMessage as NSString).substring(with: result.range)
            
            guard let image = UIImage(named: emotionName) else {
                continue
            }
            
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            // bounds的y轴坐标反方向, 向下移动即为-3
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            chatMessageMstr.replaceCharacters(in: result.range, with: imageAttrStr)
        }
        
        return chatMessageMstr
    }
    
    class func generateGifMessage(_ giftname: String, _ giftURL: String, _ username: String) -> NSAttributedString {
        let sendGiftMessage = "\(username) 赠送 \(giftname)"
        let sendGiftMsgMstr = NSMutableAttributedString(string: sendGiftMessage)
        sendGiftMsgMstr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: username.characters.count))
        
        let range = (sendGiftMessage as NSString).range(of: giftname)
        sendGiftMsgMstr.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: range)
        
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftURL) else {
            return sendGiftMsgMstr
        }
        
        let attachment = NSTextAttachment()
        attachment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageMstr = NSAttributedString(attachment: attachment)
        sendGiftMsgMstr.append(imageMstr)
        
        return sendGiftMsgMstr
    }
    
}
