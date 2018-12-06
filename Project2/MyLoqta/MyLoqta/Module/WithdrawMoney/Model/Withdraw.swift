//
//  Withdraw.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class Withdraw: Mappable {
    
    var id : Int?
    var requestAmount : Int?
    var paymentStatus : Int?
    var requestType : Int?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        requestAmount <- map["requestAmount"]
        paymentStatus <- map["paymentStatus"]
        requestType <- map["requestType"]
        date <- map["date"]
    }
}

// MARK: - InsightSelling Formatted Data
extension Withdraw {
    
    class func formattedArray(data: [[String: Any]]) -> [Withdraw]? {
        return Mapper<Withdraw>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> Withdraw? {
        return Mapper<Withdraw>().map(JSON:data)
    }
}
