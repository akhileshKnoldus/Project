//
//  RejectReason.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/21/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

class RejectReason: Mappable {
    
    var reasonId : Int?
    var rejectReason : String?
    
    func mapping(map: Map) {
        
        reasonId <- map["id"]
        rejectReason <- map["rejectReason"]
    }
    
    required init?(map: Map) {
        
    }
    
}
