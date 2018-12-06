//
//  BuyerReviewsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/22/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol BuyerReviewsVModeling: class {
    func requestGetMyReviews(page: Int, isShowLoader: Bool, completion: @escaping (_ reviewList: [Reviews]) ->Void)
}

class BuyerReviewsVM: BaseModeling, BuyerReviewsVModeling {
    
    func requestGetMyReviews(page: Int, isShowLoader: Bool, completion: @escaping (_ reviewList: [Reviews]) ->Void) {
        let params = ["page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .myReviews(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let data = response as? [[String: AnyObject]] {
                if let reviewList = Reviews.formattedArray(data: data) {
                    completion(reviewList)
                }
            }
        })
    }
}
