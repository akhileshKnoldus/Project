//
//  InsightViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension InsightViewC {
    
    //HeaderCell
    private func getInsightHeaderCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: InsightHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if self.btnStatistic.isSelected {
            cell.configureViewForStatistics(category: self.strCategoryName, filterType: self.filterDuration)
        } else if self.btnSearches.isSelected {
            cell.configureViewForSearches(category: self.strCategoryName, filterType: self.filterDuration)
        } else {
            cell.configureViewForSelling(category: self.strCategoryName, filterType: self.filterDuration)
        }
        return cell
    }
    
    //Revenue Cell
    private func getStatsRevenueCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: StatsRevenueCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let stats = self.myStatistics {
            cell.configureViewForRevenue(insightStat: stats, filterType: self.filterDuration)
        }
        return cell
    }
    
    //GraphCell
    private func getGraphCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: GraphTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let arrGraphData = self.myStatistics?.graphView {
            cell.configureView(graphData: arrGraphData, filterType: self.filterDuration)
        }
        return cell
    }
    
    //OrderListCell
    private func getStatsListingCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: StatsListingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let insightStats = self.myStatistics {
            cell.configureViewForStoreStats(indexPath: indexPath, insightStat: insightStats)
        }
        return cell
    }
    
    //SearchStatsCell
    private func getSearchStatsCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: SellingProgressCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let index = indexPath.row - 1
        let insightSearchData = self.searchData[index]
        cell.configureViewForSearch(insightData: insightSearchData)
        return cell
    }
    
    //SellingStatsCell
    private func getSellingStatsCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: SellingProgressCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let index = indexPath.row - 1
        let insightSearchData = self.sellingData[index]
        cell.configureViewForSelling(insightData: insightSearchData)
        return cell
    }
    
    //NoDataCell
    private func getNoDataCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: NoDataCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}

extension InsightViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.dataSource[indexPath.row].cellType
        switch cellType {
            
        case StatsCell.headerCell.rawValue:
            return getInsightHeaderCell(indexPath, tableView: tableView)
            
        case StatsCell.revenueCell.rawValue:
            return getStatsRevenueCell(indexPath, tableView: tableView)
            
        case StatsCell.graphCell.rawValue:
            return getGraphCell(indexPath, tableView: tableView)
            
        case StatsCell.orderCountCell.rawValue:
            return getStatsListingCell(indexPath, tableView: tableView)
            
        case StatsCell.searchStatCell.rawValue:
            return getSearchStatsCell(indexPath, tableView: tableView)
            
        case StatsCell.sellingStatCell.rawValue:
            return getSellingStatsCell(indexPath, tableView: tableView)
            
        case StatsCell.noDataCell.rawValue:
            return getNoDataCell(indexPath, tableView: tableView)
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = self.dataSource[indexPath.row].height
        return cellHeight
    }
}

extension InsightViewC: InsightHeaderCellDelegate {
    func didTapCategories() {
        self.showCategoryPopup()
    }
    
    func didTapFilter() {
        self.showFilter()
    }
}
