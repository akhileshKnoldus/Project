//
//  Constant.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 10/31/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

struct Constant {
    static let logosURLRelative = UIScreen.main.scale <= 2 ? "2x" : "3x"
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let htRation = Constant.screenHeight / 667.0
    static let wdRation = Constant.screenWidth / 375.0
    static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let deviceType = "1"  // 1-> iOS
    static let socialTypeFacebook = "1"
    static let socialTypeGoogle = "2"
    static let btnCornerRadius = CGFloat(8.0)
    static let viewCornerRadius = CGFloat(4.0)
    static let acceptableUsernameCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-."
    static let acceptableIBANCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    static let acceptableNameCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static let termsAndConditionUrl = "http://myloqta.appinventive.com/terms-condition"
    static let faqUrl = "http://myloqta.appinventive.com/faq"
    static let privacyPolicyUrl = "http://myloqta.appinventive.com/privacy-policy"
    static let aboutUsUrl = "http://myloqta.appinventive.com/about-us"
    static let IBANCount = 30
    static let itemNameCount = 80
    static let itemDescriptionCount = 1000
    static let maxPhotoCount = 10
    static let borderWidth = CGFloat(1.0)
    static let messageCount = 400
    static var isIPhone5: Bool {
        if Constant.screenHeight < 667.0 {
            return true
        }
        return false
    }
    
    struct keys {
        static let kTitle = "title"
        static let kValue = "value"
        static let kFirstNameP = "firstNameP"
        static let kFirstNameV = "firstNameV"
        static let kLastNameP = "lastNameP"
        static let kLastNameV = "lastNameV"
        static let kProfileImage = "profileImage"
        static let kProfileImageUrl = "profileImageUrl"
        static let kCoverImage = "coverImage"
        static let kCoverImageUrl = "coverImageUrl"
        static let kImage = "image"
        static let kImageStatus = "imageStatus"
        static let kImageArray = "imageArray"
        static let kTags = "tags"
        static let kCellType = "cellType"
        static let kDataSource = "dataSource"
        static let kImageUrl = "tags"
        static let kSectionIndex = "sectionIndex"
        static let kFullNameP = "fullNameP"
        static let kFullNameV = "fullNameV"
        
        static let kCategoryId = "categoryId"
        static let kSubCategoryId = "subCategoryId"
        static let kColor = "color"
        static let k10Percent = "10Percent"
    }
    
    struct validation {
        static let kFirstNameMin = 2
        static let kFirstNameMax = 30
        static let kLastNameMin = 2
        static let kLastNameMax = 40
        static let kUserNameMax = 32
        static let kUserNameMin = 5
        static let kPasswordMax = 32
        static let kPasswordMin = 6
        static let kEmailMax = 40
        static let kPhoneLength = 8
        static let kAboutYouLength = 100
    }
}




// Notification

