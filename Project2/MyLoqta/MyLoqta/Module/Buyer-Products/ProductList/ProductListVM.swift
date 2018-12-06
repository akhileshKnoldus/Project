//
//  ProductListVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProductListVModeling: class {
    func getProductsList(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void)
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
    func getRelatedItem(itemId: Int, page: Int, isShowLoader: Bool, completion: @escaping (_ array: [Product]) ->Void)
    func getMoreFromSeller(itemId: Int, page: Int, isShowLoader: Bool, completion: @escaping (_ array: [Product]) ->Void)
    func requestGetForYouItems(page: Int, isShowLoader: Bool,completion: @escaping (_ array: [Product]) ->Void)
}

class ProductListVM: BaseModeling,  ProductListVModeling {
    
    func getProductsList(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void) {
        var newParam = param
        newParam["condition"] = 0 as AnyObject
        newParam["shipping"] = 0 as AnyObject
        newParam["minPrice"] = 0 as AnyObject
        newParam["maxPrice"] = 0 as AnyObject
        newParam["sellerType"] = 0 as AnyObject
        newParam["filterKey"] = 0 as AnyObject
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getPopularProducts(param: newParam, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any], let finalResponse = result["productList"] as? [[String: Any]] {
                print(result)
                if let products = Product.formattedArray(data: finalResponse) {
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
    
    func getRelatedItem(itemId: Int, page: Int, isShowLoader: Bool, completion: @escaping (_ array: [Product]) ->Void)  {
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject,
                                          "type": 0 as AnyObject,
                                          "page": page as AnyObject,
                                          "userId": UserSession.sharedSession.getUserId() as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .suggestionItems(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
    
    func getMoreFromSeller(itemId: Int, page: Int, isShowLoader: Bool, completion: @escaping (_ array: [Product]) ->Void)  {
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject,
                                          "type": 1 as AnyObject,
                                          "page": page as AnyObject,
                                          "userId": UserSession.sharedSession.getUserId() as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .suggestionItems(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
    
    func requestGetForYouItems(page: Int, isShowLoader: Bool,completion: @escaping (_ array: [Product]) ->Void)  {
        let param: [String: AnyObject] = ["page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .forYou(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
}
