//
//  HomeViewC+Additions.swift
//  MyLoqta
//
//  Created by Kirti on 8/12/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewC {
    func configureCellforFirstFeed(tableView: UITableView, indexpath: IndexPath) -> ProductCell {
        let cell: ProductCell = tableView.dequeueReusableCell(forIndexPath: indexpath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.feedType = .firstFeedCell
        cell.configureView(product: self.arrayOfFirstFeed[indexpath.row])
        return cell
    }
    
    func configureCellforSecondFeed(tableView: UITableView, indexpath: IndexPath) -> ProductCell {
        let cell: ProductCell = tableView.dequeueReusableCell(forIndexPath: indexpath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.feedType = .secondFeedCell
        cell.configureView(product: self.arrayOfSecondFeed[indexpath.row])
        return cell
    }
    
    func configureCellforLastFeed(tableView: UITableView, indexpath: IndexPath) -> ProductCell {
        let cell: ProductCell = tableView.dequeueReusableCell(forIndexPath: indexpath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.feedType = .lastFeedCell
        cell.configureView(product: self.arrayOfLastFeed[indexpath.row])
        return cell
    }
    
    func configureCellforForYouFeeds(tableView: UITableView, indexpath: IndexPath) -> ForYouTableCell {
        let cell: ForYouTableCell = tableView.dequeueReusableCell(forIndexPath: indexpath)
        cell.selectionStyle = .none
        cell.configureView(products: self.arrayOfForYou)
        cell.delegate = self
        return cell
    }
    
    func configureCellforCategoriesFeeds(tableView: UITableView, indexpath: IndexPath) -> CategoryTableCell {
        let cell: CategoryTableCell = tableView.dequeueReusableCell(forIndexPath: indexpath)
        cell.selectionStyle = .none
        if let category = self.categoryInfo {
            cell.delegate = self
           cell.configureView(categoryInfo: category)
        }
        return cell
    }
}

//MARK:- UITableView Datasource & Delegate Methods

extension HomeViewC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 491.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arrData = self.arrayDataSource[indexPath.section]
        return arrData[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrData = self.arrayDataSource[indexPath.section]
        let cellType = arrData[indexPath.row].cellType
        switch cellType {
        case HomeFeedsCell.firstFeedCell.rawValue:
            return configureCellforFirstFeed(tableView: tableView, indexpath: indexPath)
        case HomeFeedsCell.forYouCell.rawValue:
            return configureCellforForYouFeeds(tableView: tableView, indexpath: indexPath)
        case HomeFeedsCell.secondFeedCell.rawValue:
            return configureCellforSecondFeed(tableView: tableView, indexpath: indexPath)
        case HomeFeedsCell.lastFeedCell.rawValue:
            return configureCellforLastFeed(tableView: tableView, indexpath: indexPath)
        default:
            return configureCellforCategoriesFeeds(tableView: tableView, indexpath: indexPath)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrData = self.arrayDataSource[indexPath.section]
        let cellType = arrData[indexPath.row].cellType
        switch cellType {
        case HomeFeedsCell.firstFeedCell.rawValue:
            if let productID = self.arrayOfFirstFeed[indexPath.row].itemId {
                self.moveToBuyerProductDetailView(productId: productID)
            }
        case HomeFeedsCell.secondFeedCell.rawValue:
            if let productID = self.arrayOfSecondFeed[indexPath.row].itemId {
                self.moveToBuyerProductDetailView(productId: productID)
            }
        case HomeFeedsCell.lastFeedCell.rawValue:
            if let productID = self.arrayOfLastFeed[indexPath.row].itemId {
                self.moveToBuyerProductDetailView(productId: productID)
            }
        default:
           break
        }
    }
}

//MARK: - ExplorePopularTableCellDelegate
extension HomeViewC: ForYouTableCellDelegate {
    func didTapSeeAll(_ cell: ForYouTableCell) {
        if let productListVC = DIConfigurator.sharedInst().getProductListVC() {
            productListVC.categoryId = 0
            productListVC.categoryName = "For you".localize()
            productListVC.productsList = productsList.forYouItems
            //productListVC.delegate = self
            self.navigationController?.pushViewController(productListVC, animated: true)
        }
    }
    
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product) {
        if let productID = product.itemId {
            self.moveToBuyerProductDetailView(productId: productID)
        }
    }
    
    func didTapLike(indexPath: IndexPath) {
        let product = self.arrayOfForYou[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike, feedType: .forYouCell)
    }
}

//MARK:- ProductCell delegate
extension HomeViewC: ProductCellDelegates {
    func didPerformActionOnProductDetail(cell: ProductCell) {
        guard let indexPath = self.tblViewProductList.indexPath(for: cell) else { return }
        let arrData = self.arrayDataSource[indexPath.section]
        let cellType = arrData[indexPath.row].cellType
        switch cellType {
        case HomeFeedsCell.firstFeedCell.rawValue:
            if let productID = self.arrayOfFirstFeed[indexPath.row].itemId {
                self.moveToBuyerProductDetailView(productId: productID)
            }
        case HomeFeedsCell.secondFeedCell.rawValue:
            if let productID = self.arrayOfSecondFeed[indexPath.row].itemId {
                self.moveToBuyerProductDetailView(productId: productID)
            }
        case HomeFeedsCell.lastFeedCell.rawValue:
            if let productID = self.arrayOfLastFeed[indexPath.row].itemId {
                self.moveToBuyerProductDetailView(productId: productID)
            }
        default:
            break
        }
    }
    
    func didPerformActionOnSellerName(product: Product) {
        if let sellerId = product.sellerId {
            self.moveToSellerProfile(sellerId: sellerId)
        }
    }
    
    func didPerformActionOnAddingToCart(product: Product) {
        if let popupVC = DIConfigurator.sharedInst().getPopupViewC(), let productShipping = product.shipping {
            popupVC.product = product
            popupVC.shippingType = productShipping
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.view.backgroundColor = UIColor.presetedBgColor
            let rootVC = AppDelegate.delegate.window?.rootViewController
            rootVC?.present(popupVC, animated: true, completion: nil)
        }
    }
    
    func didPerformActionOnTappingThreeDots(product: Product) {
        self.performActionOnTappingMoreOptions(product: product)
    }
    
    func didPerformActionOnTappingLike(product: Product, feedType: HomeFeedsCell) {
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike, feedType: feedType)
    }
}

extension HomeViewC: CategoryTableCellDelegate {
    func didTapSeeAllCategory() {
        if let category = self.categoryInfo {
            self.moveToExploreCategoryVC(category: category)
        }
    }
}

extension HomeViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
}

