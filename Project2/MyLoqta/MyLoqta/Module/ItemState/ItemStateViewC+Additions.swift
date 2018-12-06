//
//  ItemStateViewC+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension ItemStateViewC {
    
    func registerNib() {
        //OrderIdDateCell DetailProductTypeCell , SellerCell for buyer cell
        // Driver
        self.tblViewProduct.register(ItemImageTableCell.self)
        self.tblViewProduct.register(RejectedCell.self)
        self.tblViewProduct.register(OrderTrackingCell.self)
        self.tblViewProduct.register(ItemNamePriceCell.self)
        self.tblViewProduct.register(ItemDescriptionCell.self)
        self.tblViewProduct.register(ItemStateQuantity.self)
        
        self.tblViewProduct.register(OrderIdDateCell.self)
        self.tblViewProduct.register(ItemCell.self)
        
        self.tblViewProduct.register(DriverCell.self)
        
        self.tblViewProduct.register(ItemPriceCell.self)
        self.tblViewProduct.register(DetailProductTypeCell.self)
        self.tblViewProduct.register(SellerCell.self)
        
        //self.tblViewOrderDetail.register(PaymentMethodCell.self)
        
    }
}

extension ItemStateViewC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let _ = self.orderDetail else { return 0 }
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return self.arrayProductDetail.count
        case 1: return self.arrayProductType.count
        case 2: return 3
        case 3: return self.arrayDriver.count
        case 4: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1: return 0
        case 2: return 20
        case 3: return (self.arrayDriver.count > 0  ? 20 : 0)
        case 4: return 20
        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return self.getCellHeight(indexPath: indexPath)
        case 1: return UITableViewAutomaticDimension
        case 2: return self.getThirdSectionHt(indexPath: indexPath)
        case 3: return 88
        case 4: return 62
        default: return UITableViewAutomaticDimension
        }
    }
    
    func getThirdSectionHt(indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 88
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        
        if let cellType = self.arrayProductDetail[indexPath.row][Constant.keys.kCellType] as? CellType {
            switch cellType {
            case .imageCell: return (191.0 * Constant.htRation)
            case .orderIdDateCell: return 65
            case .orderProgressCell: return 63
            case .rejectedCell: return UITableViewAutomaticDimension
            case .itemNameCell: return UITableViewAutomaticDimension
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 20))
        view.backgroundColor = UIColor.defaultBgColor
        return view
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: return self.getItemDetailCell(tableView: tableView, indexPath: indexPath)
        case 1: return self.getItemTypeCell(tableView: tableView, indexPath: indexPath)
        case 2: return self.getThirdSectionCell(tableView: tableView, indexPath: indexPath)
        case 3: return self.getDriverCell(tableView: tableView, indexPath: indexPath)
        case 4: return self.getItemPriceQuantityCell(tableView: tableView, indexPath: indexPath)
        default: break
        }
        return UITableViewCell()
    }
    
    func getItemDetailCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let data = self.arrayProductDetail[indexPath.row]
        if let cellType = data[Constant.keys.kCellType] as? CellType {
            switch cellType {
            case .imageCell:
                let cell: ItemImageTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: data)
                cell.btnBack.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
                return cell
            case .orderIdDateCell:
                let cell: OrderIdDateCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: data)
                return cell
            case .orderProgressCell:
                let cell: OrderTrackingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: data)
                return cell
            case .rejectedCell:
                let cell: RejectedCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: data)
                return cell
            case .itemNameCell:
                let cell: ItemNamePriceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: data)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func getItemTypeCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.arrayProductType[indexPath.row])
        return cell
    }
    
    func getThirdSectionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: SellerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let order = self.orderDetail {
                cell.configureCell(orderDetail: order)
            }
            return cell
        } else {
            let cell: ItemDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let order = self.orderDetail {
                var newIndexPath = indexPath
                newIndexPath.row = newIndexPath.row - 1
                cell.configureAddressCell(order: order, indexPath: newIndexPath)
            }
            return cell
        }
    }
    
    func getDriverCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureDriverCell(driver: self.arrayDriver[indexPath.row])
        return cell
    }
    
    func getItemPriceQuantityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemStateQuantity = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let order = self.orderDetail {
            cell.configureCell(order: order)
        }
        return cell
    }
}
