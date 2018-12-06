//
//  HomeFeed.swift
//  MyLoqta
//
//  Created by Kirti on 8/17/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeFeed: Mappable {
    
    var feedFirst: [Product]?
    var forYou: [Product]?
    var category: CategoryModel?
    var feedSecond: [Product]?
    var feedLast: [Product]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        feedFirst <- map["feedFirst"]
        forYou <- map["forYou"]
        category <- map["category"]
        feedSecond <- map["feedSecond"]
        feedLast <- map["feedLast"]
    }
}

class FeedDetail: Mappable {
    
    var itemId : Int?
    var itemName : String?
    var imageFirstUrl : String?
    var isLike : Bool?
    var likeCount : Int?
    var shipping : Int?
    var condition : Int?
    var price: Double?
    var sellerId: Int?
    var sellerType: Int?
    var profilePic: String?
    var sellerName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        itemId <- map["itemId"]
        itemName <- map["itemName"]
        imageFirstUrl <- map["imageFirstUrl"]
        isLike <- map["isLike"]
        likeCount <- map["likeCount"]
        shipping <- map["shipping"]
        condition <- map["condition"]
        price <- map["price"]
        sellerId <- map["sellerId"]
        sellerType <- map["sellerType"]
        sellerName <- map["sellerName"]
        profilePic <- map["profilePic"]
    }
}

class CategoryInfo: Mappable {
    
    var name : String?
    var imageUrl : String?
    var productCount : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        productCount <- map["productCount"]
    }
}

// MARK: - Formatted data
extension HomeFeed {
    class func formattedArray(data: [[String: Any]]) -> [FeedDetail]? {
        return Mapper<FeedDetail>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> CategoryInfo? {
        return Mapper<CategoryInfo>().map(JSON:data)
    }
}



