//
//  BuyerOrderListVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol BuyerOrderListVModeling: class {
    func requestGetBuyerOrdersList(listType: Int, search: String, page: Int, isShowLoader: Bool, completion: @escaping (_ productList: [Product]) ->Void)
}

class BuyerOrderListVM: BaseModeling, BuyerOrderListVModeling {

    //MARK: - API Methods
    func requestGetBuyerOrdersList(listType: Int, search: String, page: Int, isShowLoader: Bool, completion: @escaping (_ productList: [Product]) ->Void) {
        let params = ["type": listType as AnyObject, "searchData":search as AnyObject,  "page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .BuyerOrders(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let data = response as? [String: AnyObject], let newResponse = data["orders"] as? [[String: AnyObject]] {
                if let productList = Product.formattedArray(data: newResponse) {
                    completion(productList)
                }
            }
        })
    }
}
