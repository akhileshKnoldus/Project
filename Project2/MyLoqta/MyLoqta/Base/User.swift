//
//  User.swift
//  TheDon
//
//  Created by Sourabh on 26/02/18.
//  Copyright © 2018 Ashish Chauhan. All rights reserved.
//

let KDeviceToken = "device_token"
let KDeviceType = "device_type"
let KExpireTime = "expire_time"
let KEmail = "email"
let KFirstName = "firstName"
let KId = "id"
let KLastName = "lastName"
let KUserId = "userId"
let KToken = "token"
let KRole = "role"
let KSocialId = "socialId"
let KSocialMedium = "socialMedium"
let KUserName = "userName"
let kIsPhoneVerified = "isPhoneVerified"

let KCoverPic = "coverPic"
let KProfilePic = "profilePic"
let kPassword   = "password"
let kMobileNumber = "mobileNumber"

let kFollowers = "followers"
let kFollowing = "following"
let kLikes = "likes"

let kRatingCount = "ratingCount"
let kRatingStar = "ratingStar"

//let kApprovalStatus = "approvalStatus"
//let kFollowersCount = "followersCount"


import ObjectMapper

class UserSeller: NSObject, NSCoding, Mappable {
    
    var approvalStatus: Int?
    var coverPic: String?
    var followersCount: Int?
    var name: String?
    var productCount: Int?
    var profilePic: String?
    var ratingCount: Int?
    var reviewCount: Int?
    var soldItems: Int?
    var sellerType: Int?
    var ibanNumber: String?
    var bankName: String?
    
    required init?(coder aDecoder: NSCoder) {
        self.approvalStatus = aDecoder.decodeObject(forKey:"approvalStatus") as? Int
        self.coverPic = aDecoder.decodeObject(forKey: "coverPic") as? String
        self.followersCount = aDecoder.decodeObject(forKey:"followersCount") as? Int
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.productCount = aDecoder.decodeObject(forKey:"productCount") as? Int
        self.profilePic = aDecoder.decodeObject(forKey: "profilePic") as? String
        self.ratingCount = aDecoder.decodeObject(forKey: "ratingCount") as? Int
        self.reviewCount = aDecoder.decodeObject(forKey:"reviewCount") as? Int
        self.soldItems = aDecoder.decodeObject(forKey:"soldItems") as? Int
        self.sellerType = aDecoder.decodeObject(forKey:"sellerType") as? Int
        self.ibanNumber = aDecoder.decodeObject(forKey:"ibanNumber") as? String
        self.bankName = aDecoder.decodeObject(forKey:"bankName") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.approvalStatus, forKey:"approvalStatus")
        aCoder.encode(self.coverPic, forKey:"coverPic")
        aCoder.encode(self.followersCount, forKey:"followersCount")
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.productCount, forKey:"productCount")
        aCoder.encode(self.profilePic, forKey:"profilePic")
        aCoder.encode(self.ratingCount, forKey:"ratingCount")
        aCoder.encode(self.reviewCount, forKey:"reviewCount")
        aCoder.encode(self.soldItems, forKey:"soldItems")
        aCoder.encode(self.sellerType, forKey:"sellerType")
        aCoder.encode(self.ibanNumber, forKey:"ibanNumber")
        aCoder.encode(self.bankName, forKey:"bankName")
    }
    
    required init?(map: Map){
        
    }
    func mapping(map: Map)
    {
        approvalStatus <- map["approvalStatus"]
        coverPic <- map["coverPic"]
        followersCount <- map["followersCount"]
        name <- map["name"]
        productCount <- map["productCount"]
        profilePic <- map["profilePic"]
        ratingCount <- map["ratingCount"]
        reviewCount <- map["reviewCount"]
        soldItems <- map["soldItems"]
        sellerType <- map["sellerType"]
        ibanNumber <- map["ibanNumber"]
        bankName <- map["bankName"]
    }
}

class User: NSObject, NSCoding, Mappable {
    
