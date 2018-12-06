//
//  ExploreCategoryVM.swift
//  MyLoqta
//
//  Created by Kirti on 7/21/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

protocol ExploreCategoryVModeling: class {
    func getSubCategory(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [SubCategoryModel]) ->Void)
    func getPopularProducts(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void)
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
    func requestFollowCategory(categoryId: Int, isFollow: Bool, completion: @escaping (Bool) ->Void)
}

class ExploreCategoryVM: BaseModeling, ExploreCategoryVModeling {
    
    func getSubCategory(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [SubCategoryModel]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getSubCategory(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                print(result)
                let subCategories = Mapper<SubCategoryModel>().mapArray(JSONArray: result)
                print(subCategories)
                if subCategories.count > 0 {
                    completion(subCategories)
                }
            }
        })
    }
    
    func getPopularProducts(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void) {
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
            } else if let dataObject = response as? [String: AnyObject] , let errorCode = dataObject["Status"] as? Int, errorCode == 302, let message = dataObject["Message"] as? String{
                completion(false, true, message)
            }
        })
    }
    
    func requestFollowCategory(categoryId: Int, isFollow: Bool, completion: @escaping (Bool) ->Void)  {
        let param: [String: AnyObject] = ["categoryId" : categoryId as AnyObject,
                                          "isFollow" : isFollow as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .followCategory(param: param)), completionHandler: { (response, success) in
            if success, let result = response as? [String: Any] {
                completion(success)
            }
        })
    }
}
