//
//  BuyerOrderListViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension BuyerOrderListViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.btnActive.isSelected {
            return self.arrActiveProducts.count
        } else {
            return self.arrArchivedProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.btnActive.isSelected {
            return getCellForActiveOrders(tableView: tableView, indexPath: indexPath)
        } else {
            return getArchivedOrderCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Active order Details
        if btnActive.isSelected {
            let product = self.arrActiveProducts[indexPath.row]
            // OrdetDetail is for buyer only
            if let itemId = product.orderDetailId, let itemStateVC = DIConfigurator.sharedInst().getOrderDetailVC() {
                itemStateVC.orderId = itemId
                self.navigationController?.pushViewController(itemStateVC, animated: true)
            }
        } else {
            //Archived order Details
            let product = self.arrArchivedProducts[indexPath.row]
            // OrdetDetail is for buyer only
            if let itemId = product.orderDetailId, let itemStateVC = DIConfigurator.sharedInst().getOrderDetailVC() {
                itemStateVC.orderId = itemId
                self.navigationController?.pushViewController(itemStateVC, animated: true)
            }
        }
    }
    
    /*if let itemId = product.orderId, let itemStateVC = DIConfigurator.sharedInst().getItemStateVC() {
     itemStateVC.orderId = itemId
     self.navigationController?.pushViewController(itemStateVC, animated: true)
     }*/
    
    //CellForActiveOrders
    private func getCellForActiveOrders(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let product = self.arrActiveProducts[indexPath.row]
        if let status = product.orderStatus, let orderStatus = OrderStatus(rawValue: status) {
            switch orderStatus {
            case .delivered:
                return getActiveOrderDeliveredCell(tableView: tableView, indexPath: indexPath)
            default:
                return getActiveOrderDeliveryCell(tableView: tableView, indexPath: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    private func getActiveOrderDeliveryCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ActiveOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let product = self.arrActiveProducts[indexPath.row]
        cell.delegate = self
        cell.configureViewForActiveOrder(product: product)
        return cell
    }
    
    private func getActiveOrderDeliveredCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ArchivedOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let product = self.arrActiveProducts[indexPath.row]
        cell.delegate = self
        cell.configureView(product: product)
        return cell
    }
    
    //CellForArchivedOrder
    private func getArchivedOrderCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ActiveOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let product = self.arrArchivedProducts[indexPath.row]
        cell.delegate = self
        cell.configureViewForArchivedOrder(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.btnActive.isSelected {
            return heightForActiveOrders(indexPath: indexPath)
        } else {
            return 150.0
        }
    }
    
    //Height for ActiveOrders
    private func heightForActiveOrders(indexPath: IndexPath) -> CGFloat {
        let product = self.arrActiveProducts[indexPath.row]
        if let shipping = product.shipping, let shippingType = productShipping(rawValue: shipping), let status = product.orderStatus, let orderStatus = OrderStatus(rawValue: status)  {
            
            if shippingType == .buyerWillPay || shippingType == .iWillPay || shippingType == .homeDelivery {
                if orderStatus == .onTheWay || orderStatus == .delivered {
                    return 195.0
                } else {
                    return 150.0
                }
            } else {
                if orderStatus == .delivered {
                    return 195.0
                } else {
                   return 150.0
                }
            }
        }
        return 195.0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
}

//MARK: - ActiveOrderCellDelegate
extension BuyerOrderListViewC: ActiveOrderCellDelegate {
    func didTapTrackOrder(_ cell: UITableViewCell) {
        if let indexPath = self.tblViewOrders.indexPath(for: cell) {
            let product = self.arrActiveProducts[indexPath.row]
            if let trackOrderVC = DIConfigurator.sharedInst().getTrackOrderViewC() {
                trackOrderVC.order = product
                self.navigationController?.pushViewController(trackOrderVC, animated: true)
            }
        }
        
    }
}

//MARK: - ArchivedOrderCellDelegate
extension BuyerOrderListViewC: ArchivedOrderCellDelegate {
    func didTapFeedback(_ cell: UITableViewCell) {
        guard let indexPath = self.tblViewOrders.indexPath(for: cell) else { return }
        if let orderDetailId = self.arrActiveProducts[indexPath.row].orderDetailId {
            self.pushToFeedbackView(orderDetailId: orderDetailId)
        }
    }
}

//MARK: - UITextFieldDelegates
extension BuyerOrderListViewC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            self.perform(#selector(requestToSearch(text:)), with: finalText, afterDelay: 0.5)
        }
        return true
    }
}
