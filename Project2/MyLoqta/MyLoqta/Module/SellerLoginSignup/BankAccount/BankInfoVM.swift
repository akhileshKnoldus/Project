//
//  BankInfoVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol BankInfoVModeling {
    func getBankNameList() -> [[String: AnyObject]]
    func validateData(bankName: String, ibanNumber: String) -> Bool
    func getBankList(completion: @escaping (_ arrayAddress: [[String: Any]])-> Void)
}

class BankInfoVM: BaseModeling, BankInfoVModeling {
    
    func getBankNameList() -> [[String: AnyObject]] {
        
        let bankFirst = ["bankName": "IDBI Bank", "bankCode": 1] as [String : AnyObject]
        let bankSecond = ["bankName": "HDFC Bank", "bankCode": 2] as [String : AnyObject]
        let bankThird = ["bankName": "Oriental Bank", "bankCode": 3] as [String : AnyObject]
        let bankFourth = ["bankName": "HSBC Bank", "bankCode": 4] as [String : AnyObject]
        let bankFifth = ["bankName": "State Bank", "bankCode": 5] as [String : AnyObject]
        let bankSixth = ["bankName": "ICICI Bank", "bankCode": 6] as [String : AnyObject]
        let bankSeventh = ["bankName": "Axis Bank", "bankCode": 7] as [String : AnyObject]
        let bankEighth = ["bankName": "World Bank", "bankCode": 8] as [String : AnyObject]
        let bankNinth = ["bankName": "Swiss Bank", "bankCode": 9] as [String : AnyObject]
        let bankTenth = ["bankName": "K-Net Bank", "bankCode": 10] as [String : AnyObject]
        let dataSource = [bankFirst, bankSecond, bankThird, bankFourth, bankFifth, bankSixth, bankSeventh, bankEighth, bankNinth, bankTenth]
        return dataSource
    }

    func validateData(bankName: String, ibanNumber: String) -> Bool {
        var isValid = true
        if bankName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please select your bank".localize())
            isValid = false
        } else if ibanNumber.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter your IBAN Number".localize())
            isValid = false
        }
        return isValid
    }
    
    func getBankList(completion: @escaping (_ arrayAddress: [[String: Any]])-> Void) {
        let param : [String: Any] = [:]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getBankList(param: param as APIParams)), completionHandler: { (response, success) in
            if success, let array = response as? [[String: Any]] {
                completion(array)
            }
        })
    }
}
