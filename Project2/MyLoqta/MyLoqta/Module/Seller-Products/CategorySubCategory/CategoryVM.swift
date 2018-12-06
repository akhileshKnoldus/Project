//
//  CategoryVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

protocol CategoryVModeling {
    
    func getCategory(param: [String: AnyObject], completion: @escaping (_ arrayProduct: [CategoryModel]) ->Void)
    func getSubCategory(param: [String: AnyObject], completion: @escaping (_ arrayProduct: [SubCategoryModel]) ->Void)
    //(param: [String: AnyObject], completion: @escaping (_ arrayProduct: [HomeProductList]) ->Void)
}

class CategoryVM: BaseModeling, CategoryVModeling {
    
    func getCategory(param: [String: AnyObject], completion: @escaping (_ arrayCategory: [CategoryModel]) ->Void) {
        //let param: [String: AnyObject] = ["key": 1 as AnyObject, "page": 1 as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getCategory(param: param, isShowLoader: true)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                print(result)
                let products = Mapper<CategoryModel>().mapArray(JSONArray: result)
                print(products)
                if products.count > 0 {
                    completion(products)
                }
            }
        })
    }
    
    func getSubCategory(param: [String: AnyObject], completion: @escaping (_ arrayProduct: [SubCategoryModel]) ->Void) {
        //let param: [String: AnyObject] = ["key": 1 as AnyObject, "page": 1 as AnyObject, "categoryId": 2 as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getSubCategory(param: param, isShowLoader: true)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                print(result)
                let products = Mapper<SubCategoryModel>().mapArray(JSONArray: result)
                print(products)
                if products.count > 0 {
                    completion(products)
                }
            }
        })
    }
}
