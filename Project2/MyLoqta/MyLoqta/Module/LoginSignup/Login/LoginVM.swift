//
//  LoginVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

protocol LoginVModeling: class {
    func validateData(email: String, password: String) -> Bool
    func callLoginApi(email: String, password: String, completion: @escaping (_ success: Bool) ->Void)
    func requestToAddCartItem(param: [String : AnyObject], completion: @escaping (Int) -> Void)
}

class LoginVM: BaseModeling, LoginVModeling {
    
    func validateData(email: String, password: String) -> Bool {
        var isValid = true
        if email.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter email".localize())
            isValid = false
        } else if !email.isValidEmail() {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message:"Please enter valid email".localize())
            isValid = false
        } else if password.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter password".localize())
            isValid = false
        }
        return isValid
    }
    
    func callLoginApi(email: String, password: String, completion: @escaping (_ success: Bool) ->Void) {
        let deviceToken = Defaults[.deviceToken] ?? "1234"
        let params = ["email": email as AnyObject, "password": password as AnyObject, "deviceToken": deviceToken as AnyObject, "deviceType": 1 as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .login(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                //                let jwtToken = JWTToken.sharedHandler.creat createJWTToken(userId: userId)
                //                Defaults[.jwtToken] = jwtToken
                //                Defaults[.userType] = userType
                //                Defaults[.langCode] = languageCode
                if let user = User.formattedData(data: newResponse) {
                    Defaults[.userId] = user.userId
                    Defaults[.sellerId] = user.sellerId
                    Defaults[.user] = user
                    completion(true)
                }
            }
        })
    }
    
    func requestToAddCartItem(param: [String : AnyObject], completion: @escaping (Int) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .addCartItem(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let cartId = result["cartId"] as? Int {
                    completion(cartId)
                }
            } else {
                completion(0)
            }
        })
    }
}
