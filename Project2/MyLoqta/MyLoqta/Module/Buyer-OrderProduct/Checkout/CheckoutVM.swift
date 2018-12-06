//
//  CheckoutVM.swift
//  MyLoqta
//
//  Created by Kirti on 8/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

typealias CheckoutType = (cellType: Int , height: CGFloat)

protocol CheckoutVModeling {
    func getCheckoutDetails(_ param: [String: AnyObject], completion: @escaping (_ addressInfo:AddressInfo, _ arrayCartItems: [CartInfo], _ walletBalance: Double) ->Void)
    func getDatasourceForCheckout(_ arrayCartItems: [CartInfo]) -> [CheckoutType]
    func requestIncreaseItemQuantity(itemId: Int, quantity: Int, completion: @escaping (Int) ->Void)
    func requestToPlaceOrder(_ param: [String: AnyObject], completion: @escaping (Bool) ->Void)
}

class CheckoutVM: BaseModeling, CheckoutVModeling {
    func getDatasourceForCheckout(_ arrayCartItems: [CartInfo]) -> [CheckoutType] {
        var arrayDataSource = [CheckoutType]()
        let cartItemCell = CheckoutType(0, 225.0)
        let locationCell = CheckoutType(1, 75.0)
        let paymentCell = CheckoutType(2, 297.0)
        let amountCell = CheckoutType(3, 102.0)
        for _ in 0..<arrayCartItems.count {
            arrayDataSource.append(contentsOf: [cartItemCell])
        }
        arrayDataSource.append(contentsOf: [locationCell, paymentCell, amountCell])
        return arrayDataSource
    }
    
    func getCheckoutDetails(_ param: [String : AnyObject], completion: @escaping (AddressInfo, [CartInfo], Double) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .checkout(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any], let cartItems = result["cartInfo"] as? [[String:Any]], let addressInfo = result["address"] as? [String:Any], let walletBal = result["walletBalance"] as? Double {
                print(result)
                if let address = CheckoutDetail.formattedData(data: addressInfo), let cartInfo = CheckoutDetail.formattedArray(data: cartItems) {
                    completion(address, cartInfo, walletBal)
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
    
    func requestToPlaceOrder(_ param: [String : AnyObject], completion: @escaping (Bool) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .placeOrder(param: param)), completionHandler: { (response, success) in
            if success, let result = response as? [String: Any] {
                completion(success)
            }
        })
    }
}

