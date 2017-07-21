//
//  ServerManager.swift
//  Server
//
//  Created by 佘红响 on 2017/6/14.
//  Copyright © 2017年 she. All rights reserved.
//

import Cocoa

class ServerManager: NSObject {
    
    fileprivate lazy var serverSocket: TCPServer = TCPServer(addr:"0.0.0.0", port: 7878)

    fileprivate var isServerRunning: Bool = false
    
    fileprivate lazy var clientManagerArr: [ClientManager] = [ClientManager]()
}

extension ServerManager {
    
    func startRunning() {
        // 1.开启监听
        serverSocket.listen()
        isServerRunning = true
        
        // 2.开始接受客户端
        DispatchQueue.global().async {
            while self.isServerRunning {
                if let client = self.serverSocket.accept() {
                    print("接收到一个客户端的链接")
                    DispatchQueue.global().async {
                        self.handlerClient(client)
                    }
                    
                }
            }
        }
    }
    
    func stopRuning() {
        isServerRunning = false
    }
}

extension ServerManager {
    
    fileprivate func handlerClient(_ client: TCPClient) {
        let mgr = ClientManager(tcpClient: client)
        clientManagerArr.append(mgr)
        
        mgr.delegate = self
        
        mgr.startReadMsg()
    }
}

extension ServerManager: ClientManagerDelegate {
    
    func sendMsgToClient(_ data: Data) {
        for mgr in clientManagerArr {
            mgr.client.send(data: data)
        }
    }
    
    // 当客户端失去连接或者离开房间的时候移除客户端
    func clientClose(_ clientManager: ClientManager) {
        
        guard let index = clientManagerArr.index(of: clientManager) else {
            return
        }
        
        clientManagerArr.remove(at: index)
    }
}
