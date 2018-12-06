//
//  ReviewsAboutBuyerVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/5/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ReviewsAboutBuyerVModeling: class {
    func requestGetReviewsAboutBuyer(page: Int, isShowLoader: Bool, completion: @escaping (_ ratingCount: Int, _ ratingStar: Double, _ reviewList: [Reviews]) ->Void)
}

class ReviewsAboutBuyerVM: BaseModeling, ReviewsAboutBuyerVModeling {
    
    //MARK: - API Methods
    func requestGetReviewsAboutBuyer(page: Int, isShowLoader: Bool, completion: @escaping (_ ratingCount: Int, _ ratingStar: Double, _ reviewList: [Reviews]) ->Void) {
        let params = ["page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .reviewsAboutMe(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let data = response as? [String: AnyObject], let ratingCount = data["ratingCount"] as? Int, let ratingStar = data["ratingStar"] as? Double, let newResponse = data["reviewAboutMe"] as? [[String: AnyObject]] {
                if let reviewList = Reviews.formattedArray(data: newResponse) {
                    completion(ratingCount, ratingStar, reviewList)
                }
            }
        })
    }
}
