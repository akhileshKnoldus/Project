//
//  EditProfileVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol EditProfileVModeling: class {
    func getDataSource() -> [[String: Any]]
    func validateData(_ arrData: [[String: Any]]) -> Bool
    func updateProfile(arrayData: [[String: Any]], completion: @escaping (_ success: Bool) ->Void )
}

class EditProfileVM: BaseModeling, EditProfileVModeling {

    func getDataSource() -> [[String: Any]] {
        
        var firstN = ""
        var lastN = ""
        var userEmail = ""
        var pass = ""
        var userN = ""
        var userPhone = ""
        var coverPicUrl = ""
        var profilePicUrl = ""
        
        if let user = Defaults[.user] {
            
            if let fName = user.firstName {
                firstN = fName
            }
            if let lName = user.lastName {
                lastN = lName
            }
            
            if let email_user = user.email {
                userEmail = email_user
            }
            
            if let socialMedium = user.socialMedium, socialMedium == 0 {
                pass = "12345678"
            } else {
                pass = ""
            }
            
            if let user_name = user.userName {
                userN = user_name
            }
            
            if let user_phone = user.mobileNumber {
                userPhone = user_phone
            }
            
            if let cover_pic = user.coverPic {
                coverPicUrl = cover_pic
            }
            
            if let profile_pic = user.profilePic {
                profilePicUrl = profile_pic
            }
        }
        
        let profilePic = [Constant.keys.kProfileImage: nil, Constant.keys.kProfileImageUrl: profilePicUrl, Constant.keys.kCoverImage: nil, Constant.keys.kCoverImageUrl: coverPicUrl] as [String : Any?]
        let name = [Constant.keys.kFirstNameP: "First name".localize(), Constant.keys.kFirstNameV: firstN, Constant.keys.kLastNameP: "Last name".localize(), Constant.keys.kLastNameV: lastN] as [String : Any]
        let userName = [Constant.keys.kTitle: "Username".localize(), Constant.keys.kValue: userN] as [String : Any]
        let email = [Constant.keys.kTitle: "Email".localize(), Constant.keys.kValue: userEmail] as [String : Any]
        let password = [Constant.keys.kTitle: "Password".localize(), Constant.keys.kValue: pass] as [String : Any]
        let phone = [Constant.keys.kTitle: "Phone".localize(), Constant.keys.kValue: userPhone] as [String : Any]
        return [profilePic, name, userName, email, password, phone]
    }
    
    func validateData(_ arrData: [[String: Any]]) -> Bool {
        var isValid = true
        if let firstName = arrData[1][Constant.keys.kFirstNameV] as? String, firstName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter first name".localize())
            isValid = false
        } else if let firstName = arrData[1][Constant.keys.kFirstNameV] as? String, firstName.count < Constant.validation.kFirstNameMin {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The first name should contain atleast \(Constant.validation.kFirstNameMin) characters.".localize())
            isValid = false
        } else if let firstName = arrData[1][Constant.keys.kFirstNameV] as? String, firstName.count > Constant.validation.kFirstNameMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The first name cannot contain more than \(Constant.validation.kFirstNameMax) characters.".localize())
            isValid = false
        } else if let lastName = arrData[1][Constant.keys.kLastNameV] as? String, lastName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter last name".localize())
            isValid = false
        } else if let lastName = arrData[1][Constant.keys.kLastNameV] as? String, lastName.count < Constant.validation.kLastNameMin {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The last name should contain atleast \(Constant.validation.kLastNameMin) characters.".localize())
            isValid = false
        } else if let lastName = arrData[1][Constant.keys.kLastNameV] as? String, lastName.count > Constant.validation.kLastNameMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The last name cannot contain more than \(Constant.validation.kLastNameMax) characters.".localize())
            isValid = false
        } else if let userName = arrData[2][Constant.keys.kValue] as? String, userName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter username".localize())
            isValid = false
        } else if let userName = arrData[2][Constant.keys.kValue] as? String, userName.count < Constant.validation.kUserNameMin {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The username should contain atleast \(Constant.validation.kUserNameMin) characters.".localize())
            isValid = false
        } else if let userName = arrData[2][Constant.keys.kValue] as? String, userName.count > Constant.validation.kUserNameMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The username cannot contain more than \(Constant.validation.kUserNameMax) characters.".localize())
            isValid = false
        } else if let email = arrData[3][Constant.keys.kValue] as? String, email.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter email".localize())
            isValid = false
        } else if let email = arrData[3][Constant.keys.kValue] as? String, !email.isValidEmail() {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter a valid email".localize())
            isValid = false
        } else if let email = arrData[3][Constant.keys.kValue] as? String, email.count > Constant.validation.kEmailMax {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The email cannot contain more than \(Constant.validation.kEmailMax) characters.".localize())
            isValid = false
        }
        return isValid
    }

    func updateProfile(arrayData: [[String: Any]], completion: @escaping (_ success: Bool) ->Void ) {
        /*
 "userId": "2",
 "email": "nisha@gmail.com",
 "password": "1234",
 "mobileNumber" : "+919810794843",
 "firstName":"nisha",
 "lastName": "madhulika",
 "userName" :"nisha009",
 "coverPic" : "nisha.png",
 "profilePic": "nisha123.png"*/
        var userId = ""
        
        if let user = Defaults[.user], let user_id = user.userId{
            userId = "\(user_id)"
        }
        
        if let email = arrayData[3][Constant.keys.kValue] as? String, let mobileNumber = arrayData[5][Constant.keys.kValue] as? String, let firstName = arrayData[1][Constant.keys.kFirstNameV], let lastName = arrayData[1][Constant.keys.kLastNameV], let coverPic = arrayData[0][Constant.keys.kCoverImageUrl], let profilePic = arrayData[0][Constant.keys.kProfileImageUrl], let userName = arrayData[2][Constant.keys.kValue] as? String {
            let param = ["userId": userId as AnyObject,
                         "email": email as AnyObject,
                         "mobileNumber": mobileNumber as AnyObject,
                         "firstName": firstName as AnyObject,
                         "lastName": lastName as AnyObject,
                         "userName": userName as AnyObject,
                         "coverPic": coverPic as AnyObject,
                         "profilePic": profilePic as AnyObject]
            self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .updateProfile(param: param)), completionHandler: { (response, success) in
                print("response: \(response)")
                
                if success, let newResponse = response as? [String: AnyObject] {
                    if let updatedUser = User.formattedData(data: newResponse), let user = Defaults[.user] {
                        user.firstName = updatedUser.firstName
                        user.lastName = updatedUser.lastName
                        user.email = updatedUser.email
                        user.userName = updatedUser.userName
                        user.coverPic = updatedUser.coverPic
                        user.profilePic = updatedUser.profilePic
                        Defaults[.user] = user
                        completion(success)
                    }
                }
            })
        }
        //let param = ["userId": ]
        
    }
}
