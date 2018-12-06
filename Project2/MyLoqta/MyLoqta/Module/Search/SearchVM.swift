//
//  SearchVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

protocol SearchVModeling {
    
    func viewRecentItems(completion: @escaping (_ arrayKeyword: [SearchResult], _ arrayProduct: [Product])->Void)
    func searchProduct(param: [String: AnyObject], completion: @escaping (_ array: [SearchResult]) ->Void)
    func requestToSearchDetail(param: [String: AnyObject], completions: @escaping(_ array: [Product], _ itemCount: Int) -> Void)
    func requestLikeProduct(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ isDelete: Bool, _ message: String) ->Void)
}

class SearchVM: BaseModeling, SearchVModeling {
 
    
    func viewRecentItems(completion: @escaping (_ arrayKeyword: [SearchResult], _ arrayProduct: [Product])->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .viewRecentItems()), completionHandler: { (response, success) in
            
            if success, let data = response as? [String: AnyObject] {
                var arrayRecentSearch = [SearchResult]()
                var arrayProduct = [Product]()
                
                if let arrayData = data["viewItems"] as? [[String: Any]] {
                    let array = Mapper<Product>().mapArray(JSONArray: arrayData)
                    if array.count > 0 {
                        arrayProduct.append(contentsOf: array)
                    }
                }
                
                if let arrayData = data["keywordItems"] as? [[String: AnyObject]] {
                    let array = Mapper<SearchResult>().mapArray(JSONArray: arrayData)
                    if array.count > 0 {
                        arrayRecentSearch.append(contentsOf: array)
                    }
                }
                completion(arrayRecentSearch, arrayProduct)
            }
        })
    }
    
    
    func searchProduct(param: [String: AnyObject], completion: @escaping (_ array: [SearchResult]) ->Void) {
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .search(param: param)), completionHandler: { (response, success) in
            if success, let data = response as? [String: AnyObject],  let result = data["searchedData"] as? [[String: AnyObject]] {
                let array = Mapper<SearchResult>().mapArray(JSONArray: result)
                completion(array)
//                if array.count > 0 {
//                    completion(array)
//                }
            }
        })
    }
    
    //productTabDetail
    func requestToSearchDetail(param: [String: AnyObject], completions: @escaping(_ array: [Product], _ itemCount: Int) -> Void) {
        
        if param.isEmpty {
            return
        }
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .productTabDetail(param: param)), completionHandler: { (response, success) in
            //print(response)
            if success {
               if let data = response as? [String: AnyObject], let result = data["ProductsList"] as? [[String: AnyObject]], let count = data["totalItemsFound"] as? Int {
                    let array = Mapper<Product>().mapArray(JSONArray: result)
                    completions(array, count)
                } else {
                    completions([], 0)
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
