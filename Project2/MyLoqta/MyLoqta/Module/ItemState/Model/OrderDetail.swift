//
//  OrderDetail.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 15/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderDetail: Mappable {
    
    
    //var estimate: String?
    //var firstName: String?
    //var isDeleted: Int?
    //var isLike: Int?
    //var lastName: String?
    //var likeCount:Int?
    //var nameEn: String?
    //var orderitemimage: String?
    //var isDiscount: Int?
    
    var approvalDateTime: String?
    var brand: String?
    var buyerId: Int?
    var categoryId: Int?
    var color: String?
    var condition: Int?
    var createdAt: String?
    var currentQuantity: Int?
    var description: String?
    var discountPercent: Double?
    var discountedPrice: Double?
    
    
    
    var itemId:Int?
    var itemName: String?
    
    var model: String?
    
    var orderId:Int?
    var orderStatus:Int?
    
    var imageFirstUrl: String?
    var price: Double?
    var shippingCharge: Double?
    var profilePic: String?
    var quantity: Int?
    var sellerId: Int?
    var shipping: Int?
    var status: Int?
    var totalAmount: Double?
    var updatedAt: String?
    
    var category: String?
    var subCategory: String?
    var imageUrl: [String]?
    
    var sellerName: String?
    var sellerProfileImage: String?
    var sellerRatingCount: String?
    var sellerReviewCount: String?
    
    var driverId: Int?
    var driverMobileNumber: String?
    var driverName: String?
    var driverProfileImage: String?
    var cardNumber: String?
    
    var buyerName: String?
    var buyerProfileImage: String?
    var buyerRatingCount: Int?
    var buyerReviewCount: Int?
    
    var address: ShippingAddress?
    var approvalStatus: Int?
    var cardImage: String?
    var rejectReason: String?
    var totalPrice: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        totalPrice <- map["totalPrice"]
        rejectReason <- map["rejectReason"]
        cardImage <- map["cardImage"]
        approvalStatus <- map["approvalStatus"]
        address <- map["address"]
        
        shippingCharge <- map["shippingCharge"]
        cardNumber <- map["cardNumber"]
        
        driverId <- map["driverId"]
        driverMobileNumber <- map["driverMobileNumber"]
        driverName <- map["driverName"]
        driverProfileImage <- map["driverProfileImage"]
        
        sellerReviewCount <- map["sellerReviewCount"]
        sellerProfileImage <- map["sellerProfileImage"]
        sellerRatingCount <- map["sellerRatingCount"]
        
        sellerName <- map["sellerName"]
        imageUrl <- map["imageUrl"]
        category <- map["category"]
        subCategory <- map["subCategory"]
        
        buyerName <- map["buyerName"]
        buyerProfileImage <- map["buyerProfileImage"]
        buyerRatingCount <- map["buyerRatingCount"]
        buyerReviewCount <- map["buyerReviewCount"]
        
        approvalDateTime <- map["approvalDateTime"]
        brand <- map["brand"]
        buyerId <- map["buyerId"]
        categoryId <- map["categoryId"]
        color <- map["color"]
        condition <- map["condition"]
        createdAt <- map["orderDate"]
        currentQuantity <- map["currentQuantity"]
        description <- map["description"]
        discountPercent <- map["discountPercent"]
        discountedPrice <- map["discountedPrice"]
        itemId <- map["itemId"]
        itemName <- map["itemName"]
        model <- map["model"]
        orderId <- map["orderId"]
        orderStatus <- map["orderStatus"]
        imageFirstUrl <- map["imageFirstUrl"]
        price <- map["price"]
        profilePic <- map["profilePic"]
        quantity <- map["quantity"]
        sellerId <- map["sellerId"]
        shipping <- map["shipping"]
        status <- map["status"]
        totalAmount <- map["totalAmount"]
        updatedAt <- map["updatedAt"]
        
        //estimate <- map["estimate"]
        //firstName <- map["firstName"]
        //isDeleted <- map["isDeleted"]
        //isDiscount <- map["isDiscount"]
        //isLike <- map["isLike"]
        //lastName <- map["lastName"]
        //likeCount <- map["likeCount"]
        //nameEn <- map["nameEn"]
        //orderitemimage <- map["orderitemimage"]
    }
    
    /*
    1=>New Order,
    2=>Waiting for pickup,
    3=>On the Way,
    4=>Delivered,
    5=>Completed,
    6=>Cancelled by Merchant,
    7=>Rejected by customer(Returned),
    8=>Rejected( On the way to seller),
    9=>Rejecetd(Recieved By Merchant)',
    10=>Cancelled by Admin*/
    
}


