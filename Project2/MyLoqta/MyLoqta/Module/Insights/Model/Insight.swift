//
//  Insight.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - Insight Search/Selling Model

class InsightSelling: Mappable {
    
    var itemId : Int?
    var itemName : String?
    var categoryId : Int?
    var soldPercent : CGFloat?
    var searchedPercent: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        itemId <- map["sellerId"]
        itemName <- map["itemName"]
        categoryId <- map["categoryId"]
        soldPercent <- map["soldPercent"]
        searchedPercent <- map["searchedPercent"]
    }
}

// MARK: - InsightSelling Formatted Data
extension InsightSelling {
    
    class func formattedArray(data: [[String: Any]]) -> [InsightSelling]? {
        return Mapper<InsightSelling>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> InsightSelling? {
        return Mapper<InsightSelling>().map(JSON:data)
    }
}

//MARK: - Insight Stats Model

class InsightStats: Mappable {
    
    var revenue : Double?
    var salePercentage : Double?
    var order : Int?
    var sold : Int?
    var productCount: Int?
    var graphView: [GraphView]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        revenue <- map["revenue"]
        salePercentage <- map["salePercentage"]
        order <- map["order"]
        sold <- map["sold"]
        productCount <- map["productCount"]
        graphView <- map["graphView"]
    }
}

//MARK: - GraphView Model
class GraphView: Mappable {
    
    var date : String?
    var stats: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        date <- map["date"]
        stats <- map["stats"]
    }
}
