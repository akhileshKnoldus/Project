//
//  MyCartViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension MyCartViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cartProductCount = self.arrayCartProducts.count
        return cartProductCount > 0 ? cartProductCount + 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastIndexPath = self.arrayCartProducts.count
        switch indexPath.row {
        case lastIndexPath:
            return getSellerMoreItemCell(tableView: tableView, indexPath: indexPath)
        default:
            return getCartOrderCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    //CellForMoreItems
    private func getSellerMoreItemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: OtherItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCellForCart(array: self.arraySellerProducts, indexPath: indexPath)
        return cell
    }
    //CellForOrder
    private func getCartOrderCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: CartOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let product = self.arrayCartProducts[indexPath.row]
        cell.configureView(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastIndexPath = self.arrayCartProducts.count
        switch indexPath.row {
        case lastIndexPath:
            return 290.0
        default:
            return 150.0
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let lastIndexPath = self.arrayCartProducts.count
        return indexPath.row == lastIndexPath ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Are you sure, you want to remove this item from your cart?".localize(), actionTitle: "Yes".localize(), showCancel: true, action: { (action) in
                let product = self.arrayCartProducts[indexPath.row]
                if let itemId = product.itemId {
                    self.removeCartItem(itemID: itemId)
                }
            })
            self.tblViewCart.reloadData()
        }
    }
}

extension MyCartViewC: CartOrderCellDelegate {
    func increaseQuanity(shouldIncrease: Bool, cell: UITableViewCell) {
        guard let indexPath = self.tblViewCart.indexPath(for: cell) else { return }
        let product = self.arrayCartProducts[indexPath.row]
        if let itemId = product.itemId, let quantity = product.cartQuantity {
            let updatedQuantity = shouldIncrease ? quantity + 1 : quantity - 1
            self.increaseItemQuantity(itemID: itemId, quantity: updatedQuantity)
        }
    }
}

extension MyCartViewC: OtherItemCellDelegate {
    func didTapLike(cell: OtherItemCell, product: Product) {
        
    }
    
    func didTapSellAll(_ cell: OtherItemCell) {
        let categoryName = "More from the seller".localize()
        let productListType = productsList.moreFromSeller
        if let productListVC = DIConfigurator.sharedInst().getProductListVC(), let itemId = self.itemId {
            productListVC.itemId = itemId
            productListVC.categoryName = categoryName
            productListVC.productsList = productListType
            productListVC.delegate = self
            self.navigationController?.pushViewController(productListVC, animated: true)
        }
    }
    
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?) {
        if let buyerDetail = DIConfigurator.sharedInst().getBuyerProducDetail(), let itemId = product?.itemId {
            buyerDetail.productId = itemId
            buyerDetail.delegate = self
            self.navigationController?.pushViewController(buyerDetail, animated: true)
        }
    }
}

extension MyCartViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        
    }
}
