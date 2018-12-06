//
//  InsightVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

typealias InsightStatsType = (cellType: Int , height: CGFloat)

protocol InsightVModeling: class {
    func getDatasourceForStats() -> [InsightStatsType]
    func getDatasourceForSearchStats(insightSearchStats: [InsightSelling]) -> [InsightStatsType]
    func getDatasourceForSellingStats(insightSearchStats: [InsightSelling]) -> [InsightStatsType]
    func getCategoryList(param: [String: AnyObject], completion: @escaping (_ arrayCategory: [[String: Any]]) ->Void)
    func requestGetMyStatistics(listType: Int, isShowLoader: Bool, completion: @escaping (_ statistics: InsightStats) ->Void)
    func requestGetInsightSearch(listType: Int, categoryId: Int, isShowLoader: Bool, completion: @escaping (_ insightSearch: [InsightSelling]) ->Void)
    func requestGetInsightSelling(listType: Int, categoryId: Int, isShowLoader: Bool, completion: @escaping (_ insightSelling: [InsightSelling]) ->Void)
}

class InsightVM: BaseModeling, InsightVModeling {
    
    
    //DataSourceForStoreStats
    func getDatasourceForStats() -> [InsightStatsType] {
        
        //ProductDataSource
        var arrStatsDataSource = [InsightStatsType]()
        
        //HeaderCell
        let headerCell = InsightStatsType(StatsCell.headerCell.rawValue, StatsCell.headerCell.height)
        arrStatsDataSource.append(headerCell)
        
        //RevenueCell
        let revenueCell = InsightStatsType(StatsCell.revenueCell.rawValue, StatsCell.revenueCell.height)
        arrStatsDataSource.append(revenueCell)
        
        //GraphCell
        let graphCell = InsightStatsType(StatsCell.graphCell.rawValue, StatsCell.graphCell.height)
        arrStatsDataSource.append(graphCell)
        
        //ActiveListingCell
        let productListingCell = InsightStatsType(StatsCell.orderCountCell.rawValue, StatsCell.orderCountCell.height)
        arrStatsDataSource.append(productListingCell)
        
        //OrderCountCell
        arrStatsDataSource.append(productListingCell)
        
        //SoldOrderCell
        arrStatsDataSource.append(productListingCell)
        
        return arrStatsDataSource
    }
    
    //DataSourceForSearchStats
    func getDatasourceForSearchStats(insightSearchStats: [InsightSelling]) -> [InsightStatsType] {
        
        //ProductDataSource
        var arrStatsDataSource = [InsightStatsType]()
        
        //HeaderCell
        let headerCell = InsightStatsType(StatsCell.headerCell.rawValue, StatsCell.headerCell.height)
        arrStatsDataSource.append(headerCell)
        
        //SearchStatsCell
        let searchStatsCell = InsightStatsType(StatsCell.searchStatCell.rawValue, StatsCell.searchStatCell.height)
        for _ in insightSearchStats {
            arrStatsDataSource.append(searchStatsCell)
        }
        
        //NoDataCell
        if insightSearchStats.count == 0 {
            let noDataCell = InsightStatsType(StatsCell.noDataCell.rawValue, StatsCell.noDataCell.height)
            arrStatsDataSource.append(noDataCell)
        }
        
        return arrStatsDataSource
    }
    
    //DataSourceForSellingStats
    func getDatasourceForSellingStats(insightSearchStats: [InsightSelling]) -> [InsightStatsType] {
        
        //ProductDataSource
        var arrStatsDataSource = [InsightStatsType]()
        
        //HeaderCell
        let headerCell = InsightStatsType(StatsCell.headerCell.rawValue, StatsCell.headerCell.height)
        arrStatsDataSource.append(headerCell)
        
        //SellingStatsCell
        let sellingStatsCell = InsightStatsType(StatsCell.sellingStatCell.rawValue, StatsCell.sellingStatCell.height)
        for _ in insightSearchStats {
            arrStatsDataSource.append(sellingStatsCell)
        }
        
        //NoDataCell
        if insightSearchStats.count == 0 {
            let noDataCell = InsightStatsType(StatsCell.noDataCell.rawValue, StatsCell.noDataCell.height)
            arrStatsDataSource.append(noDataCell)
        }
        
        return arrStatsDataSource
    }
    
    //MARK: - API Methods
    func getCategoryList(param: [String: AnyObject], completion: @escaping (_ arrayCategory: [[String: Any]]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getCategory(param: param, isShowLoader: false)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                completion(result)
            }
        })
    }
    
    func requestGetMyStatistics(listType: Int, isShowLoader: Bool, completion: @escaping (_ statistics: InsightStats) ->Void) {
        let params = ["type": listType as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .myStatistic(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let myStats = Mapper<InsightStats>().map(JSON:newResponse) {
                    completion(myStats)
                }
            }
        })
    }
    
    func requestGetInsightSearch(listType: Int, categoryId: Int, isShowLoader: Bool, completion: @escaping (_ insightSearch: [InsightSelling]) ->Void) {
        let params = ["type": listType as AnyObject, "categoryId": categoryId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .insightSearch(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [[String: AnyObject]] {
                if let searchStats = InsightSelling.formattedArray(data: newResponse) {
                    completion(searchStats)
                }
            }
        })
    }
    
    func requestGetInsightSelling(listType: Int, categoryId: Int, isShowLoader: Bool, completion: @escaping (_ insightSelling: [InsightSelling]) ->Void) {
        let params = ["type": listType as AnyObject, "categoryId": categoryId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .insightSelling(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [[String: AnyObject]] {
                if let sellingStats = InsightSelling.formattedArray(data: newResponse) {
                    completion(sellingStats)
                }
            }
        })
    }
}
