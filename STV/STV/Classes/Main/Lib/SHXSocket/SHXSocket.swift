//
//  SHXSocket.swift
//  Client
//
//  Created by 佘红响 on 2017/6/14.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

enum MessageType: Int {
    case joinRoom = 0
    case leaveRoom = 1
    case textMessage = 2
    case giftMessage = 3
}

protocol SHXSocketDelegate: class {
    func socket(_ socket: SHXSocket, joinRoom user: UserInfo)
    func socket(_ socket: SHXSocket, leaveRoom user: UserInfo)
    func socket(_ socket: SHXSocket, textMsg: TextMessage)
    func socket(_ socket: SHXSocket, giftMsg: GiftMessage)
}

class SHXSocket: NSObject {
    
    fileprivate var tcpClient: TCPClient
    fileprivate var isConnected : Bool = false
    
    weak var delegate: SHXSocketDelegate?

    fileprivate lazy var userInfo: UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "佘\(arc4random_uniform(10))"
        userInfo.level = 20
        userInfo.iconUrl = "icon\(arc4random_uniform(10) % 2 + 1)"
        return userInfo
    }()
    
    init(addr: String, port: Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }

}


extension SHXSocket {
    
    // 连接服务端
    func connectServer(_ timeout: Int) -> Bool {
        
        let flag = self.tcpClient.connect(timeout: timeout)
        if flag.0 {
            isConnected = true
            
            // 开始读取消息
            DispatchQueue.global().async {
                self.startReadMsg()
            }
        }
        
        return flag.0
    }
    
    // 读消息
    func startReadMsg() {
        
        while self.isConnected {
            guard let lengthMsg = self.tcpClient.read(4) else {
                continue
            }
            // 1.读取长度
            let leghtData = Data(bytes: lengthMsg, count: 4)
            var length = 0
            (leghtData as NSData).getBytes(&length, length: 4)
            
            guard let typeMsg = self.tcpClient.read(2) else {
                continue
            }
            // 2.读取消息类型
            let typeData = Data(bytes: typeMsg, count: 2)
            var type = 0
            (typeData as NSData).getBytes(&type, length: 2)
            HXPrint("类型: \(type)")
            
            
            guard let msgMsg = self.tcpClient.read(length) else {
                continue
            }
            // 3.读取真实消息内容
            let msgData = Data(bytes:msgMsg, count: length)
            
            
            // 4.回到主线程异步处理消息
            DispatchQueue.main.async {
                self.handleMsg(type: type, data: msgData)
            }
            
        }
    }
    
    // 处理消息
    fileprivate func handleMsg(type: Int, data: Data) {
        switch type {
            case 0, 1:
                let user = try! UserInfo.parseFrom(data: data)
                type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
            case 2:
                let textMsg = try! TextMessage.parseFrom(data: data)
                delegate?.socket(self, textMsg: textMsg)
            case 3:
                let giftMsg = try! GiftMessage.parseFrom(data: data)
                delegate?.socket(self, giftMsg: giftMsg)
            default:
                HXPrint("未知类型")
        }
    }
}

extension SHXSocket {
    
    func sendJoinRoom() {
       
        let data = (try! userInfo.build()).data()
        
        sendMsg(data, type: 0)
    }
    
    func sendLeaveRoom() {
        
        let data = (try! userInfo.build()).data()
        
        sendMsg(data, type: 1)
        
        // 关闭客户端
        closeClient()
    }
    
    func sendTextMsg(message: String) {
        
        let textMessage = TextMessage.Builder()
        textMessage.text = message
        textMessage.user = try! userInfo.build()
        
        let data = (try! textMessage.build()).data()
        
        sendMsg(data, type: 2)
    }
    
    func sendGiftMsg(giftname: String, giftUrl: String, giftCount: String, giftGifURL: String) {
        let giftMsg = GiftMessage.Builder()
        giftMsg.user = try! userInfo.build()
        giftMsg.giftname = giftname
        giftMsg.giftUrl = giftUrl
        giftMsg.giftCount = giftCount
        giftMsg.giftGifUrl = giftGifURL
        
        let data = (try! giftMsg.build()).data()
        
        sendMsg(data, type: 3)
    }
    
    // 发送心跳包
    func sendHeartBeat() {
        let str = "send a heart beat!"
        HXPrint("发送心跳包: " + str)
        let data = str.data(using: .utf8)!
        sendMsg(data, type: 100)
    }
    
    fileprivate func sendMsg(_ data: Data, type: Int) {
        
        var length = data.count
        let lengthData = Data(bytes: &length, count: 4)
        
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        let totalData = lengthData + typeData + data
        
        tcpClient.send(data: totalData)
    }
    
    fileprivate func closeClient() {
        isConnected = false
        tcpClient.close()
    }
}
