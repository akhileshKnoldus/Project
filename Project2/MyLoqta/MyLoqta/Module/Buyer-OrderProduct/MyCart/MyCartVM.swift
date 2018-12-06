//
//  MyCartVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol MyCartVModeling: class {
    func getCartItems(cartType: Int, completion: @escaping (Int, [Product]) ->Void)
    func requestRemoveCartItem(cartId: Int, itemId: Int, completion: @escaping (Bool) ->Void)
    func requestIncreaseItemQuantity(itemId: Int, quantity: Int, completion: @escaping (Int) ->Void)
    func getMoreFromSeller(itemId: Int, isShowLoader: Bool, completion: @escaping (_ array: [Product]) ->Void)
}

class MyCartVM: BaseModeling, MyCartVModeling {
    
    func getCartItems(cartType: Int, completion: @escaping (Int, [Product]) ->Void)  {
        let param: [String: AnyObject] = ["cartType": cartType as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .viewCart(param: param)), completionHandler: { (response, success) in
            if success, let result = response as? [String: Any], let cartId = result["cartId"] as? Int, let cartItems = result["cartItems"] as? [[String: Any]]   {
                if let array = Product.formattedArray(data: cartItems) {
                    completion(cartId, array)
                }
            }
        })
    }
    
    func requestIncreaseItemQuantity(itemId: Int, quantity: Int, completion: @escaping (Int) ->Void)  {
        let param: [String: AnyObject] = ["itemId" : itemId as AnyObject,
                                          "quantity" : quantity as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .increaseItemQty(param: param)), completionHandler: { (response, success) in
            if success, let result = response as? [String: Any], let currentQuantity = result["currentQuantity"] as? Int {
                completion(currentQuantity)
            }
        })
    }
    
    func requestRemoveCartItem(cartId: Int, itemId: Int, completion: @escaping (Bool) ->Void)  {
        let param: [String: AnyObject] = ["cartId" : cartId as AnyObject,
                                          "itemId" : itemId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .removeCartItem(param: param)), completionHandler: { (response, success) in
            if success, let result = response as? [String: Any] {
                completion(success)
            }
        })
    }
    
    func getMoreFromSeller(itemId: Int, isShowLoader: Bool, completion: @escaping (_ array: [Product]) ->Void)  {
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject,
                                          "type": 1 as AnyObject,
                                          "page": 0 as AnyObject,
                                          "userId": UserSession.sharedSession.getUserId() as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .suggestionItems(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
}
