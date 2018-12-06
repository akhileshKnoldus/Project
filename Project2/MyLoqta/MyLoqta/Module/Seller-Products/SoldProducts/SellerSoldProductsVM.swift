//
//  SellerSoldProductsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol SellerSoldProductsVModeling: class {
    func requestGetSellerSoldOrdersList(page: Int, isShowLoader: Bool, completion: @escaping (_ productList: [Product], _ count: Int) ->Void)
}

class SellerSoldProductsVM: BaseModeling, SellerSoldProductsVModeling {
    
    //MARK: - API Methods
    func requestGetSellerSoldOrdersList(page: Int, isShowLoader: Bool, completion: @escaping (_ productList: [Product], _ count: Int) ->Void) {
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject, "page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .SellerSoldOrders(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let data = response as? [String: AnyObject], let newResponse = data["orders"] as? [[String: AnyObject]], let orderCount = data["orderCount"] as? Int {
                if let productList = Product.formattedArray(data: newResponse) {
                    completion(productList, orderCount)
                }
            }
        })
    }
}
