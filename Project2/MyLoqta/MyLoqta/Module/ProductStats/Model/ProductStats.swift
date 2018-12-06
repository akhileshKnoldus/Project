//
//  ProductStats.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductStats: Mappable {
    
    var viewCount : Int?
    var averageView : Double?
    var likeCount : Int?
    var averageLike : Double?
    var viewPercent: Double?
    var likePercent: Double?
    var viewedProductsGraph: [GraphView]?
    var likedProductsGraph: [GraphView]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        viewCount <- map["viewCount"]
        averageView <- map["averageView"]
        likeCount <- map["likeCount"]
        averageLike <- map["averageLike"]
        viewPercent <- map["viewPercent"]
        likePercent <- map["likePercent"]
        viewedProductsGraph <- map["viewedProductsGraph"]
        likedProductsGraph <- map["likedProductsGraph"]
    }
}

