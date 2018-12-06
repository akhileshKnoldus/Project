//
//  SignupVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// Dummy records, need to remove later

typealias ProfileData = (placeHolder: String, value: String)

protocol SignupVModeling {
    func getDataSource() -> [[String: String]]
    func validateData(_ arrData: [[String: String]]) -> Bool
    func requestToSignup(_ arrData: [[String: String]], socialMedium: Int, socialId: String, role: Int, completion: @escaping (_ response: Any) ->Void)
}

class SignupVM: BaseModeling, SignupVModeling {
    
    func getDataSource() -> [[String: String]] {
        let createProfile = [Constant.keys.kTitle: "Create your profile".localize(), Constant.keys.kValue: ""]
        let name = [Constant.keys.kFirstNameP: "First name".localize(), Constant.keys.kFirstNameV: "", Constant.keys.kLastNameP: "Last name".localize(), Constant.keys.kLastNameV: ""]
        let userName = [Constant.keys.kTitle: "Username".localize(), Constant.keys.kValue: "@"]
        let email = [Constant.keys.kTitle: "Email".localize(), Constant.keys.kValue: ""]
        let password = [Constant.keys.kTitle: "Password".localize(), Constant.keys.kValue: ""]
        return [createProfile, name, userName, email, password]
 
    }
    
    func validateData(_ arrData: [[String: String]]) -> Bool {
        var isValid = true
        if let firstName = arrData[1][Constant.keys.kFirstNameV], firstName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter first name".localize())
            isValid = false
        } else if let firstName = arrData[1][Constant.keys.kFirstNameV], firstName.count < Constant.validation.kFirstNameMin {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The first name should contain atleast \(Constant.validation.kFirstNameMin) characters.".localize())
            isValid = false
        } else if let firstName = arrData[1][Constant.keys.kFirstNameV], firstName.count > Constant.validation.kFirstNameMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The first name cannot contain more than \(Constant.validation.kFirstNameMax) characters.".localize())
            isValid = false
        } else if let lastName = arrData[1][Constant.keys.kLastNameV], lastName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter last name".localize())
            isValid = false
        } else if let lastName = arrData[1][Constant.keys.kLastNameV], lastName.count < Constant.validation.kLastNameMin {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The last name should contain atleast \(Constant.validation.kLastNameMin) characters.".localize())
            isValid = false
        } else if let lastName = arrData[1][Constant.keys.kLastNameV], lastName.count > Constant.validation.kLastNameMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The last name cannot contain more than \(Constant.validation.kLastNameMax) characters.".localize())
            isValid = false
        } else if let userName = arrData[2][Constant.keys.kValue], userName.count < 2 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter username".localize())
            isValid = false
        } else if let userName = arrData[2][Constant.keys.kValue], userName.count < Constant.validation.kUserNameMin {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The username must contain atleast \(Constant.validation.kUserNameMin) characters.".localize())
            isValid = false
        } else if let userName = arrData[2][Constant.keys.kValue], userName.count > Constant.validation.kUserNameMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The username cannot contain more than \(Constant.validation.kUserNameMax) characters.".localize())
            isValid = false
        } else if let email = arrData[3][Constant.keys.kValue], email.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter email".localize())
            isValid = false
        } else if let email = arrData[3][Constant.keys.kValue], !email.isValidEmail() {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter a valid email".localize())
            isValid = false
        } else if let email = arrData[3][Constant.keys.kValue], email.count > Constant.validation.kEmailMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The email cannot contain more than \(Constant.validation.kEmailMax) characters.".localize())
            isValid = false
        } else if let password = arrData[4][Constant.keys.kValue], password.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter password".localize())
            isValid = false
        } else if let password = arrData[4][Constant.keys.kValue], password.count < Constant.validation.kPasswordMin || password.count > Constant.validation.kPasswordMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The password should contain minimum \(Constant.validation.kPasswordMin) and maximum \(Constant.validation.kPasswordMax) characters.".localize())
            isValid = false
        }
        return isValid
    }
    
    func requestToSignup(_ arrData: [[String: String]], socialMedium: Int, socialId: String, role: Int, completion: @escaping (_ response: Any) ->Void) {

        let deviceToken = Defaults[.deviceToken] ?? "1234"
        let params = ["firstName": arrData[1][Constant.keys.kFirstNameV] as AnyObject, "lastName": arrData[1][Constant.keys.kLastNameV] as AnyObject, "userName": arrData[2][Constant.keys.kValue] as AnyObject, "email": arrData[3][Constant.keys.kValue] as AnyObject, "password": arrData[4][Constant.keys.kValue] as AnyObject, "socialMedium": socialMedium as AnyObject, "socialId": socialId as AnyObject, "deviceToken": deviceToken as AnyObject, "deviceType": 1 as AnyObject, "role": role as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .signup(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let user = User.formattedData(data: newResponse) {
                    Defaults[.userId] = user.userId
                    Defaults[.user] = user
//                    Defaults[.defaultLangCode] = "en"
                    completion(response)
                }
            }
        })
    }
}