    required init?(coder aDecoder: NSCoder) {
        self.devieToken = aDecoder.decodeObject(forKey: KDeviceToken) as? String
        self.deviceType = aDecoder.decodeObject(forKey:KDeviceType) as? String
        self.email = aDecoder.decodeObject(forKey:KEmail) as? String
        self.firstName = (aDecoder.decodeObject(forKey:KFirstName) as? String)!
        self.lastName = (aDecoder.decodeObject(forKey:KLastName) as? String)!
        self.id = aDecoder.decodeObject(forKey:KId) as? Int
        self.userId = aDecoder.decodeObject(forKey:KUserId) as? Int
        self.token = aDecoder.decodeObject(forKey:KToken) as? String
        self.role = aDecoder.decodeObject(forKey:KRole) as? Int
        self.socialId = aDecoder.decodeObject(forKey:KSocialId) as? String
        self.socialMedium = aDecoder.decodeObject(forKey:KSocialMedium) as? Int
        self.userName = aDecoder.decodeObject(forKey:KUserName) as? String
        self.isPhoneVerified = aDecoder.decodeObject(forKey:kIsPhoneVerified) as? Int
        
        self.coverPic = aDecoder.decodeObject(forKey:KCoverPic) as? String
        self.profilePic = aDecoder.decodeObject(forKey:KProfilePic) as? String
        self.password = aDecoder.decodeObject(forKey:kPassword) as? String
        self.mobileNumber = aDecoder.decodeObject(forKey:kMobileNumber) as? String
        self.sellerId = aDecoder.decodeObject(forKey:KSellerId) as? Int
        self.seller = aDecoder.decodeObject(forKey:KSellerDetail) as? UserSeller
        
        self.followers = aDecoder.decodeObject(forKey:kFollowers) as? Int
        self.following = aDecoder.decodeObject(forKey:kFollowing) as? Int
        self.likes = aDecoder.decodeObject(forKey:kLikes) as? Int
        
        self.ratingCount = aDecoder.decodeObject(forKey:kRatingCount) as? Int
        self.ratingStar = aDecoder.decodeObject(forKey:kRatingStar) as? Double
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.devieToken, forKey:KDeviceToken)
        aCoder.encode(self.deviceType, forKey:KDeviceType)
        aCoder.encode(self.email, forKey:KEmail)
        aCoder.encode(self.firstName, forKey:KFirstName)
        aCoder.encode(self.id, forKey:KId)
        aCoder.encode(self.lastName, forKey:KLastName)
        aCoder.encode(self.userId, forKey:KUserId)
        aCoder.encode(self.token, forKey:KToken)
        aCoder.encode(self.role, forKey:KRole)
        aCoder.encode(self.socialId, forKey:KSocialId)
        aCoder.encode(self.socialMedium, forKey:KSocialMedium)
        aCoder.encode(self.userName, forKey:KUserName)
        aCoder.encode(self.isPhoneVerified, forKey:kIsPhoneVerified)
        
        aCoder.encode(self.coverPic, forKey:KCoverPic)
        aCoder.encode(self.profilePic, forKey:KProfilePic)
        aCoder.encode(self.password, forKey:kPassword)
        aCoder.encode(self.mobileNumber, forKey:kMobileNumber)
        aCoder.encode(self.sellerId, forKey:KSellerId)
        aCoder.encode(self.seller, forKey:KSellerDetail)
        
        aCoder.encode(self.followers, forKey:kFollowers)
        aCoder.encode(self.following, forKey:kFollowing)
        aCoder.encode(self.likes, forKey:kLikes)
        
        aCoder.encode(self.ratingCount, forKey:kRatingCount)
        aCoder.encode(self.ratingStar, forKey:kRatingStar)
    }
    
    
    //Variables
    var devieToken:String? = ""
    var deviceType:String? = ""
    var email:String? = ""
    var firstName:String? = ""
    var id:Int?
    var lastName:String? = ""
    var userId:Int?
    var token:String? = ""
    var profileImage:String? = ""
    var role:Int?
    var socialId: String? = ""
    var socialMedium: Int?
    var sellerId: Int?
    var userName: String? = ""
    var password: String? = ""
    var isPhoneVerified: Int?
    var mobileNumber: String? = ""
    var seller: UserSeller?
    
    var followers: Int?
    var following: Int?
    var likes: Int?
    
    var ratingCount: Int?
    var ratingStar: Double?
    
    var fullName: String {
        var name = ""
        if let firstName = self.firstName, !firstName.isEmpty {
            name = firstName
        }
        if let lastName = self.lastName, !lastName.isEmpty {
            name = name + " " + lastName
        }
        return name
    }
    
    var coverPic: String? = ""
    var profilePic: String? = ""

    
    
    required init?(map: Map){
        
    }
    
     func mapping(map: Map)
     {
        userId <- map[KUserId]
        firstName <- map[KFirstName]
        lastName <- map[KLastName]
        id <- map[KId]
        email <- map[KEmail]
        deviceType <- map[KDeviceType]
        devieToken <- map[KDeviceToken]
        token <- map[KToken]
        role <- map[KRole]
        socialId <- map[KSocialId]
        socialMedium <- map[KSocialMedium]
        userName <- map[KUserName]
        isPhoneVerified <- map[kIsPhoneVerified]
        profilePic <- map[KProfilePic]
        coverPic <- map[KCoverPic]
        password <- map[kPassword]
        mobileNumber <- map[kMobileNumber]
        sellerId <- map[KSellerId]
        seller <- map[KSellerDetail]
        followers <- map[kFollowers]
        following <- map[kFollowing]
        likes <- map[kLikes]
        ratingCount <- map[kRatingCount]
        ratingStar <- map[kRatingStar]
    }
    
   class func formattedArray(data: [[String: AnyObject]]) -> [User]? {
        return Mapper<User>().mapArray(JSONArray: data)
    }
    
    
}
// MARK: - Formatted data
extension User {
    class func formattedData(data: [String: AnyObject]) -> User? {
        return Mapper<User>().map(JSON:data)
    }
}





/*
 {
 countryCode = "";
 coverPic = "";
 email = "ashish1@mailinator.com";
 firstName = Ashish;
 isPhoneVerified = "";
 lastName = Chauhan;
 mobileNumber = "";
 password = 123456;
 profilePic = "";
 role = 1;
 socialId = "";
 socialMedium = 0;
 userId = 67;
 userName = ashish;
 };
*/

