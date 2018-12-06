//
//  RecentItemTableCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func tapProduct(product: Product)
}

class RecentItemTableCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var collectionViewItem: UICollectionView!
    @IBOutlet weak var lblRecentlyViewed: AVLabel!
    
    var arrayProduct = [Product]()
    weak var searchDelegate: SearchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionViewItem.register(RecentViewedCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(array: [Product])  {
        self.arrayProduct.removeAll()
        self.arrayProduct.append(contentsOf: array)
        self.lblRecentlyViewed.isHidden = self.arrayProduct.count > 0 ? false : true
        self.collectionViewItem.reloadData()
    }
    
}

extension RecentItemTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecentViewedCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(product: self.arrayProduct[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.arrayProduct[indexPath.item]
        if let delegate = self.searchDelegate {
            delegate.tapProduct(product: product)
        }
    }
    
    
}
