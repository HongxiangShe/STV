//
//  Resuable.swift
//  SHXPageView
//
//  Created by 佘红响 on 2017/6/8.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

protocol Resuable {
    static var resuableIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Resuable {
    static var resuableIdentifier : String {
        return "\(self)"
    }
    
    static var nib: UINib? {
        return nil
    }
}

extension UITableView {
    
    func registerCell<T : UITableViewCell>(_ cell: T.Type) where T : Resuable {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.resuableIdentifier)
        } else {
            register(cell, forCellReuseIdentifier: T.resuableIdentifier)
        }
    }
    
    func dequeueReusableCell<T : Resuable>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.resuableIdentifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    
    func registerCell<T : UICollectionView>(_ cell: T.Type) where T : Resuable {
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.resuableIdentifier)
        } else {
            register(cell, forCellWithReuseIdentifier: T.resuableIdentifier)
        }
    }
    
    
    func dequeueReusableCell<T : Resuable>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.resuableIdentifier, for: indexPath) as! T
    }
    
}
