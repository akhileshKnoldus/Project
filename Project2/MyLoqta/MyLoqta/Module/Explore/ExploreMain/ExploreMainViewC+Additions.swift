//
//  ExploreMainViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension ExploreMainViewC {
    func configureCellForPopularShop(tableView: UITableView, indexPath: IndexPath) -> FeaturedShopTableCell {
        let cell: FeaturedShopTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- UITableView Datasource & Delegates Methods
extension ExploreMainViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = ExploreMainCell(rawValue: indexPath.row) else {
            return 0
        }
        
        switch cellType {
        case .categoriesCell: return 85
        case .featuredShopCell: return 178
        case .popularCell: return 310
        default: return 310
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellType = ExploreMainCell(rawValue: indexPath.row) else {
            fatalError("Cell type is not configured")
        }
        switch cellType {
        case .categoriesCell:
            let cell: ExploreCategoriesTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(arrOfCategories: arrayCategory)
            cell.delegate = self
            return cell
        case .featuredShopCell: return configureCellForPopularShop(tableView: tableView, indexPath: indexPath)
        case .popularCell:
            let cell: ExplorePopularTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.openProductdelegate = self
            cell.configureCell(isPopular: true, arrayProducts: arrayPopularProducts)
            return cell
        default:
            let cell: ExplorePopularTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//            cell.configureCell(isPopular: false)
            return cell
        }
    }
}

//MARK:- OpenExploreCategory Delegates
extension ExploreMainViewC: OpenExploreCategoryDelegates {
    func didPerformActionOnExploreCategory(indexPath: IndexPath) {
        let category = self.arrayCategory[indexPath.row]
        self.moveToExploreCategoryVC(category: category)
    }
}

//MARK: - ExplorePopularTableCellDelegate
extension ExploreMainViewC: ExplorePopularTableCellDelegate {
    
    func didTapSeeAll(_ cell: ExplorePopularTableCell) {
        guard let indexPath = self.tblViewExplore.indexPath(for: cell) else { return }
        switch indexPath.row {
        case 2:
            if let productListVC = DIConfigurator.sharedInst().getProductListVC() {
                productListVC.categoryId = 0
                productListVC.categoryName = "Popular".localize()
                productListVC.productsList = productsList.popular
                productListVC.delegate = self
                self.navigationController?.pushViewController(productListVC, animated: true)
            }
        default:
            break
        }
    }
    
    func didTapLike(indexPath: IndexPath) {
        let product = self.arrayPopularProducts[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike)
    }
}

//MARK: - Explore Delegate
extension ExploreMainViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
}
