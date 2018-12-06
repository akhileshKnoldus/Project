//
//  ManageStoreProductsTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ManageStoreProductsTableCellDelegate: class {
    func didTapLike(indexPath: IndexPath)
    func didSelectProduct(indexPath: IndexPath)
}

class ManageStoreProductsTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    weak var delegate: ManageStoreProductsTableCellDelegate?
    var sellerProducts = [Product]()

    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.collectionViewProducts.isScrollEnabled = false
        self.collectionViewProducts.register(ExplorePopularCollectionCell.self)
        self.collectionViewProducts.delegate = self
        self.collectionViewProducts.dataSource = self
    }
    
    //MARK: - Public Methods
    func configureCell(products: [Product]) {
        self.sellerProducts = products
        self.collectionViewProducts.reloadData()
        
        self.viewNoData.isHidden = self.sellerProducts.count > 0 ? true : false
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension ManageStoreProductsTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sellerProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((Constant.screenWidth-32)/2)-10, height: 240.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let product = self.sellerProducts[indexPath.item]
        cell.configureCell(product: product, isPopular: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelectProduct(indexPath: indexPath)
        }
    }
}

extension ManageStoreProductsTableCell: ExplorePopularCollectionCellDelegate {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionViewProducts.indexPath(for: cell) else { return }
        if let delegate = delegate {
            delegate.didTapLike(indexPath: indexPath)
        }
    }
}
