//
//  UserDefaults+Key.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 15/11/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import SwiftyUserDefaults
import UIKit

extension UserDefaults {
    
    subscript(key: DefaultsKey<User?>) -> User? {
        get { return unarchive(key)  }
        set { archive(key, newValue) }
    }
}

extension DefaultsKeys {
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let authToken = DefaultsKey<String?>("authToken")
    static let jwtToken = DefaultsKey<String?>("jwtToken")
    static let token = DefaultsKey<String?>("token")
    static let expiresIn = DefaultsKey<Int?>("expiresIn")
    static let userId = DefaultsKey<Int?>("userId")
    static let userType = DefaultsKey<Int?>("userType")
    static let user = DefaultsKey<User?>("user")
    static let defaultLangId = DefaultsKey<Int?>("defaultLangId")
    static let defaultLangCode = DefaultsKey<String?>("defaultLangCode")
    static let appLanguage = DefaultsKey<String?>("appLanguage")
    static let selectedTheme = DefaultsKey<Int?>("SelectedTheme")
    static let isExpired = DefaultsKey<Int?>("isExpired")
    static let sellerId = DefaultsKey<Int?>("sellerId")
}
