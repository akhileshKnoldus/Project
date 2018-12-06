//
//  SellerFeedbackVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/5/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol SellerFeedbackVModeling: class {
    func getDataSource() -> [[String: Any]]
    func validateData(_ arrData: [[String: Any]]) -> Bool
    func requestToSendFeedback(orderDetailId: Int, arrData: [[String: Any]], completion: @escaping (_ success: Bool) ->Void)
}

class SellerFeedbackVM: BaseModeling, SellerFeedbackVModeling {
    
    func getDataSource() -> [[String: Any]] {
        
        let firstRating = [Constant.keys.kTitle: "How would you rate this customer?".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        let customerDesc = [Constant.keys.kTitle: "Few words about customer".localize(), Constant.keys.kValue: ""] as [String : Any]
        
        let secondRating = [Constant.keys.kTitle: "Delivery speed".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        let thirdRating = [Constant.keys.kTitle: "Communication with buyer".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        return [firstRating, customerDesc, secondRating, thirdRating]
    }
    
    func validateData(_ arrData: [[String: Any]]) -> Bool {
        var isValid = true
        if let firstRating = arrData[0][Constant.keys.kValue] as? Double, firstRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate the customer".localize())
            isValid = false
        } else if let customerDesc = arrData[1][Constant.keys.kValue] as? String, customerDesc.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please write few words about customer".localize())
            isValid = false
        } else if let secondRating = arrData[2][Constant.keys.kValue] as? Double, secondRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate the delivery speed".localize())
            isValid = false
        } else if let thirdRating = arrData[3][Constant.keys.kValue] as? Double, thirdRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate buyer communication".localize())
            isValid = false
        }
        return isValid
    }
    
    func requestToSendFeedback(orderDetailId: Int, arrData: [[String: Any]], completion: @escaping (_ success: Bool) ->Void) {
        
        let params = ["orderDetailId": orderDetailId as AnyObject, "customerRating": arrData[0][Constant.keys.kValue] as AnyObject, "fewWordsAbout": arrData[1][Constant.keys.kValue] as AnyObject, "deliverySpeedRating": arrData[2][Constant.keys.kValue] as AnyObject, "buyerCommunicationRating": arrData[3][Constant.keys.kValue] as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .leaveFeedbackSeller(param: params)), completionHandler: { (response, success) in
            if success {
                completion(success)
            }
        })
    }
}
