//
//  ProductListViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

//MARK:- UICollectionView Delegates & Datasource Methods
extension ProductListViewC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let list = self.productsList, list == .forYouItems {
            return CGSize(width: self.collectionViewProducts.frame.size.width/2-19, height: 260.0)
        } else {
            return CGSize(width: self.collectionViewProducts.frame.size.width/2-19, height: 239.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let list = self.productsList, list == .forYouItems {
            return getCellForYouProducts(collectionView:collectionView, indexPath: indexPath)
        }
        else {
           return getCellForPopularProducts(collectionView:collectionView, indexPath: indexPath)
        }
    }
    
    func getCellForPopularProducts(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.contentView.roundCorners(Constant.viewCornerRadius)
        let product = self.arrayProducts[indexPath.row]
        cell.configureCell(product: product, isPopular: true)
        return cell
    }
    
    func getCellForYouProducts(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ForYouCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.contentView.roundCorners(Constant.viewCornerRadius)

        let product = self.arrayProducts[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.arrayProducts[indexPath.item]
        if let buyerDetailVC = DIConfigurator.sharedInst().getBuyerProducDetail(), let productId = product.itemId {
            buyerDetailVC.productId = productId
            buyerDetailVC.delegate = self
            self.navigationController?.pushViewController(buyerDetailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionViewProducts.frame.size.width, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProductListHeaderView", for: indexPath as IndexPath) as! ProductListHeaderView
        header.lblHeaderTitle.text = self.categoryName
        
        return header
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
}

//MARK: - ExplorePopularCollectionCellDelegate
extension ProductListViewC: ExplorePopularCollectionCellDelegate {
    
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionViewProducts.indexPath(for: cell) else { return }
        let product = self.arrayProducts[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike)
    }
}

//MARK: - ExploreDelegate
extension ProductListViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
}

extension ProductListViewC: ForYouCollectionCellDelegate {
    func didLikeProduct(_ cell: ForYouCollectionCell) {
        
    }
}
