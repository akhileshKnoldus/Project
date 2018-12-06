//
//  ExploreMainVM.swift
//  MyLoqta
//
//  Created by Kirti on 7/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

typealias CategoriesDetail = (title: String, imageIcon: String)

protocol ExploreMainVModeling: class {
    func getCategoryList(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [CategoryModel]) ->Void)
    func getPopularProducts(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void)
     func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
}

class ExploreMainVM: BaseModeling, ExploreMainVModeling {

    func getCategoryList(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [CategoryModel]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getCategory(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                print(result)
                let categories = Mapper<CategoryModel>().mapArray(JSONArray: result)
                print(categories)
                if categories.count > 0 {
                    completion(categories)
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
            } else if let dataObject = response as? [String: AnyObject] , let errorCode = dataObject["Status"] as? Int, errorCode == 302, let message = dataObject["Message"] as? String {
                completion(false, true, message)
            }
        })
    }
}
