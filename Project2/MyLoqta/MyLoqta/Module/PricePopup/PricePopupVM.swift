//
//  PricePopupVM.swift
//  MyLoqta
//
//  Created by Kirti on 8/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol PricePopupVModeling: class {
    func requestToAddCartItem(param: [String: AnyObject], completion: @escaping (_ cartId: Int) -> Void)
    func requestToCheckCartSeller(completion: @escaping (Int) -> Void)
}

class PricePopupVM: BaseModeling, PricePopupVModeling {
    func requestToAddCartItem(param: [String : AnyObject], completion: @escaping (Int) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .addCartItem(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let cartId = result["cartId"] as? Int {
                    completion(cartId)
                }
            }
        })
    }
    
    func requestToCheckCartSeller(completion: @escaping (Int) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .cartSellerId()), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let sellerId = result["sellerId"] as? Int {
                    completion(sellerId)
                }
            }
        })
    }
}
