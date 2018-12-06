//
//  BankList.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/3/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

class BankList: Mappable {
    
    var bankId : Int?
    var bankName : String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        bankId <- map["bankId"]
        bankName <- map["bankName"]
    }
}

// MARK: - Formatted data
extension Seller {
    class func getArray (array: [[String: Any]]) -> [BankList] {
        return Mapper<BankList>().mapArray(JSONArray: array)
    }
}

