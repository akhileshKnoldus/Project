//
//  HomeVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

typealias HomeFeedType = (cellType: Int , height: CGFloat)

protocol HomeVModeling: class {
    func getHomeFeedDetails(page: Int, isShowLoader: Bool, completion: @escaping (HomeFeed) ->Void)
    func getDatasourceForHomeFeed(homeFeedData: HomeFeed, page: Int, previousDataSource: [[HomeFeedType]]) -> [[HomeFeedType]]
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
    func requestReportProduct(param: [String: AnyObject], completion: @escaping (Bool) ->Void)
}

class HomeVM: BaseModeling, HomeVModeling {
    
    func getDatasourceForHomeFeed(homeFeedData: HomeFeed, page: Int, previousDataSource: [[HomeFeedType]]) -> [[HomeFeedType]] {
        var arrayDataSource = previousDataSource
        let feedFirstCell = HomeFeedType(HomeFeedsCell.firstFeedCell.rawValue, 491.0)
        let forYouCell = HomeFeedType(HomeFeedsCell.forYouCell.rawValue, 351.0)
        let secondFeedCell = HomeFeedType(HomeFeedsCell.secondFeedCell.rawValue, 491.0)
        let categoryCell = HomeFeedType(HomeFeedsCell.categoryCell.rawValue, 335)
        let lastFeedCell = HomeFeedType(HomeFeedsCell.lastFeedCell.rawValue, 491.0)
        
        //FirstFeed
        if let arrFirstFeed = homeFeedData.feedFirst, arrFirstFeed.count > 0, page == 1 {
            var firstFeedDataSource = [HomeFeedType]()
            for _ in arrFirstFeed {
                firstFeedDataSource.append(contentsOf: [feedFirstCell])
            }
            arrayDataSource.append(firstFeedDataSource)
        }
        
        //ForYou
        if let forYouData = homeFeedData.forYou, forYouData.count > 0, page == 1 {
            var forYouDataSource = [HomeFeedType]()
            forYouDataSource.append(contentsOf: [forYouCell])
            arrayDataSource.append(forYouDataSource)
        }
        
        //SecondFeed
        if let arrSecondFeed = homeFeedData.feedSecond, arrSecondFeed.count > 0, page == 1 {
            var secondFeedDataSource = [HomeFeedType]()
            for _ in arrSecondFeed {
                secondFeedDataSource.append(contentsOf: [secondFeedCell])
            }
            arrayDataSource.append(secondFeedDataSource)
        }
        
        //Category
        if let category = homeFeedData.category, let _ = category.name, page == 1 {
            var categoryDataSource = [HomeFeedType]()
            categoryDataSource.append(contentsOf: [categoryCell])
            arrayDataSource.append(categoryDataSource)
        }
        
        //LastFeed
        if let arrLastFeed = homeFeedData.feedLast, arrLastFeed.count > 0 {
            var lastFeedDataSource = [HomeFeedType]()
            for _ in arrLastFeed {
                lastFeedDataSource.append(contentsOf: [lastFeedCell])
            }
            if page > 2 {
                let lastIndex = arrayDataSource.count - 1
                arrayDataSource[lastIndex] = arrayDataSource[lastIndex] + lastFeedDataSource
            } else {
                arrayDataSource.append(lastFeedDataSource)
            }
        }
        
        return arrayDataSource
    }
    
    func getHomeFeedDetails(page: Int, isShowLoader: Bool, completion: @escaping (HomeFeed) ->Void) {
        let param: [String: AnyObject] = ["page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .homeFeed(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let homeFeedData = Mapper<HomeFeed>().map(JSON:result) {
                    completion(homeFeedData)
                }
            }
        })
    }
    
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .likeProduct(param: param)), completionHandler: { (response, success) in
            print(response)
            if success {
                //print(result)
                completion(success, false, "")
            } else if let dataObject = response as? [String: AnyObject] , let errorCode = dataObject["Status"] as? Int, errorCode == 302, let message = dataObject["Message"] as? String {
                completion(false, true, message)
            }
        })
    }
    
    func requestReportProduct(param: [String: AnyObject], completion: @escaping (Bool) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .reportProduct(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                print(result)
                completion(success)
            }
        })
    }
}
