//
//  AnchorViewController.swift
//  STV
//
//  Created by 佘红响 on 2017/6/16.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

let anchorCellID = "anchorCellID"
let margin: CGFloat = 8

class AnchorViewController: UIViewController {
    
    var homeType: HomeType!
    
    fileprivate lazy var viewModel: HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = SHXWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.dataSource = self
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: anchorCellID)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        loadData(0)
    }

}

extension AnchorViewController:UICollectionViewDataSource, SHXWaterfallLayoutDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: anchorCellID, for: indexPath) as! HomeViewCell
        cell.anchorModel = viewModel.data[indexPath.item]
        
        if indexPath.item == viewModel.data.count - 1 {
            loadData(viewModel.data.count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RoomViewController()
        vc.anchor = viewModel.data[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func waterfallLayout(_ layout: SHXWaterfallLayout, itemIndex: Int) -> CGFloat {
        
        return itemIndex % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
    
}

extension AnchorViewController {
    // 网络请求
    fileprivate func loadData(_ index: Int) {
        viewModel.index = index
        viewModel.homeType = homeType
        viewModel.requestData {
            self.collectionView.reloadData()
        }
    }
}
