//
//  ResetPasswordVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/12/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ResetPasswordVModeling: class {
    func validateData(email: String) -> Bool
    func requestToForgotPassword(email: String, completion: @escaping (_ success: Bool) ->Void)
    
}

class ResetPasswordVM: BaseModeling, ResetPasswordVModeling {
    
    func validateData(email: String) -> Bool {
        var isValid = true
        if email.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter email".localize())
            isValid = false
        } else if !email.isValidEmail() {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message:"Please enter valid email".localize())
            isValid = false
        }
        return isValid
    }
    
    func requestToForgotPassword(email: String, completion: @escaping (_ success: Bool) ->Void) {
        let params = ["email": email as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .forgotPassword(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                print(newResponse)
                completion(true)
            }
        })
    }
}
