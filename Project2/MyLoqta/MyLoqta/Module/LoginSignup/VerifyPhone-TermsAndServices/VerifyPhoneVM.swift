//
//  VerifyPhoneVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 11/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol VerifyPhoneVModeling {
    func getCountryList() -> [[String: AnyObject]]?
    func validatePhoneNumber(_ phone: String) -> Bool
    func validateOTP(firstDigit: String, secondDigit: String, thirdDigit: String, fourthDigit: String) -> Bool
    func requestToSendOtp(phone: String, countryCode: String, completion: @escaping (_ success: Bool) ->Void)
    func requestToVerifyPhone(phone: String, otp: String, completion: @escaping (_ success: Bool) ->Void)
    func requestToAddCartItem(param: [String : AnyObject], completion: @escaping (Int) -> Void)
}

class VerifyPhoneVM: BaseModeling, VerifyPhoneVModeling {
    
    
    func getCountryList() -> [[String: AnyObject]]? {
    
        if let url = Bundle.main.url(forResource: "CountryCodeList", withExtension: "plist") {
            if let arrayList = NSArray(contentsOf: url) as? [[String: AnyObject]] {
                return arrayList
            }
        }
        return nil
    
    }
    
    func validatePhoneNumber(_ phone: String) -> Bool {
        var isValid = true
        if phone.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter phone number".localize())
            isValid = false
        } else if phone.count != Constant.validation.kPhoneLength {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter valid phone number".localize())
            isValid = false
        }
        return isValid
    }
    
    func validateOTP(firstDigit: String, secondDigit: String, thirdDigit: String, fourthDigit: String) -> Bool {
        var isValid = true
        if firstDigit.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "This OTP is not valid.".localize())
            isValid = false
        } else if secondDigit.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "This OTP is not valid.".localize())
            isValid = false
        } else if thirdDigit.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "This OTP is not valid.".localize())
            isValid = false
        } else if fourthDigit.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "This OTP is not valid.".localize())
            isValid = false
        }
        return isValid
    }
    
    func requestToSendOtp(phone: String, countryCode: String, completion: @escaping (_ success: Bool) ->Void) {
        let userId = Defaults[.userId]
        let params = ["mobileNumber": phone as AnyObject, "countryCode": countryCode as AnyObject, "userId": userId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .sendOtp(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                print(newResponse)
                completion(true)
            }
        })
    }
    
    func requestToVerifyPhone(phone: String, otp: String, completion: @escaping (_ success: Bool) ->Void) {
        let userId = Defaults[.userId]
        let params = ["mobileNumber": phone as AnyObject, "otp": otp as AnyObject, "userId": userId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .verifyPhone(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                print(newResponse)
            }            
             completion(success)
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
