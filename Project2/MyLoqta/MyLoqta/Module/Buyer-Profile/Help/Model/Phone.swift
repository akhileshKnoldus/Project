//
//  Phone.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class Phone: Mappable {
    
    var id : Int?
    var countryCode : String?
    var mobileNumber : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        countryCode <- map["countryCode"]
        mobileNumber <- map["mobileNumber"]
    }
}

// MARK: - Phone Formatted Data
extension Phone {
    
    class func formattedArray(data: [[String: Any]]) -> [Phone]? {
        return Mapper<Phone>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> Phone? {
        return Mapper<Phone>().map(JSON:data)
    }
}
