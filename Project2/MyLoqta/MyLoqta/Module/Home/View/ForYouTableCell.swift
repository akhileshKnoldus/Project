//
//  ForYouTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/11/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ForYouTableCellDelegate: class {
    func didTapSeeAll(_ cell: ForYouTableCell)
    func didTapLike(indexPath: IndexPath)
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product)
}

class ForYouTableCell: BaseTableViewCell, ReusableView, NibLoadableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    
    //MARK:- Variables
    var arrayOfDatasource = [Product]()
    weak var delegate: ForYouTableCellDelegate?
    
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
        self.collectionViewProducts.register(ForYouCollectionCell.self)
        self.collectionViewProducts.delegate = self
        self.collectionViewProducts.dataSource = self
    }
    
    //MARK:- Public Methods
    func configureView(products: [Product]) {
        self.arrayOfDatasource = products
        self.collectionViewProducts.reloadData()
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func tapSeeAll(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapSeeAll(self)
        }
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension ForYouTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfDatasource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 162.0, height: 260.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: ForYouCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCell(product: self.arrayOfDatasource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingProduct(indexPath: indexPath, product: self.arrayOfDatasource[indexPath.item])
        }
    }
}

//MARK:- ForYouCollectionCellDelegate
extension ForYouTableCell: ForYouCollectionCellDelegate {
    func didLikeProduct(_ cell: ForYouCollectionCell) {
        guard let indexPath = self.collectionViewProducts.indexPath(for: cell) else { return }
        if let delegate = delegate {
            delegate.didTapLike(indexPath: indexPath)
        }
    }
}
