//
//  CheckoutViewC+Additions.swift
//  MyLoqta
//
//  Created by Kirti on 8/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension CheckoutViewC {
    func configureCellForItems(tableView: UITableView, indexPath: IndexPath) -> CheckoutItemTableCell {
        let cell: CheckoutItemTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configureCellForItems(self.cartItems[indexPath.row])
        return cell
    }
    
    func configureCellForShipping(tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingStatusTableCell {
        let cell: CheckoutShippingStatusTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func configureCellForLocation(tableView: UITableView, indexPath: IndexPath) -> CheckoutLocationTableCell {
        let cell: CheckoutLocationTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        if let address = self.shippingAddressInfo {
           cell.configureCell(address: address)
        }
        return cell
    }
    
    func configureCellForPaymentMethods(tableView: UITableView, indexPath: IndexPath) -> CheckoutPaymentMethodTableCell {
        let cell: CheckoutPaymentMethodTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        if let walletBal = self.walletBalance {
           cell.configureCell(walletBal)
        }
        return cell
    }
    
    func configureCellForTotalAmount(tableView: UITableView, indexPath: IndexPath) -> CheckoutTotalAmountTableCell {
        let cell: CheckoutTotalAmountTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.configureCell(arrCartItems: self.cartItems)
        return cell
    }
}

//MARK:- UITableView Delegates & Datasource Methods
extension CheckoutViewC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDatasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.arrayDatasource[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = self.arrayDatasource[indexPath.row].cellType
        switch cellType {
        case checkoutCellType.itemCell.rawValue:
            return configureCellForItems(tableView: tableView, indexPath: indexPath)
        case checkoutCellType.locationCell.rawValue:
            return configureCellForLocation(tableView: tableView, indexPath: indexPath)
        case checkoutCellType.paymentCell.rawValue:
            return configureCellForPaymentMethods(tableView: tableView, indexPath: indexPath)
        default:
            return configureCellForTotalAmount(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = self.arrayDatasource[indexPath.row].cellType
        switch cellType {
        case checkoutCellType.locationCell.rawValue:
            self.moveToAddressListingView()
        default:
            break
        }
    }
}

//MARK:- CheckoutCell Delegates
extension CheckoutViewC: CheckoutCellDelegate {
    func increaseQuanity(shouldIncrease: Bool, cell: UITableViewCell) {
        guard let indexPath = self.tblViewCheckout.indexPath(for: cell) else { return }
        let product = self.cartItems[indexPath.row]
        if let itemId = product.itemId, let quantity = product.cartQuantity {
            let updatedQuantity = shouldIncrease ? quantity + 1 : quantity - 1
            self.increaseItemQuantity(itemID: itemId, quantity: updatedQuantity)
        }
    }
}

//MARK:- CheckOut Payment Cell Delegates
extension CheckoutViewC: CheckoutPaymentCellDelegates {
    func didPerformActionOnTappingWalletBtn(_ sender: UIButton) {
        self.isWalletUsed = sender.isSelected == true ? 1 : 0
    }
}
