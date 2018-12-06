//
//  SearchResult.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 14/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchResult: Mappable {
    
    var categoryId: Int?
    var categoryName: String?
    var itemName: String?
    var storeId: Int?
    var storeName: String?
    var tagId: Int?
    var tagName: String?
    var type: Int?
    var profilePic: String?
    var isCompanyVerified: Bool?
    var rootCategoryId: Int?
    var rootCategoryName: String?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        rootCategoryId <- map["rootCategoryId"]
        rootCategoryName <- map["rootCategoryName"]
        
        categoryId <- map["categoryId"]
        categoryName <- map["categoryName"]
        itemName <- map["itemName"]
        storeId <- map["storeId"]
        storeName <- map["storeName"]
        tagId <- map["tagId"]
        tagName <- map["tagName"]
        type <- map["type"]
        profilePic <- map["profilePic"]
        isCompanyVerified <- map["isCompanyVerified"]
    }
}
