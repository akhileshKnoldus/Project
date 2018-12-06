//
//  ShipingAddress.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class ShippingAddress: Mappable {
    
    var avenueNo: String?
    var blockNo: String?
    var buildingNo: String?
    var paciNo: String?
    var city: String?
    var country: String?
    var id: Int?
    var isAddressVerified: Int?
    var street: String?
    var title: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {        
        avenueNo <- map["avenueNo"]
        blockNo <- map["blockNo"]
        buildingNo <- map["buildingNo"]
        city <- map["city"]
        country <- map["country"]
        id <- map["id"]
        isAddressVerified <- map["isAddressVerified"]
        paciNo <- map["paciNo"]
        street <- map["street"]
        title <- map["title"]
        
    }
    
    func getDisplayAddress() -> String {
        
        var address = ""
        if let city = self.city, !city.isEmpty {
            address = "City".localize() + ":" + city
        }
        if let block = self.blockNo, !block.isEmpty {
            address = address + ", " + "Block".localize() + ":" + block
        }
        if let street = self.street, !street.isEmpty {
            address = address + ", " + "Street".localize() + ":" + street
        }
        if let avenue = self.avenueNo, !avenue.isEmpty {
            address = address + ", " + "Avenue No.".localize() + ":" + avenue
        }
        if let building = self.buildingNo, !building.isEmpty {
            address = address + ", " + "Building No.".localize() + ":" + building
        }
        return address
    }
    
    func getAddress() -> String {
        var address = ""
        if let city = self.city {
            address = "City".localize() + ":" + city
        }
        if let block = self.blockNo {
            address = address + ", " + "Block".localize() + ":" + block
        }
        if let street = self.street {
            address = address + ", " + "Street".localize() + ":" + street
        }
        if let avenue = self.avenueNo {
            address = address + ", " + "Avenue No.".localize() + ":" + avenue
        }
        if let building = self.buildingNo {
            address = address + ", " + "Building No.".localize() + ":" + building
        }
        return address
    }
    
    
    
    class func getArray (array: [[String: Any]]) -> [ShippingAddress] {
        return Mapper<ShippingAddress>().mapArray(JSONArray: array)
    }
    
}
