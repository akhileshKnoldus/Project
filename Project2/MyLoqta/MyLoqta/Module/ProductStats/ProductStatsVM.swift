//
//  ProductStatsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ProductStatsVModeling: class {
    func getDatasourceForProductStats() -> [InsightStatsType]
    func requestGetProductStatistics(itemId: Int, listType: Int, completion: @escaping (_ statistics: ProductStats) ->Void)
}

class ProductStatsVM: BaseModeling, ProductStatsVModeling {
    
    //DataSourceForStoreStats
    func getDatasourceForProductStats() -> [InsightStatsType] {
        
        //ProductDataSource
        var arrStatsDataSource = [InsightStatsType]()
        
        //HeaderCell
        let headerCell = InsightStatsType(StatsCell.productStatsHeaderCell.rawValue, StatsCell.productStatsHeaderCell.height)
        arrStatsDataSource.append(headerCell)
        
        //ViewsCountCell
        let viewsCountCell = InsightStatsType(StatsCell.revenueCell.rawValue, StatsCell.revenueCell.height)
        arrStatsDataSource.append(viewsCountCell)
        
        //ViewGraphCell
        let graphCell = InsightStatsType(StatsCell.graphCell.rawValue, StatsCell.graphCell.height)
        arrStatsDataSource.append(graphCell)
        
        //AverageViewCell
        let averageViewCell = InsightStatsType(StatsCell.orderCountCell.rawValue, StatsCell.orderCountCell.height)
        arrStatsDataSource.append(averageViewCell)
        
        //LikesCountCell
        arrStatsDataSource.append(viewsCountCell)
        
        //LikeGraphCell
        arrStatsDataSource.append(graphCell)
        
        //AverageLikeCell
        arrStatsDataSource.append(averageViewCell)
        
        return arrStatsDataSource
    }
    
    
    
    //MARK: - API Methods
    func requestGetProductStatistics(itemId: Int, listType: Int, completion: @escaping (_ statistics: ProductStats) ->Void) {
        let params = ["itemId": itemId as AnyObject, "type": listType as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .viewItemStats(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let myStats = Mapper<ProductStats>().map(JSON:newResponse) {
                    completion(myStats)
                }
            }
        })
    }
}
