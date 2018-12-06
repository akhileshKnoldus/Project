//
//  Seller.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/28/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

class SellerDetail: Mappable {
    
    var profilePic : String?
    var coverPic : String?
    var ratingCount : Int?
    var reviewCount : Int?
    var soldItems : Int?
    var approvalStatus : Int?
    var name : String?
    var sellerName: String?
    var followersCount : Int?
    var productCount : Int?
    var totalProducts: Int?
    var email : String?
    var password : String?
    var mobileNumber : String?
    var title : String?
    var country : String?
    var city : String?
    var blockNo : String?
    var street : String?
    var avenueNo : String?
    var buildingNo : String?
    var paciNo : String?
    var reviewRating: Int?
    var sellerType: Int?
    var info: SellerInfo?
    
    var isFollow: Bool?
    //EditSellerProfile
    var about: String?
    var addressId: Int?
    var userId: Int?
    
    var ratingStar: Double?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        profilePic <- map["profilePic"]
        coverPic <- map["coverPic"]
        ratingCount <- map["ratingCount"]
        reviewCount <- map["reviewCount"]
        soldItems <- map["soldItems"]
        approvalStatus <- map["approvalStatus"]
        name <- map["name"]
        sellerName <- map["sellerName"]
        followersCount <- map["followersCount"]
        productCount <- map["productCount"]
        totalProducts <- map["totalProducts"]
        email <- map["email"]
        password <- map["password"]
        mobileNumber <- map["mobileNumber"]
        title <- map["title"]
        country <- map["country"]
        city <- map["city"]
        blockNo <- map["blockNo"]
        street <- map["street"]
        avenueNo <- map["avenueNo"]
        buildingNo <- map["buildingNo"]
        paciNo <- map["paciNo"]
        info <- map["Info"]
        reviewRating <- map["reviewRating"]
        sellerType <- map["sellerType"]
        
        about <- map["about"]
        addressId <- map["addressId"]
        isFollow <- map["isFollow"]
        userId <- map["userId"]
        
        ratingStar <- map["ratingStar"]
        ratingCount <- map["ratingCount"]
    }
}

// MARK: - Formatted data
extension SellerDetail {
    class func formattedArray(data: [[String: Any]]) -> [SellerDetail]? {
        return Mapper<SellerDetail>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> SellerDetail? {
        return Mapper<SellerDetail>().map(JSON:data)
    }
}

class SellerInfo: Mappable {
    
    var isCompanyVerified : Bool?
    var isPhoneVerified : Bool?
    var isAddressVerified : Bool?
    var aboutUs : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        isCompanyVerified <- map["isCompanyVerified"]
        isPhoneVerified <- map["isPhoneVerified"]
        isAddressVerified <- map["isAddressVerified"]
        aboutUs <- map["aboutUs"]
    }
}
