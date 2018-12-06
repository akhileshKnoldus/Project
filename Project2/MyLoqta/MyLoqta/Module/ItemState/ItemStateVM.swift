//
//  ItemStateVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyUserDefaults

protocol ItemStateVModeling {
    
    func getOrderDetail(orderId: Int, completion: @escaping (_ order: Product) ->Void)
    func requestToMarkItemDelivered(orderDetailId: Int, completion: @escaping (_ success: Bool) ->Void)
    func requestApiToPublishItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void)
    func requestApiToResellItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void)
}

class ItemStateVM: BaseModeling, ItemStateVModeling {
 
    func getOrderDetail(orderId: Int, completion: @escaping (_ order: Product) ->Void) {
        let sellerId = Defaults[.sellerId]
        let param = ["orderDetailId": orderId as AnyObject, "sellerId": sellerId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .SellerOrderDetail(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let data = response as? [String: AnyObject] {
                if let order = Mapper<Product>().map(JSON: data) {
                    completion(order)
                }
            }
        })
    }
    
    func requestToMarkItemDelivered(orderDetailId: Int, completion: @escaping (_ success: Bool) ->Void) {
        //type = 2 for accepting order
        //type = 4 for item deliverd
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject, "orderDetailId": orderDetailId as AnyObject, "type": 4 as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .orderStatusChange(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                completion(success)
            }
        })
    }
    
    func requestApiToPublishItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .publishItemOrder(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                print(result)
                completions(success)
            }
        })
    }
    
    func requestApiToResellItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .ResellerProduct(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                print(result)
                completions(success)
            }
        })
    }
}
