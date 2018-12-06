//
//  BuyerProduct.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class BuyerProduct: Mappable {
    
    var condition: Int?
    var imageFirstUrl: String?
    var isLike: Bool?
    var itemId: Int?
    var itemName: String?
    var likeCount: Int?
    var price: Double?
    var shipping: Int?
    
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        itemId <- map["itemId"]
        itemName <- map["itemName"]
        condition <- map["condition"]
        price <- map["price"]
        isLike <- map["isLike"]
        imageFirstUrl <- map["imageFirstUrl"]
        likeCount <- map["likeCount"]
        shipping <- map["shipping"]
    }
    
}
