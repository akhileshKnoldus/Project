//
//  WithdrawPopupVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

protocol WithdrawPopupVModeling: class {
    func validateData(currentBalance: Float, withdrawAmount: Int) -> Bool
    func requestToWithdrawMoney(param: [String: AnyObject], completion: @escaping (_ success: Bool)-> Void)
}

class WithdrawPopupVM: BaseModeling, WithdrawPopupVModeling {
    
    func validateData(currentBalance: Float, withdrawAmount: Int) -> Bool {
        var isValid = true
        if withdrawAmount < 10 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Minimum amount to withdraw is 10 KD".localize())
            isValid = false
        } else if currentBalance < Float(withdrawAmount) {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Withdrawal amount can not be greater than your wallet balance.".localize())
            isValid = false
        }
        return isValid
    }
    
    func requestToWithdrawMoney(param: [String: AnyObject], completion: @escaping (_ success: Bool)-> Void)  {
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .withdrawlRequest(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                completion(success)
            }
        })
    }
}
