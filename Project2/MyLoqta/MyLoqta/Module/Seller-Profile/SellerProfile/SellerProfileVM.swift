//
//  ManageStoreProductsVM.swift
//  MyLoqta
//
//  Created by Kirti on 7/25/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol SellerProfileVModeling: class {
    func requestGetSellerProfile(sellerId: Int, completion: @escaping (_ user: SellerDetail) ->Void)
    func getSellerProductsList(param: [String: AnyObject], completion: @escaping (_ arrayProduct: [Product]) ->Void)
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
    func requestFollowSeller(followingId: Int, isFollow: Bool, completion: @escaping (Bool) ->Void)
    func requestGetSellerReviews(sellerId: Int, page: Int, completion: @escaping (_ ratingCount: Int, _ ratingStar: Double, _ reviewList: [Reviews]) ->Void)
}

class SellerProfileVM: BaseModeling, SellerProfileVModeling {
    
    func requestGetSellerProfile(sellerId: Int, completion: @escaping (_ user: SellerDetail) ->Void) {

        let params = ["sellerId": sellerId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .sellerProfile(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let seller = SellerDetail.formattedData(data: newResponse) {
                    completion(seller)
                }
            }
        })
    }
    
    func getSellerProductsList(param: [String: AnyObject], completion: @escaping (_ arrayProduct: [Product]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getActiveProducts(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                print(result)
                if let products = Product.formattedArray(data: result) {
                    print(products)
                    if products.count > 0 {
                        completion(products)
                    }
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
    
    func requestFollowSeller(followingId: Int, isFollow: Bool, completion: @escaping (Bool) ->Void)  {
        let param: [String: AnyObject] = ["followingId" : followingId as AnyObject,
                                          "isFollow" : isFollow as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .follower(param: param)), completionHandler: { (response, success) in
            if success {
                completion(success)
            }
        })
    }
    
    //MARK: - API Methods
    func requestGetSellerReviews(sellerId: Int, page: Int, completion: @escaping (_ ratingCount: Int, _ ratingStar: Double, _ reviewList: [Reviews]) ->Void) {
        let params = ["sellerId": sellerId as AnyObject, "page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .productReviews(param: params)), completionHandler: { (response, success) in
            if success, let data = response as? [String: AnyObject], let ratingCount = data["ratingCount"] as? Int, let ratingStar = data["ratingStar"] as? Double, let newResponse = data["reviewAboutMe"] as? [[String: AnyObject]] {
                if let reviewList = Reviews.formattedArray(data: newResponse) {
                    completion(ratingCount, ratingStar, reviewList)
                }
            }
        })
    }
}
