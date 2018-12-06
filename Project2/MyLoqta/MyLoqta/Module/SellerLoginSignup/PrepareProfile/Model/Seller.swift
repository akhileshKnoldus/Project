//
//  Seller.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/16/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//
let KTitle = "title"
let KUrl = "url"
let KAboutUser = "aboutUser"
let KApprovalStatus = "approvalStatus"
let KBankId = "bankId"
let KDocument = "document"
let KIbanNumber = "ibanNumber"
let KSellerId = "sellerId"
let KSellerType = "sellerType"
let KStoreDesc = "storeDescription"
let KStoreName = "storeName"
let KSellerDetail = "sellerDetail"

import UIKit
import ObjectMapper

class Seller: Mappable {
    
    var aboutUser : String?
    var approvalStatus : Int?
    var bankId : Int?
    var coverPic : String?
    var document : [Documents]?
    var ibanNumber : String?
    var profilePic : String?
    var sellerId : Int?
    var sellerType: Int?
    var storeDescription : String?
    var storeName: String?
    var bankName: String?
    
    //SignupKeys
    var followersCount: Int?
    var name: String?
    var productCount: Int?
    var ratingCount: Int?
    var reviewCount: Int?
    var soldItems: Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        aboutUser <- map[KAboutUser]
        approvalStatus <- map[KApprovalStatus]
        bankId <- map[KBankId]
        coverPic <- map[KCoverPic]
        document <- map[KDocument]
        ibanNumber <- map[KIbanNumber]
        profilePic <- map[KProfilePic]
        sellerId <- map[KSellerId]
        sellerType <- map[KSellerType]
        storeDescription <- map[KStoreDesc]
        storeName <- map[KStoreName]
        followersCount <- map["followersCount"]
        name <- map["name"]
        productCount <- map["productCount"]
        ratingCount <- map["ratingCount"]
        reviewCount <- map["reviewCount"]
        soldItems <- map["soldItems"]
        bankName <- map["bankName"]
    }
}

// MARK: - Formatted data
extension Seller {
    class func formattedData(data: [String: AnyObject]) -> Seller? {
        return Mapper<Seller>().map(JSON:data)
    }
}



class Documents: Mappable {
    
    var title : Int?
    var url : String?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        title <- map[KTitle]
        url <- map[KUrl]
    }
}
