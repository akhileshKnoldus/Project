//
//  BuyerFeedbackVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol BuyerFeedbackVModeling: class {
    func getDataSource() -> [[String: Any]]
    func validateData(_ arrData: [[String: Any]]) -> Bool
    func requestToSendFeedback(orderDetailId: Int, arrData: [[String: Any]], completion: @escaping (_ success: Bool) ->Void)
}

class BuyerFeedbackVM: BaseModeling, BuyerFeedbackVModeling {
    
    func getDataSource() -> [[String: Any]] {
        
        let firstRating = [Constant.keys.kTitle: "How would you rate this item?".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        let itemDesc = [Constant.keys.kTitle: "Few words about item".localize(), Constant.keys.kValue: ""] as [String : Any]
        
        let secondRating = [Constant.keys.kTitle: "Delivery speed".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        let thirdRating = [Constant.keys.kTitle: "Communication with seller".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        let fourthRating = [Constant.keys.kTitle: "Does item match the pictures, description?".localize(), Constant.keys.kValue: 0.0] as [String : Any]
        
        return [firstRating, itemDesc, secondRating, thirdRating, fourthRating]
    }
    
    func validateData(_ arrData: [[String: Any]]) -> Bool {
        var isValid = true
        if let firstRating = arrData[0][Constant.keys.kValue] as? Double, firstRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate the item".localize())
            isValid = false
        } else if let itemDesc = arrData[1][Constant.keys.kValue] as? String, itemDesc.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please write few words about item".localize())
            isValid = false
        } else if let secondRating = arrData[2][Constant.keys.kValue] as? Double, secondRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate the delivery speed".localize())
            isValid = false
        } else if let thirdRating = arrData[3][Constant.keys.kValue] as? Double, thirdRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate seller communication".localize())
            isValid = false
        } else if let fourthRating = arrData[4][Constant.keys.kValue] as? Double, fourthRating == 0.0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please rate the item quality".localize())
            isValid = false
        }
        return isValid
    }
    
    func requestToSendFeedback(orderDetailId: Int, arrData: [[String: Any]], completion: @escaping (_ success: Bool) ->Void) {
        
        let params = ["orderDetailId": orderDetailId as AnyObject, "itemRating": arrData[0][Constant.keys.kValue] as AnyObject, "fewWordsAbout": arrData[1][Constant.keys.kValue] as AnyObject, "deliverySpeedRating": arrData[2][Constant.keys.kValue] as AnyObject, "sellerCommunicationRating": arrData[3][Constant.keys.kValue] as AnyObject, "itemMatchRating": arrData[4][Constant.keys.kValue] as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .leaveFeedbackBuyer(param: params)), completionHandler: { (response, success) in
            if success {
                completion(success)
            }
        })
    }
}
