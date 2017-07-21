//
//  ViewController.swift
//  Server
//
//  Created by 佘红响 on 2017/6/14.
//  Copyright © 2017年 she. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var hintLabel: NSTextField!
    fileprivate lazy var serverManager: ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func startServer(_ sender: NSButton) {
        hintLabel.stringValue = "服务器已经开启ing"
        serverManager.startRunning()
    }
    
    @IBAction func stopServer(_ sender: NSButton) {
        hintLabel.stringValue = "服务器未开启"
        serverManager.stopRuning()
    }
    

}

