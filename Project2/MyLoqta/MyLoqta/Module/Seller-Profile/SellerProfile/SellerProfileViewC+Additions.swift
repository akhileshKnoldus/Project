//
//  SellerProfileViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension SellerProfileViewC {
}

//MARK:- UITableView Delegates & Datasource Methods
extension SellerProfileViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let manageStoreType = ManageStoresType(rawValue: typeSelected) else {
            return 0
        }
        switch manageStoreType {
        case .products: return 4
        case .info: return 3
        default: return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let doubleProductsCount = Double(arrayProducts.count)
        let noOfRows = round(doubleProductsCount/2)
        var doubleReviewsCount = Double(arrReviews.count)
        if arrReviews.count == 0 {
            doubleReviewsCount = 1.0
        }
        guard let cellType = ManageProductsCell(rawValue: indexPath.row) else {
            return 0
        }
        
        switch cellType {
        case .profileCell: return 166
        case .headerCell: return 52
        default: guard let manageStoreType = ManageStoresType(rawValue: typeSelected) else {
            return 0
        }
        switch manageStoreType {
        case .products: return indexPath.row == 2 ? 45 : CGFloat((noOfRows*240) + (noOfRows*19) + 35)
        case .info: return UITableViewAutomaticDimension
        default: return indexPath.row == 2 ? 70 : CGFloat(doubleReviewsCount*185)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let doubleProductsCount = Double(arrayProducts.count)
        let noOfRows = round(doubleProductsCount/2)
        let doubleReviewsCount = Double(arrReviews.count)
        guard let cellType = ManageProductsCell(rawValue: indexPath.row) else {
            return 0
        }
        
        switch cellType {
        case .profileCell: return 166
        case .headerCell: return 52
        default: guard let manageStoreType = ManageStoresType(rawValue: typeSelected) else {
            return 0
        }
        switch manageStoreType {
        case .products: return indexPath.row == 2 ? 45 :
            CGFloat((noOfRows*240) + (noOfRows*19) + 35)
        case .info: return 200
        default: return indexPath.row == 2 ? 70 : CGFloat(doubleReviewsCount*185)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellType = ManageProductsCell(rawValue: indexPath.row) else {
            fatalError("Cell type is not configured")
        }
        switch cellType {
        case .profileCell:
            let cell: ProfileDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.isSelfProfile = self.isSelfProfile
            if let seller = self.seller {
                cell.delegate = self
                cell.configureCellForSeller(seller: seller)
            }
            return cell
        case .headerCell:
            let cell: ManageStoreHeaderTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(typeSelected: self.typeSelected)
            cell.delegate = self
            return cell
        default:
            guard let manageStoreType = ManageStoresType(rawValue: typeSelected) else {
                fatalError("Cell type is not configured")
            }
            switch manageStoreType {
            case .products: return indexPath.row == 2 ? configureCellForProductsHeader(tableView: tableView, indexPath: indexPath) : configureCellForProducts(tableView: tableView, indexPath: indexPath)
            case .info: return configureCellForInfo(tableView: tableView, indexPath: indexPath)
            default: return indexPath.row == 2 ? configureCellForReviewHeader(tableView: tableView, indexPath: indexPath) : configureCellForReviewMainCell(tableView: tableView, indexPath: indexPath)
            }
        }
}
    
    //MARK: - TableViewCell Methods
    
    func configureCellForProductsHeader(tableView: UITableView, indexPath: IndexPath) -> ManageStoreProductsHeaderCell {
        let cell: ManageStoreProductsHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let productsCount = self.seller?.productCount {
            cell.configureView(productsCount: productsCount)
        } else {
            cell.configureView(productsCount: 0)
        }
        return cell
    }
    
    func configureCellForProducts(tableView: UITableView, indexPath: IndexPath) -> ManageStoreProductsTableCell {
        let cell: ManageStoreProductsTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCell(products: self.arrayProducts)
        return cell
    }
    
    func configureCellForReviewHeader(tableView: UITableView, indexPath: IndexPath) -> ManageStoreReviewHeaderTableCell {
        let cell: ManageStoreReviewHeaderTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureView(ratingStar: self.ratingStar, ratingCount: self.ratingCount)
        return cell
    }
    
    func configureCellForReviewMainCell(tableView: UITableView, indexPath: IndexPath) -> SellerProfileReviewMainTableCell {
        let cell: SellerProfileReviewMainTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(self.arrReviews)
        return cell
    }
    
    func configureCellForInfo(tableView: UITableView, indexPath: IndexPath) -> ManageStoreInfoTableCell {
        let cell: ManageStoreInfoTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let seller = self.seller {
            cell.configureCell(seller: seller)
        }
        return cell
    }
    
    func getHtofFesc(indexPath: IndexPath) -> CGFloat {
        let review = arrReviews[indexPath.row]
        guard let text = review.fewWordsAbout else { return 0.0 }
        if review.isShowMore {
            var ht = (UserSession.sharedSession.getHieghtof(text: text, width: (Constant.screenWidth - 32), font: UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)) + 10 )
            if ht > 64.0 {
                ht = 64.0
            }
            return (ht + 150)
        } else {
            return (UserSession.sharedSession.getHieghtof(text: text, width: (Constant.screenWidth - 32), font: UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)) + 150 )
        }
    }
}

//MARK:- SelectManageStoreType Delegates
extension SellerProfileViewC: SelectManageStoreTypeDelegates {
    func didPerformActionOnTappingOnType(typeSelected: Int) {
        self.typeSelected = typeSelected
        self.tblViewProducts.reloadData()
    }
}

//MARK:- ManageStoreProductsTableCellDelegate
extension SellerProfileViewC: ManageStoreProductsTableCellDelegate {
    func didSelectProduct(indexPath: IndexPath) {
        let product = self.arrayProducts[indexPath.item]
        guard let itemId = product.itemId else { return }
        if let buyerDetail = DIConfigurator.sharedInst().getBuyerProducDetail() {
            buyerDetail.productId = itemId
            buyerDetail.delegate = self
            self.navigationController?.pushViewController(buyerDetail, animated: true)
        }
    }
    
    func didTapLike(indexPath: IndexPath) {
        let product = self.arrayProducts[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike)
    }
}

//MARK: - ExploreDelegate
extension SellerProfileViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
}

//MARK: - ProfileDetailCellDelegate
extension SellerProfileViewC: ProfileDetailCellDelegate {
    func didTapFollow() {
        self.requestFollowSeller()
    }
}
