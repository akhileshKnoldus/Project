//
//  ExplorePopularTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/21/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ExplorePopularTableCellDelegate: class {
    func didTapSeeAll(_ cell: ExplorePopularTableCell)
    func didTapLike(indexPath: IndexPath)
}
    
protocol OpenProductDetailDelegates: class {
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?)
}

class ExplorePopularTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    
    //MARK: - Variables
    weak var delegate: ExplorePopularTableCellDelegate?
    var arrayDataSource = [Product]()
    var isPopular: Bool = false
    weak var openProductdelegate: OpenProductDetailDelegates?
    
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
        self.collectionViewProducts.register(ExplorePopularCollectionCell.self)
        self.collectionViewProducts.delegate = self
        self.collectionViewProducts.dataSource = self
    }
    
    //MARK: - Public Methods
    func configureCell(isPopular: Bool, arrayProducts: [Product]) {
        self.isPopular = isPopular
        self.lblTitle.text = isPopular == true ? ExploreMainCell.popularCell.title : ExploreMainCell.onSaleCell.title
        self.arrayDataSource = arrayProducts
        if self.arrayDataSource.count == 0 {
            self.btnSeeAll.isHidden = true
            self.lblTitle.isHidden = true
        } else {
            self.btnSeeAll.isHidden = false
            self.lblTitle.isHidden = false
        }
        self.collectionViewProducts.reloadData()
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapBtnSeeAll(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapSeeAll(self)
        }
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension ExplorePopularTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        print("index item: \(indexPath.item)")
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let product = self.arrayDataSource[indexPath.item]
        cell.configureCell(product: product, isPopular: self.isPopular)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.openProductdelegate != nil {
            self.openProductdelegate?.didPerformActionOnTappingProduct(indexPath: indexPath, product: self.arrayDataSource[indexPath.item])
        }
    }
}

//MARK:- ExplorePopularCollectionCellDelegate Methods
extension ExplorePopularTableCell: ExplorePopularCollectionCellDelegate {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionViewProducts.indexPath(for: cell) else { return }
        if let delegate = delegate {
            delegate.didTapLike(indexPath: indexPath)
        }
    }
}
