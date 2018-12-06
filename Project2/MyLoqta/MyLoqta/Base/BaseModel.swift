//
//  BaseModel.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/05/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
//import ObjectMapper
//import ObjectMapper

protocol BaseModeling {
    func apiManagerInstance() -> APIManager?
}

extension BaseModeling {
    func apiManagerInstance() -> APIManager? {
        return APIManager.shared
    }
}

class CommanApi: BaseModeling {
    
    // Write here for common api
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
