//
//  OtherItemCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol OtherItemCellDelegate: class {
    
    func didTapLike(cell: OtherItemCell, product: Product)
    func didTapSellAll(_ cell: OtherItemCell)
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?)
}

class OtherItemCell: BaseTableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    var arrayDataSource = [Product]()
    weak var delegate: OtherItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(ExplorePopularCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(array: [Product], indexPath: IndexPath) {
        self.arrayDataSource.removeAll()
        self.arrayDataSource.append(contentsOf: array)
        self.collectionView.reloadData()
    }
    
    func configureCellForCart(array: [Product], indexPath: IndexPath) {
        self.backgroundColor = UIColor.defaultBgColor
        self.btnSeeAll.isHidden = true
        self.lblTitle.text = "More from the seller".localize()
        self.arrayDataSource.removeAll()
        self.arrayDataSource.append(contentsOf: array)
        self.collectionView.reloadData()
    }
    
    //MARK: - IBActions
    
    @IBAction func tapSellAllProducts(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapSellAll(self)
        }
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension OtherItemCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 162.0, height: 239.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCell(product: self.arrayDataSource[indexPath.item], isPopular: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didPerformActionOnTappingProduct(indexPath: indexPath, product: self.arrayDataSource[indexPath.item])
        }
    }
}

extension OtherItemCell: ExplorePopularCollectionCellDelegate {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        let product = self.arrayDataSource[indexPath.item]
        if let delegate = delegate {
            delegate.didTapLike(cell: self, product: product)
        }
    }
}
