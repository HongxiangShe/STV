//
//  RoomViewController.swift
//  STV
//
//  Created by 佘红响 on 2017/6/18.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

private let kChatToolsViewHeight : CGFloat = 44

private let kGiftViewHeight : CGFloat = 340
private let kChatContentViewHeight : CGFloat = 200

class RoomViewController: UIViewController, Emitterable {
    
    /// 主播模型
    var anchor: AnchorModel?

    @IBOutlet weak var bgImageView: UIImageView!
    
    fileprivate var socket: SHXSocket = SHXSocket(addr: "192.168.31.28", port: 7878)
    
    fileprivate var timer: Timer!
    
    fileprivate lazy var chatView: ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftView: GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView: ChatContentView = ChatContentView.loadFromNib()
    fileprivate lazy var giftContainerView: SHXGiftContainerView = {
        let giftContainerView = SHXGiftContainerView(frame: CGRect(x: 0, y: 100, width: 320, height: 90))
        return giftContainerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        connectServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        socket.sendLeaveRoom()
        timer?.invalidate()
        timer = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if chatView.inputTextField.isEditing {
            chatView.inputTextField.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.giftView.frame.origin.y = kScreenH
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension RoomViewController {
    
    fileprivate func connectServer() {
        
        guard socket.connectServer(5) else {
            return
        }
        
        HXPrint("连接成功")
        socket.delegate = self
        socket.sendJoinRoom()
        timer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
    
    
    fileprivate func setupUI() {
        
        // 毛玻璃效果
        setupBulrView()
        
        setupBottomView()
        
        bgImageView.setImage(anchor?.pic74, nil)
        view.addSubview(giftContainerView)
    }
    
    fileprivate func setupBulrView() {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .dark)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - kChatContentViewHeight - kChatToolsViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(chatContentView)
        
        chatView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        // 顶部和宽度随父控件变化而变化
        chatView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatView.delegate = self
        view.addSubview(chatView)
        
        giftView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kGiftViewHeight)
        giftView.delegate = self
        view.addSubview(giftView)
    
    }

}


extension RoomViewController {
    
    @IBAction func dismiss(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toolButtonClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatView.inputTextField.becomeFirstResponder()
        case 1:
            HXPrint("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: { 
                self.giftView.frame.origin.y = kScreenH - kGiftViewHeight
            });
            
        case 3:
            HXPrint("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height / 2)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }
    }
    
    @objc fileprivate func keyboardWillChangeFrame(_ note: NSNotification) {
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatView.frame.origin.y = endY
            let chatContentEndY = inputViewY == (kScreenH - kChatToolsViewHeight) ? (kScreenH - kChatContentViewHeight - kChatToolsViewHeight) : endY - kChatContentViewHeight
            self.chatContentView.frame.origin.y = chatContentEndY
        })
    }
}

extension RoomViewController: ChatToolsViewDelegate, GiftListViewDelegate {
    
    func chatToolsView(chatToolsView: ChatToolsView, message: String) {
        HXPrint(message)
        socket.sendTextMsg(message: message)
    }
    
    func giftListView(giftListView: GiftListView, giftModel: GiftModel) {
        HXPrint(giftModel.subject)
        socket.sendGiftMsg(giftname: giftModel.subject, giftUrl: giftModel.img2, giftCount: "1", giftGifURL: giftModel.gUrl)
    }
}

extension RoomViewController: SHXSocketDelegate{
    
    func socket(_ socket: SHXSocket, joinRoom user: UserInfo) {
        let mstr = AttrStringGenerator.generateJoinLeaveRoom(user.name, true)
        chatContentView.insertMessage(mstr)
    }
    
    func socket(_ socket: SHXSocket, leaveRoom user: UserInfo) {
        let mstr = AttrStringGenerator.generateJoinLeaveRoom(user.name, false)
        chatContentView.insertMessage(mstr)
    }
    
    func socket(_ socket: SHXSocket, textMsg: TextMessage) {
        let mstr = AttrStringGenerator.generateTextMessage(textMsg.user.name, message: textMsg.text)
        chatContentView.insertMessage(mstr)
    }
    
    func socket(_ socket: SHXSocket, giftMsg: GiftMessage) {
        let mstr = AttrStringGenerator.generateGifMessage(giftMsg.giftname, giftMsg.giftUrl, giftMsg.user.name)
        chatContentView.insertMessage(mstr)
        
        let giftModel: GiftModel = GiftModel()
        giftModel.user = User(giftMsg.user.name)
        giftModel.subject = giftMsg.giftname
        giftModel.gUrl = giftMsg.giftGifUrl
        giftModel.img2 = giftMsg.giftUrl
        giftContainerView.insertGiftModel(giftModel: giftModel)
    }
    
}
