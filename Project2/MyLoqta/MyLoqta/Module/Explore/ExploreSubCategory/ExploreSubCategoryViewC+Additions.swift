//
//  ExploreSubCategoryViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

//MARK:- UICollectionView Delegates & Datasource Methods
extension ExploreSubCategoryViewC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arraySubCategoryProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewProducts.frame.size.width/2-19, height: 239.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let product = self.arraySubCategoryProducts[indexPath.row]
        cell.configureCell(product: product, isPopular: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let product = self.arraySubCategoryProducts[indexPath.item]
        guard let itemId = product.itemId else { return }
        if let buyerDetail = DIConfigurator.sharedInst().getBuyerProducDetail() {
            buyerDetail.productId = itemId
            buyerDetail.delegate = self
            self.navigationController?.pushViewController(buyerDetail, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMore()
        }
    }
}

//MARK: - ExplorePopularCollectionCellDelegate
extension ExploreSubCategoryViewC: ExplorePopularCollectionCellDelegate {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionViewProducts.indexPath(for: cell) else { return }
        let product = self.arraySubCategoryProducts[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike)
    }
}

//MARK: - ExploreDelegate
extension ExploreSubCategoryViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
}
