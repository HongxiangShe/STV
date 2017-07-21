//
//  GiftListView.swift
//  STV
//
//  Created by 佘红响 on 2017/7/7.
//  Copyright © 2017年 she. All rights reserved.
//

import UIKit

private let GIFTCELL_ID = "GIFTCELL_ID"

protocol GiftListViewDelegate: class {
    func giftListView(giftListView: GiftListView, giftModel: GiftModel)
}

class GiftListView: UIView, Nibloadable {
    
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    
    weak var delegate: GiftListViewDelegate?
    
    fileprivate var currentIndexPath: IndexPath?
    
    fileprivate lazy var pageCollectionView: SHXPageCollectionView =  {
        
        var pageStyle = SHXPageStyle()
        pageStyle.isShowBottomLine = true
        
        let layout = SHXPageCollectionLayout()
        layout.rows = 2
        layout.cols = 4
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.itemMargin = 5
        layout.lineMargin = 5
        
        let pageCollectionView = SHXPageCollectionView(frame: self.giftView.bounds, titles: ["热门", "高级", "豪华", "专属"], style: pageStyle, layout: layout)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.registerNib(UINib(nibName: "GiftViewCell", bundle: nil), forCellWithReuseIdentifier: GIFTCELL_ID)
        
        return pageCollectionView
    }()
    
    fileprivate var giftViewModel: GiftViewModel = GiftViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        loadData()
    }
    
}

extension GiftListView {
    
    fileprivate func setupUI() {
        pageCollectionView.autoresizingMask = .flexibleHeight
        giftView.addSubview(pageCollectionView)
    }
    
    fileprivate func loadData() {
        giftViewModel.requestData {
            self.pageCollectionView.reloadData()
        }
    }
    
}

extension GiftListView: SHXPageCollectionViewDataSource, SHXPageCollectionViewDelegate {
    
    func numberOfSectionInPageCollectionView(_ pageCollectionView: SHXPageCollectionView) -> Int {
        return giftViewModel.data.count
    }
    
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftViewModel.data[section].list.count
    }
    
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, _ collectionView: UICollectionView, cellAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GiftViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GIFTCELL_ID, for: indexPath) as! GiftViewCell
        cell.giftModel = giftViewModel.data[indexPath.section].list[indexPath.item]
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: SHXPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndexPath = indexPath
        sendGiftBtn.isEnabled = true
    }
}

extension GiftListView {
    
    @IBAction func sendGift(_ sender: UIButton) {
        let giftModel = giftViewModel.data[currentIndexPath!.section].list[currentIndexPath!.item]
        delegate?.giftListView(giftListView: self, giftModel: giftModel)
    }
    
}
