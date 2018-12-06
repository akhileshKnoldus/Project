//
//  SettingsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol SettingsVModeling: class {
    func getDataSource() -> [[SettingData]]
    func requestToLogout(completion: @escaping (_ success: Bool)-> Void)
}

typealias SettingData = (image: UIImage, title: String)

class SettingsVM: BaseModeling, SettingsVModeling {
    
    func getDataSource() -> [[SettingData]] {
        
        //First Section
        let editProfile = SettingData(#imageLiteral(resourceName: "edit"), "Edit profile".localize())
        let myReviews = SettingData(#imageLiteral(resourceName: "check_darkgray"), "My reviews".localize())
        let shipAddress = SettingData(#imageLiteral(resourceName: "home_gray"), "Shipping address".localize())
        let notifications = SettingData(#imageLiteral(resourceName: "box_circle"), "Notifications".localize())
        let language = SettingData(#imageLiteral(resourceName: "box_a"), "Language".localize())
        
        //Second Section
        let help = SettingData(#imageLiteral(resourceName: "question"), "Help".localize())
        let faq = SettingData(#imageLiteral(resourceName: "chat"), "FAQ".localize())
        let aboutUs = SettingData(#imageLiteral(resourceName: "circle_c"), "About us".localize())
        let privacy = SettingData(#imageLiteral(resourceName: "circle_c"), "Privacy policy".localize())
        let logout = SettingData(#imageLiteral(resourceName: "login"), "Log out".localize())
        
        return [[editProfile, myReviews, shipAddress, notifications, language], [help, faq, aboutUs, privacy, logout]]
    }
    
    func requestToLogout(completion: @escaping (_ success: Bool)-> Void)  {
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .userLogout()), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                completion(success)
            }
        })
    }
}
