//
//  ProductList.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/24/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductList: Mappable {
    
    var activeProducts : [Product]?
    var reviewProducts : [Product]?
    var draftedProducts : [Product]?
    var activeOrders: [Product]?
    var rejectedOrders: [Product]?
    var rejectedProducts: [Product]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        activeProducts <- map["activeProducts"]
        reviewProducts <- map["reviewProducts"]
        draftedProducts <- map["draftedProducts"]
        activeOrders <- map["orders"]
        rejectedOrders <- map["ordersRejected"]
        rejectedProducts <- map["rejectProducts"]
    }
}

// MARK: - Formatted data
extension ProductList {
    
    class func formattedArray(data: [[String: AnyObject]]) -> [ProductList]? {
        return Mapper<ProductList>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: AnyObject]) -> ProductList? {
        return Mapper<ProductList>().map(JSON:data)
    }
}

