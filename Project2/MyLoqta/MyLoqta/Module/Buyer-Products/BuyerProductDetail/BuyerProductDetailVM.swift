//
//  BuyerProductDetailVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 27/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyUserDefaults

protocol BuyerProductDetailVModeling {
    
    func getRelatedItem(itemId: Int, completion: @escaping (_ array: [Product]) ->Void)
    func getMoreFromSeller(itemId: Int, completion: @escaping (_ array: [Product]) ->Void)
    func requestGetProductDetail(productId: Int, detailType: Int, completion: @escaping (_ product: Product, _ isDeleted: Bool) ->Void)
    func requestToQuestionAnswer(itemId: Int, completion: @escaping (_ array: [Question]) ->Void)
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
    func requestReportProduct(param: [String: AnyObject], completion: @escaping (Bool) ->Void)
    func requestToAskQuestion(param: [String: AnyObject], completion: @escaping (_ success: Bool) ->Void)
    func requestToAddCartItem(param: [String: AnyObject], completion: @escaping (_ cartId: Int) -> Void)
    func requestToCheckCartSeller(completion: @escaping (Int) -> Void)
}

class BuyerProductDetailVM: BaseModeling, BuyerProductDetailVModeling {
    
    //MARK: - API Methods
    func requestGetProductDetail(productId: Int, detailType: Int, completion: @escaping (_ product: Product, _ isDeleted: Bool) ->Void) {
        let params = ["itemId": productId as AnyObject, "type": detailType as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .viewItem(param: params)), completionHandler: { (response, success) in
            if success,let data = response as? [String: AnyObject], let newResponse = data[kResult] as? [String: AnyObject] {
                if let product = Product.formattedData(data: newResponse) {
                    completion(product, false)
                }
            } else if let dataObject = response as? [String: AnyObject] , let errorCode = dataObject["Status"] as? Int, errorCode == 302 {
                completion(Product(), true)
            }

        })
    }
    
    func getRelatedItem(itemId: Int, completion: @escaping (_ array: [Product]) ->Void)  {
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject,
                                          "type": 0 as AnyObject,
                                          "page": 0 as AnyObject,
                                          "userId": UserSession.sharedSession.getUserId() as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .suggestionItems(param: param, isShowLoader: false)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
    
    func getMoreFromSeller(itemId: Int, completion: @escaping (_ array: [Product]) ->Void)  {
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject,
                                          "type": 1 as AnyObject,
                                          "page": 0 as AnyObject,
                                          "userId": UserSession.sharedSession.getUserId() as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .suggestionItems(param: param, isShowLoader: false)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
    
    func requestToQuestionAnswer(itemId: Int, completion: @escaping (_ array: [Question]) ->Void) {
        //questionAnswers
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject,
                                          "page": 0 as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .questionAnswers(param: param)), completionHandler: { (response, success) in
            if success, let resut = response as? [[String: Any]] {
                let array = Mapper<Question>().mapArray(JSONArray: resut)
                if array.count > 0 {
                    completion(array)
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
    
    func requestToAskQuestion(param: [String: AnyObject], completion: @escaping (_ success: Bool) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .askQuestion(param: param)), completionHandler: { (response, success) in
            print(response)
            completion(success)
        })
    }
    
    func requestToAddCartItem(param: [String : AnyObject], completion: @escaping (Int) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .addCartItem(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let cartId = result["cartId"] as? Int {
                   completion(cartId)
                }
            }
        })
    }
    
    func requestToCheckCartSeller(completion: @escaping (Int) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .cartSellerId()), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let sellerId = result["sellerId"] as? Int {
                    completion(sellerId)
                }
            }
        })
    }
}
