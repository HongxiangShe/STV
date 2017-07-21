//
//  ClientManager.swift
//  Server
//
//  Created by 佘红响 on 2017/6/14.
//  Copyright © 2017年 she. All rights reserved.
//

import Cocoa

protocol ClientManagerDelegate: class {
    // 转发消息给其他客户端
    func sendMsgToClient(_ data: Data)
    
    // 客户端断开
    func clientClose(_ clientManager: ClientManager)
}

class ClientManager: NSObject {
    
    var client: TCPClient
    
    fileprivate var isClientConnected: Bool = false
    
    fileprivate var heartTimeCount: Int = 0
    
    weak var delegate: ClientManagerDelegate?
    
    init(tcpClient: TCPClient) {
        self.client = tcpClient
        super.init()
    }

}

extension ClientManager {
    func startReadMsg() {
        isClientConnected = true
        
        // 定时器用于检查心跳包
        let timer = Timer(fireAt: Date(), interval: 1, target: self, selector: #selector(checkHeartBeat), userInfo: nil, repeats: true)
        // 加入当前子线程的主运行循环
        RunLoop.current.add(timer, forMode: .commonModes)
        timer.fire()
        
        while isClientConnected {
            
            guard let lengthMsg = client.read(4) else {
                closeClient()
                return
            }
            // 1.读取长度
            let leghtData = Data(bytes: lengthMsg, count: 4)
            var length = 0
            (leghtData as NSData).getBytes(&length, length: 4)
            

            guard let typeMsg = client.read(2) else {
                return
            }
            // 2.读取消息类型
            let typeData = Data(bytes: typeMsg, count: 2)
            var type = 0
            (typeData as NSData).getBytes(&type, length: 2)
            
            
            guard let msgMsg = client.read(length) else {
                return
            }
            // 3.读取真实消息内容
            let msgData = Data(bytes:msgMsg, count: length)
            
            if type == 1 {   // 如果消息类型是1的话, 关闭并移除客户端
                closeClient()
            } else if type == 100 {   // 如果消息类型是100的话, 接收到心跳包,跳过本次继续循环读信息
                heartTimeCount = 0
                let msg = String(data: msgData, encoding: .utf8)!
                print("接收到心跳包: " + msg)
                continue
            }
            
            // 拼凑整个data
            let totalData = leghtData + typeData + msgData
            
            delegate?.sendMsgToClient(totalData)
            
        }
    }
    
    @objc fileprivate func checkHeartBeat() {
        print("开始检查心跳包")
        heartTimeCount += 1
        if heartTimeCount >= 10 {
            closeClient()
        }
    }
    
    private func closeClient() {
        print("客户端断开了链接")
        isClientConnected = false
        client.close()
        delegate?.clientClose(self)
    }
    
}
