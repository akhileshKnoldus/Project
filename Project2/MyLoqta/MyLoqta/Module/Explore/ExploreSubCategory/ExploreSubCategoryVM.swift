//
//  ExploreSubCategoryVM.swift
//  MyLoqta
//
//  Created by Kirti on 7/24/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

protocol ExploreSubCategoryVModeling: class {
    func getSubCategoryProducts(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void)
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
}

class ExploreSubCategoryVM: BaseModeling, ExploreSubCategoryVModeling {

    func getSubCategoryProducts(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping (_ arrayProduct: [Product]) ->Void) {
        
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getPopularProducts(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            print(response)
            if success, let data = response as? [String: AnyObject],  let result = data["productList"] as? [[String: Any]] {
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
}
