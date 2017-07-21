//
//  ChatContentView.swift
//  STV
//
//  Created by 佘红响 on 2017/7/7.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

private let CELL_ID = "CELL_ID"

class ChatContentView: UIView, Nibloadable {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var messageArr: [NSAttributedString] = [NSAttributedString]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: CELL_ID)
    }
    
    func insertMessage(_ message: NSAttributedString) {
        messageArr.append(message)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row:messageArr.count - 1, section: 0), at: .middle, animated: true)
    }
    
}

extension ChatContentView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatContentCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ChatContentCell
        cell.contentLabel.attributedText = messageArr[indexPath.row]
        return cell
    }
}
