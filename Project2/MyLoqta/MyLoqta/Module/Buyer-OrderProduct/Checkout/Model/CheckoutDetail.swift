//
//  CheckoutDetail.swift
//  MyLoqta
//
//  Created by Kirti on 8/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckoutDetail: Mappable {

    var cartInfo : [CartInfo]?
    var address : AddressInfo?
    var walletBalance : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
       cartInfo <- map["cartInfo"]
       address <- map["address"]
       walletBalance <- map["walletBalance"]
    }
}

// MARK: - Formatted data
extension CheckoutDetail {
    class func formattedArray(data: [[String: Any]]) -> [CartInfo]? {
        return Mapper<CartInfo>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> AddressInfo? {
        return Mapper<AddressInfo>().map(JSON:data)
    }
}

class CartInfo: Mappable {
    
    var itemId : Int?
    var itemName : String?
    var description : String?
    var shipping : Int?
    var condition : String?
    var price : Int?
    var currentQuantity : Int?
    var cartQuantity : Int?
    var imageFirstUrl : String?
    var shippingCharge : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        itemId <- map["itemId"]
        itemName <- map["itemName"]
        description <- map["description"]
        shipping <- map["shipping"]
        condition <- map["condition"]
        price <- map["price"]
        currentQuantity <- map["currentQuantity"]
        cartQuantity <- map["cartQuantity"]
        imageFirstUrl <- map["imageFirstUrl"]
        shippingCharge <- map["shippingCharge"]
    }
}

class AddressInfo: Mappable {
    
    var title : String?
    var country : String?
    var city : String?
    var street : String?
    var blockNo : String?
    var avenueNo : String?
    var buildingNo : String?
    var paciNo : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        title <- map["title"]
        country <- map["country"]
        city <- map["city"]
        street <- map["street"]
        blockNo <- map["blockNo"]
        avenueNo <- map["avenueNo"]
        buildingNo <- map["buildingNo"]
        paciNo <- map["paciNo"]
    }
}
