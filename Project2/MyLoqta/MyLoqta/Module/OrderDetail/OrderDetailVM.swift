//
//  OrderDetailVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 08/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

protocol OrderDetailVModeling {
    
    func getOrderDetail(orderId: Int, completion: @escaping (_ order: Product) ->Void)
}

class OrderDetailVM: BaseModeling, OrderDetailVModeling {
    
    func getOrderDetail(orderId: Int, completion: @escaping (_ order: Product) ->Void) {
        //let param = ["orderDetailId": orderId as AnyObject, "sellerId": sellerId as AnyObject]
        let param = ["orderDetailId": orderId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .buyerOrderDetail(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let data = response as? [String: AnyObject] {
                if let order = Mapper<Product>().map(JSON: data) {
                    completion(order)
                }
            }
        })
    }
}


