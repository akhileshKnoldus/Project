//
//  Activity.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class Activity: Mappable {
    
    var notificationId : Int?
    var pushType : String?
    var userId : Int?
    var sellerId : Int?
    var buyerId: Int?
    var orderId : Int?
    var orderDetailId : Int?
    var msgEn : String?
    var itemId : Int?
    var createdAt: String?
    var actionType : Int?
    var isRead : Int?
    var itemName : String?
    var itemImage : String?
    var sellerName: String?
    var buyerName : String?
    var driverName : String?
    var question : String?
    var reply : String?
    var orderStatus: Int?
    var driverImage: String?
    var buyerImage: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        notificationId <- map["notificationId"]
        pushType <- map["pushType"]
        userId <- map["userId"]
        sellerId <- map["sellerId"]
        buyerId <- map["buyerId"]
        orderId <- map["orderId"]
        orderDetailId <- map["orderDetailId"]
        msgEn <- map["msgEn"]
        itemId <- map["itemId"]
        createdAt <- map["createdAt"]
        actionType <- map["actionType"]
        isRead <- map["isRead"]
        itemName <- map["itemName"]
        itemImage <- map["itemImage"]
        sellerName <- map["sellerName"]
        buyerName <- map["buyerName"]
        driverName <- map["driverName"]
        question <- map["question"]
        reply <- map["reply"]
        orderStatus <- map["orderStatus"]
        driverImage <- map["driverImage"]
        buyerImage <- map["buyerImage"]
    }
}

// MARK: - InsightSelling Formatted Data
extension Activity {
    
    class func formattedArray(data: [[String: Any]]) -> [Activity]? {
        return Mapper<Activity>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> Activity? {
        return Mapper<Activity>().map(JSON:data)
    }
}
