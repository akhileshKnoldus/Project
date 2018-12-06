//
//  FeaturedShopTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/22/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class FeaturedShopTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.setupCollectionStyle()
    }
    
    private func setupCollectionStyle() {
        self.collectionView.register(FeaturedShopCollectionCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension FeaturedShopTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 252.0, height: 110.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: FeaturedShopCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
