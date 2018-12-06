//
//  EmptyProfileVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import GoogleSignIn
import SwiftyUserDefaults

protocol SocialSignupDelegate: class {
    func socialSignupCompeted()
}

protocol EmptyProfileVModeling {
    
    var socialDelegate: SocialSignupDelegate? { get set }
    func facebookLogin(fromVC: UIViewController)
    func processGoogleLogingResponse(user: GIDGoogleUser)
    
}

class EmptyProfileVM: BaseModeling, EmptyProfileVModeling {
    
    var socialDelegate: SocialSignupDelegate?
    
    func facebookLogin(fromVC: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: fromVC) { loginResult in
            switch loginResult {
            case LoginResult.failed(let error):
                print(error)
            case LoginResult.cancelled:
                print("User cancelled login.")
            case LoginResult.success( _, _, _):
                print("Logged in!")
                self.getFBUserInfo()
            }
        }
    }
    
    func getFBUserInfo() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,id, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { (response, result) in
            switch result {
            case .success(let value):
                print(value.dictionaryValue)
                if let user = value.dictionaryValue {
                    self.processFBResponse(user: user)
                }
            case .failed(let error):
                print(error)
            }
        }
    }
    
    func processFBResponse(user: [String: Any]) {
        print(user)
        
        var socialId = ""
        var fName = ""
        var lName = ""
        var emailStr = ""
        var image = ""
        //let socialType = 0
        if let idStr = user["id"] as? String {
            socialId = idStr
            image = "http://graph.facebook.com/\(socialId)/picture?type=large"
        }
        if let email = user["email"] as? String {
            emailStr = email
        }
        if let fullName = user["name"] as? String, !fullName.isEmpty {
            let array = fullName.components(separatedBy: " ")
            if array.count > 0 {
                fName = array[0]
            }
            if array.count > 1 {
                lName = array[1]
            }
        }
        print(fName,socialId,lName,emailStr,image)
        self.requestToSignup(fName, lName, emailStr, image, Constant.socialTypeFacebook, socialId)
    }
    
    func processGoogleLogingResponse(user: GIDGoogleUser) {
        var socialId = ""
        var fName = ""
        var lName = ""
        var emailStr = ""
        var image = ""
        //let socialType = 1
        if let userId = user.userID {
            socialId = userId
        }
        if let email = user.profile.email {
            emailStr = email
        }
        if let f_name = user.profile.givenName {
            fName = f_name
        }
        if let l_name = user.profile.familyName {
            lName = l_name
        }
        if fName.isEmpty, let full_name = user.profile.name {
            fName = full_name
        }
        if let profile_image = user.profile.imageURL(withDimension: 300) {
            image = profile_image.absoluteString
        }
        print(socialId, fName, lName, emailStr, image)
        self.requestToSignup(fName, lName, emailStr, image, Constant.socialTypeGoogle, socialId)
    }
    
    func requestToSignup(_ fName: String,_ lName: String,_ email: String,_ image: String,_ socialMeilaType: String,_ socialId: String) {
        let role = userRole.buyer.rawValue
        let deviceToken = Defaults[.deviceToken] ?? "1234"
        let params = ["firstName": fName as AnyObject, "lastName": lName as AnyObject, "userName": "" as AnyObject, "email": email as AnyObject, "password": "" as AnyObject, "socialMedium": socialMeilaType as AnyObject, "socialId": socialId as AnyObject, "deviceToken": deviceToken as AnyObject, "deviceType": Constant.deviceType as AnyObject, "role": role as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .signup(param: params)), completionHandler: { [weak self] (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let user = User.formattedData(data: newResponse) {
                    Defaults[.userId] = user.userId
                    Defaults[.user] = user
                    guard let strongSelf = self, let delegate = strongSelf.socialDelegate else { return }
                    delegate.socialSignupCompeted()
                }
            }
        })
    }
}
