//
//  BuyerAcceptOrderViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension BuyerAcceptOrderViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return self.getItemDetailCell(tableView:tableView, indexPath:indexPath)
        case 3: return self.getSellerCell(tableView:tableView, indexPath:indexPath)
        case 4: return self.getOrderPriceCell(tableView:tableView, indexPath:indexPath)
        default: return self.getItemDescriptionCell(tableView:tableView, indexPath:indexPath)
        }
    }
    
    //Cells
    func getItemDetailCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func getItemDescriptionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func getSellerCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    func getOrderPriceCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderTotalPriceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 115
        case 3: return 88
        case 4: return 80
        default: return UITableViewAutomaticDimension
        }
    }
}
