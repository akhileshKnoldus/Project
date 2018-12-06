//
//  ExploreCategoryViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension ExploreCategoryViewC {
    func configureCellForFeaturedShop(tableView: UITableView, indexPath: IndexPath) -> FeaturedShopTableCell {
        let cell: FeaturedShopTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- UITableView Delegates & Datasource Methods
extension ExploreCategoryViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = ExploreCategoryCell(rawValue: indexPath.row) else {
            return 0
        }
        
        switch cellType {
        case .subCategoryCell: return 60
        case .featuredShopCell: return 178
        case .popularCell: return 300
        default: return 300
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellType = ExploreCategoryCell(rawValue: indexPath.row) else {
            fatalError("Cell type is not configured")
        }
        switch cellType {
        case .subCategoryCell:
            let cell: ExploreSubCategoryTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(arrSubCategories: self.arraySubCategory)
            cell.delegate = self
            return cell
        case .featuredShopCell: return configureCellForFeaturedShop(tableView: tableView ,indexPath: indexPath)
        case .popularCell:
            let cell: ExplorePopularTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.openProductdelegate = self
            cell.configureCell(isPopular: true, arrayProducts: self.arrayPopularProducts)
            return cell
        default:
            let cell: ExplorePopularTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            //            cell.configureCell(isPopular: false)
            return cell
        }
    }
}

//MARK:- OpenExploreSubCategory Delegates
extension ExploreCategoryViewC: OpenExploreSubCategoryDelegates {
    func didPerformActionOnTappingCategories(indexPath: IndexPath) {
        let subCategory = self.arraySubCategory[indexPath.row]
        self.moveToExploreSubCategoryView(subCategory: subCategory)
    }
}

//MARK: - ExplorePopularTableCellDelegate
extension ExploreCategoryViewC: ExplorePopularTableCellDelegate, OpenProductDetailDelegates{
    
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?) {
        self.view.endEditing(true)
        if let buyerDetail = DIConfigurator.sharedInst().getBuyerProducDetail(), let itemId = product?.itemId {
            buyerDetail.productId = itemId
            buyerDetail.delegate = self
            self.navigationController?.pushViewController(buyerDetail, animated: true)
        }
    }
    
    func didTapLike(indexPath: IndexPath) {
        let product = self.arrayPopularProducts[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike)
    }
    
    func didTapSeeAll(_ cell: ExplorePopularTableCell) {
        guard let indexPath = self.tblView.indexPath(for: cell) else { return }
        switch indexPath.row {
        case 2:
            if let productListVC = DIConfigurator.sharedInst().getProductListVC(), let catgry = self.category, let catgryId = catgry.id {
                productListVC.categoryId = catgryId
                productListVC.categoryName = "Popular".localize()
                productListVC.productsList = productsList.popular
                productListVC.delegate = self
                self.navigationController?.pushViewController(productListVC, animated: true)
            }
        default:
            break
        }
    }
}

//MARK: - ExploreCategory Delegate
extension ExploreCategoryViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
}
