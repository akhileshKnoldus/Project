//
//  Reviews.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - ReviewModel

class Reviews: Mappable {
    
    var sellerId : Int?
    var orderDetailId : Int?
    var ratingStar : Double?
    var fewWordsAbout : String?
    var createdAt : String?
    var itemId : Int?
    var itemName: String?
    var condition: Int?
    var shipping: Int?
    var imageFirstUrl: String?
    var sellerName: String?
    var buyerName: String?
    
    var isShowMore: Bool = true
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        sellerId <- map["sellerId"]
        orderDetailId <- map["orderDetailId"]
        ratingStar <- map["ratingStar"]
        fewWordsAbout <- map["fewWordsAbout"]
        createdAt <- map["createdAt"]
        itemId <- map["itemId"]
        itemName <- map["itemName"]
        condition <- map["condition"]
        shipping <- map["shipping"]
        imageFirstUrl <- map["imageFirstUrl"]
        sellerName <- map["sellerName"]
        buyerName <- map["buyerName"]
    }
}

// MARK: - Formatted data
extension Reviews {
    
    class func formattedArray(data: [[String: Any]]) -> [Reviews]? {
        return Mapper<Reviews>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> Reviews? {
        return Mapper<Reviews>().map(JSON:data)
    }
}
