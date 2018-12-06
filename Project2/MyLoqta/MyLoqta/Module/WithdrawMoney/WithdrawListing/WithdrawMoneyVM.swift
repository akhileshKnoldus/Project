//
//  WithdrawMoneyVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

protocol WithdrawMoneyVModeling: class {
     func requestGetWithdrawRequestList(page: Int, isShowLoader: Bool, completion: @escaping (_ withdrawList: [Withdraw], _ currentBalance: Double, _ reuqestAmount: Double) ->Void)
}

class WithdrawMoneyVM: BaseModeling, WithdrawMoneyVModeling {
    
    func requestGetWithdrawRequestList(page: Int, isShowLoader: Bool, completion: @escaping (_ withdrawList: [Withdraw], _ currentBalance: Double, _ reuqestAmount: Double) ->Void) {
        let params = ["page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .withdrawlRequestList(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject], let withdrawList = newResponse["withdrawlList"] as? [[String: AnyObject]], let currentBalance =  newResponse["walletCurrentBalance"] as? Double, let requestAmount = newResponse["requestedAmount"] as? Double {
                if let arrWithdraw = Withdraw.formattedArray(data: withdrawList) {
                    completion(arrWithdraw, currentBalance, requestAmount)
                }
            }
        })
    }
}
