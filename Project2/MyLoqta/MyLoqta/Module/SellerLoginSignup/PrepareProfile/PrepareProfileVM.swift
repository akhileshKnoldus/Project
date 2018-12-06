//
//  PrepareBusinessProfileVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol PrepareProfileVModeling {
    func validateData(strName: String, strDesc: String, coverImageUrl: String, profileImageUrl: String, sellerType: sellerType) -> Bool
    func requestToBecomeSeller(_ arrDocuments: [[String: Any]], sellerType: sellerType, bankId: Int, ibanNumber: String, profileImage: String, coverImage: String, storeName: String, storeDesc: String, completion: @escaping (_ success: Bool) ->Void)
}

class PrepareProfileVM: BaseModeling, PrepareProfileVModeling {
    
    func validateData(strName: String, strDesc: String, coverImageUrl: String, profileImageUrl: String, sellerType: sellerType) -> Bool {
        var isValid = true
        if sellerType == .business, strName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter store name".localize())
            isValid = false
        } /*else if sellerType == .business, strDesc.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter description".localize())
            isValid = false
        }*/
        return isValid
    }
    
    
    func requestToBecomeSeller(_ arrDocuments: [[String: Any]], sellerType: sellerType, bankId: Int, ibanNumber: String, profileImage: String, coverImage: String, storeName: String, storeDesc: String, completion: @escaping (_ success: Bool) ->Void) {
        
        let userId = Defaults[.userId]
        let aboutUser = sellerType == .individual ? storeDesc : ""
        let storeDescription = sellerType == .business ? storeDesc : ""
        let params = ["sellerType": sellerType.rawValue as AnyObject, "userId": userId as AnyObject, "bankId": bankId as AnyObject, "ibanNumber": ibanNumber as AnyObject, "profilePic": profileImage as AnyObject, "coverPic": coverImage as AnyObject, "aboutUser": aboutUser as AnyObject, "storeName": storeName as AnyObject, "storeDescription": storeDescription as AnyObject, "document": arrDocuments as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .becomeSeller(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let seller = Seller.formattedData(data: newResponse) {
                    if let sellerId = seller.sellerId {
                        Defaults[.sellerId] = sellerId
                        if let user = Defaults[.user] {
                            user.role = 2
                            user.seller = UserSeller(JSON: [:])
                            user.seller?.profilePic = seller.profilePic
                            user.seller?.name = seller.storeName
                            user.seller?.sellerType = seller.sellerType
                            user.seller?.bankName = seller.bankName
                            user.seller?.ibanNumber = seller.ibanNumber
                            Defaults[.user] = user
                        }
                        completion(true)
                    }
                    print(seller)
                }
            }
        })
    }
}
