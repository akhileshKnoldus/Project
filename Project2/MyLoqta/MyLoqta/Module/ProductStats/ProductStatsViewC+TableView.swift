//
//  ProductStatsViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension ProductStatsViewC {
    
    //HeaderCell
    private func getProductStatsHeaderCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: StatsHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureView(itemName: self.itemName, itemImage: self.itemImage, filterType: self.filterDuration)
        return cell
    }
    
    //Revenue Cell
    private func getStatsViewLikeCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: StatsRevenueCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        switch indexPath.row {
        case 1:
            cell.configureViewForViews(productStat: self.productStats, filterType: self.filterDuration)
        case 4:
            cell.configureViewForLikes(productStat: self.productStats, filterType: self.filterDuration)
        default:
            break
        }
        return cell
    }
    
    //GraphCell
    private func getGraphCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: GraphTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        switch indexPath.row {
        case 2:
            if let arrGraphData = self.productStats?.viewedProductsGraph {
                cell.configureView(graphData: arrGraphData, filterType: self.filterDuration)
            }
        case 5:
            if let arrGraphData = self.productStats?.likedProductsGraph {
                cell.configureView(graphData: arrGraphData, filterType: self.filterDuration)
            }
        default:
            break
        }
        return cell
    }
    
    //OrderListCell
    private func getStatsListingCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: StatsListingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let productStat = self.productStats {
            cell.configureViewForProductStats(indexPath: indexPath, productStat: productStat, filterType: self.filterDuration)
        }
        return cell
    }
}

extension ProductStatsViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.dataSource[indexPath.row].cellType
        switch cellType {
            
        case StatsCell.productStatsHeaderCell.rawValue:
            return getProductStatsHeaderCell(indexPath, tableView: tableView)
            
        case StatsCell.revenueCell.rawValue:
            return getStatsViewLikeCell(indexPath, tableView: tableView)
            
        case StatsCell.graphCell.rawValue:
            return getGraphCell(indexPath, tableView: tableView)
            
        case StatsCell.orderCountCell.rawValue:
            return getStatsListingCell(indexPath, tableView: tableView)
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = self.dataSource[indexPath.row].height
        return cellHeight
    }
}

extension ProductStatsViewC: StatsHeaderCellDelegate {
    
    func didTapStatsFilter() {
        self.showFilter()
    }
}
