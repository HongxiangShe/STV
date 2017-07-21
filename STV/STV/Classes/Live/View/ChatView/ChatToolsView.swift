//
//  ChatToolsView.swift
//  STV
//
//  Created by 佘红响 on 2017/7/6.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol ChatToolsViewDelegate: class {
    func chatToolsView(chatToolsView: ChatToolsView, message: String)
}

class ChatToolsView: UIView, Nibloadable {

    /// 输入框
    @IBOutlet weak var inputTextField: UITextField!
    /// 发送按钮
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate: ChatToolsViewDelegate?
    
    /// 表情键盘
    fileprivate lazy var emotionView: EmotionView = EmotionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    
    /// 初始化inputView中的rightView
    fileprivate lazy var emotionButton: UIButton = {
        let emotionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        emotionButton.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emotionButton.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emotionButton.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        return emotionButton
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        // 设置inputView中的rightView
        inputTextField.rightView = emotionButton
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true
        
        // 设置emotionView的闭包(weak当对象销毁值, 会自动将指针指向nil)
        // weak var weakSelf = self
        emotionView.emotionClickCallback = { [weak self] emotion in
            // 判断是否是删除按钮
            if emotion.emotionName == "delete-n" {
                self?.inputTextField.deleteBackward()
                return
            }
            
            // 获取光标位置, 并替换文本
            guard let range = self?.inputTextField.selectedTextRange else {return}
            self?.inputTextField.replace(range, withText: emotion.emotionName)
        }
    }
    
}

extension ChatToolsView {
    
    
    /// emotionButton的点击事件
    @objc fileprivate func emoticonBtnClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        // 切换键盘
        let range = inputTextField.selectedTextRange  // 获得选中的范围
        inputTextField.resignFirstResponder()
        inputTextField.inputView = inputTextField.inputView == nil ? emotionView : nil
        inputTextField.becomeFirstResponder()
        inputTextField.selectedTextRange = range  // 设置选中范围
    }
    
    @IBAction func textFieldChangedEditing(_ textField: UITextField) {
        sendButton.isEnabled = textField.text?.characters.count != 0
    }
    
    @IBAction func sendMsg(_ sender: UIButton) {
        let message = inputTextField.text!
        
        inputTextField.text = nil
        sender.isEnabled = false
        
        delegate?.chatToolsView(chatToolsView: self, message: message)
    }
    
}
