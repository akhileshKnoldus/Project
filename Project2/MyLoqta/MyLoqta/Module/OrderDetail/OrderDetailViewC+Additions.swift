//
//  OrderDetailViewC+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 11/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension OrderDetailViewC {
    
    func registerNib() {
        self.tblViewOrderDetail.register(OrderIdDateCell.self)
        self.tblViewOrderDetail.register(ItemCell.self)
        self.tblViewOrderDetail.register(OrderTrackingCell.self)
        self.tblViewOrderDetail.register(DriverCell.self)
        self.tblViewOrderDetail.register(PaymentMethodCell.self)
        self.tblViewOrderDetail.register(ItemPriceCell.self)
        self.tblViewOrderDetail.register(DetailProductTypeCell.self)
        self.tblViewOrderDetail.register(SellerCell.self)
        self.tblViewOrderDetail.register(ItemDescriptionCell.self)
        
    }
}

extension OrderDetailViewC: UITableViewDataSource, UITableViewDelegate {
    
    
    func getFirstSectionHeight(indexPath: IndexPath) -> CGFloat {
        //Constant.keys.kCellType
        let data = self.arrayOrderStatus[indexPath.row]
        if let cellType = data[Constant.keys.kCellType] as? CellType {
            switch cellType {
            case .orderIdDateCell: return 65
            case .orderProgressCell: return 63
            default: return 0
            }
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.orderDetail else { return 0 }
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return self.arrayOrderStatus.count
        case 1: return 1
        case 2: return 2
        case 3: return 1
        case 4: return self.arrayDriver.count
        case 5: return 1
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return self.getFirstSectionHeight(indexPath: indexPath) //50 //case 1: return 63
        case 1: return 107
        case 2: return UITableViewAutomaticDimension
        case 3: return 88
        case 4: return 89
        case 5: return 80
        default: return 95
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return getOrderIdDateCell(tableView: tableView, indexPath: indexPath)
        //case 1: return getOrderTrackingCell(tableView: tableView, indexPath: indexPath)
        case 1: let extractedExpr = getOrderItemCell(tableView: tableView, indexPath: indexPath)
        return extractedExpr
        case 2: return getItemDescriptionCell(tableView: tableView, indexPath: indexPath)
        case 3: return getSellerCell(tableView: tableView, indexPath: indexPath)
        case 4: return getDriverCell(tableView: tableView, indexPath: indexPath)
        case 5: return getPaymentCell(tableView: tableView, indexPath: indexPath)
        default: return getItemPriceCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ((section == 5) && (self.arrayDriver.count == 0)) {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 10))
        header.backgroundColor = .clear //UIColor.viewBgColor
        return header
    }
    
    func getOrderIdDateCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let data = self.arrayOrderStatus[indexPath.row]
        if let cellType = data[Constant.keys.kCellType] as? CellType {
            switch cellType {
            case .orderIdDateCell:
                let cell: OrderIdDateCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: data)
                return cell
            case .orderProgressCell: return self.getOrderTrackingCell(tableView: tableView, indexPath: indexPath)
            default: break
            }
        }
        return UITableViewCell()
        
    }
    
    func getOrderTrackingCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderTrackingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.arrayOrderStatus[indexPath.row])
        return cell
    }
    
    func getOrderItemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let order = self.orderDetail {
            cell.configureCell(order: order)
        }
        return cell
    }
    
    func getItemDescriptionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let order = self.orderDetail {
            cell.configureAddressCell(order: order, indexPath: indexPath)
        }
        
        return cell
    }
    
    func getSellerCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let order = self.orderDetail {
            cell.configureSellerCell(orderDetail: order)
        }
        
        return cell
    }
    
    func getDriverCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DriverCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.arrayDriver[indexPath.row]
        cell.configureDriverCell(data: data)
        return cell
    }
    
    func getPaymentCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentMethodCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let order = self.orderDetail {
            cell.configureCell(order: order)
        }
        return cell
    }
    
    func getItemPriceCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemPriceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let order = self.orderDetail {
            cell.configureCell(order: order)
        }
        return cell
    }
    
}

