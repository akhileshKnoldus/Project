//
//  SellerSoldProductsViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension SellerSoldProductsViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSoldProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForSoldProducts(tableView, indexPath:indexPath)
    }
    
    private func getCellForSoldProducts(_ tableView: UITableView, indexPath: IndexPath) -> SoldProductsCell {
        let cell: SoldProductsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let product = self.arrSoldProducts[indexPath.row]
        cell.delegate = self
        cell.configureView(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 255.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.arrSoldProducts.count > 0 {
            let view = UIView()
            view.backgroundColor = .white
            let lblItems = UILabel(frame: CGRect(x: 15, y: 15, width: 150, height: 20))
            lblItems.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
            lblItems.textColor = UIColor.colorWithRGBA(redC: 16.0, greenC: 16.0, blueC: 16.0, alfa: 1.0)
            let count = self.totalProducts
            lblItems.text = count > 1 ? "\(count) " + "items".localize() : "\(count) " + "item".localize()
            view.addSubview(lblItems)
            let lblRecent = UILabel(frame: CGRect(x: Constant.screenWidth - 95, y: 15, width: 80, height: 20))
            lblRecent.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
            lblRecent.textColor = UIColor.colorWithRGBA(redC: 248.0, greenC: 150.0, blueC: 75.0, alfa: 1.0)
            lblRecent.textAlignment = .right
            lblRecent.text = "Recent".localize()
            view.addSubview(lblRecent)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.arrSoldProducts.count > 0 {
            return 45.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.arrSoldProducts[indexPath.row]
        if let orderDVC = DIConfigurator.sharedInst().getItemStateVC(), let orderId = product.orderDetailId  {
            orderDVC.orderDetailId = orderId
            orderDVC.itemId = product.itemId
            self.navigationController?.pushViewController(orderDVC, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
}

extension SellerSoldProductsViewC: SoldProductsCellDelegate {
    func didTapFeedback(_ cell: UITableViewCell) {
        guard let indexPath = self.tblViewOrders.indexPath(for: cell) else { return }
        if let orderDetailId = self.arrSoldProducts[indexPath.row].orderDetailId {
            self.pushToFeedbackView(orderDetailId: orderDetailId)
        }
    }
}

