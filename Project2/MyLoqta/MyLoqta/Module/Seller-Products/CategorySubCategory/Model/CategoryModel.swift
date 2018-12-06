//
//  CategoryModel.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class CategoryModel: Mappable {
    
    var id : Int?
    var imageUrl : String?
    var name : String?
    var productCount: Int?
    var startGradient: String?
    var endGradient: String?
    var isCategoryFollow: Bool?
    
    func mapping(map: Map)
    {
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        name <- map["name"]
        productCount <- map["productCount"]
        startGradient <- map["startGradient"]
        endGradient <- map["endGradient"]
        isCategoryFollow <- map["isCategoryFollow"]
    }
    
    required init?(map: Map) {
        
    }
    
    init() {
    }
    
}

class SubCategoryModel: Mappable {
    
    var id : Int?
    var imageUrl : String?
    var name : String?
    var productCount: Int?
    var startGradient: String?
    var endGradient: String?
    
    func mapping(map: Map)
    {
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        name <- map["name"]
        productCount <- map["productCount"]
        startGradient <- map["startGradient"]
        endGradient <- map["endGradient"]
    }
    
    required init?(map: Map) {
        
    }
}
