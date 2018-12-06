//
//  Product.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper

class Product: Mappable {

    var itemId : Int?
    var itemName : String?
    var description : String?
    var categoryId : Int?
    var sellerId : Int?
    var condition : Int?
    var brand : String?
    var model : String?
    var color : String?
    var quantity : Int?
    var status : Int?
    var shipping : Int?
    var price: Double?
    var likeCount : Int?
    var isLike : Bool?
    var isDiscount : Bool?
    var discountPercent : Int?
    var discountedPrice : Int?
    var country : String?
    var city : String?
    var blockNo : String?
    var street : String?
    var avenueNo : String?
    var buildingNo : String?
    var paciNo : String?
    var imageUrl : [String]?
    var tags : [String]?
    var subCategory : String?
    var category : String?
    var questionsAndAnswers : [String]?
    var arrayQuestion: [Question]?
    var questionAnswersCount: Int?
    var imageFirstUrl: String?
    var sellerDetail: SellerDetail?
    var approvalDateTime: String?
    var createdDate: String?
    
    var cartQuantity: Int?
    var currentQuantity: Int?
    var shippingCharge: Double?
    var isAvailable: Bool?
    var orderStatus:Int?
    var orderId: Int?
    var orderDetailId: Int?
    var totalPrice: Double?
    var totalAmount: Double?
    var orderDate: String?
    var rejectReason: String?
    var buyerId: Int?
    var buyerName: String?
    var buyerProfileImage: String?
    var driverId: Int?
    var driverName: String?
    var driverProfileImage: String?
    var driverMobileNumber: String?
    var sellerName: String?
    var sellerProfilePic: String?
    var profilePic: String?
    
    //var sellerType: Int?
    var sellerType: Int?
    
    //OrderDetail Keys
    var createdAt: String?
    var updatedAt: String?
    
    var sellerProfileImage: String?
    var sellerRatingCount: String?
    var sellerReviewCount: String?
    var cardNumber: String?
    
    var buyerRatingCount: Int?
    var buyerReviewCount: Int?
    
    var address: ShippingAddress?
    var approvalStatus: Int?
    var cardImage: String?
    
    var isSellerGivenFeedback: Bool?
    var ratingCount: Int?
    var ratingStar: Double?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map)
    {
       // sellerType <- map["sellerType"]
        itemId <- map["itemId"]
        itemName <- map["itemName"]
        description <- map["description"]
        categoryId <- map["categoryId"]
        sellerId <- map["sellerId"]
        condition <- map["condition"]
        brand <- map["brand"]
        model <- map["model"]
        color <- map["color"]
        quantity <- map["quantity"]
        status <- map["status"]
        shipping <- map["shipping"]
        price <- map["price"]
        likeCount <- map["likeCount"]
        isLike <- map["isLike"]
        isDiscount <- map["isDiscount"]
        discountPercent <- map["discountPercent"]
        discountedPrice <- map["discountedPrice"]
        country <- map["country"]
        city <- map["city"]
        blockNo <- map["blockNo"]
        street <- map["street"]
        avenueNo <- map["avenueNo"]
        buildingNo <- map["buildingNo"]
        paciNo <- map["paciNo"]
        imageUrl <- map["imageUrl"]
        tags <- map["tags"]
        subCategory <- map["subCategory"]
        category <- map["category"]
        questionsAndAnswers <- map["questionAndAnswers"]
        arrayQuestion <- map["questionAndAnswers"]
        questionAnswersCount <- map["questionAnswersCount"]
        imageFirstUrl <- map["imageFirstUrl"]
        sellerDetail <- map["sellerDetail"]
        approvalDateTime <- map["approvalDateTime"]
        createdDate <- map["createdDate"]
        
        cartQuantity <- map["cartQuantity"]
        currentQuantity <- map["currentQuantity"]
        shippingCharge <- map["shippingCharge"]
        isAvailable <- map["isAvailable"]
        orderStatus <- map["orderStatus"]
        orderId <- map["orderId"]
        orderDetailId <- map["orderDetailId"]
        totalPrice <- map["totalPrice"]
        totalAmount <- map["totalAmount"]
        orderDate <- map["orderDate"]
        rejectReason <- map["rejectReason"]
        buyerId <- map["buyerId"]
        buyerName <- map["buyerName"]
        buyerProfileImage <- map["buyerProfileImage"]
        driverId <- map["driverId"]
        driverName <- map["driverName"]
        driverProfileImage <- map["driverProfileImage"]
        driverMobileNumber <- map["driverMobileNumber"]
        sellerName <- map["sellerName"]
        sellerProfilePic <- map["sellerProfilePic"]
        profilePic <- map["profilePic"]
        sellerType <- map["sellerType"]
        
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        sellerProfileImage <- map["sellerProfileImage"]
        sellerRatingCount <- map["sellerRatingCount"]
        sellerReviewCount <- map["sellerReviewCount"]
        cardNumber <- map["cardNumber"]
        buyerRatingCount <- map["buyerRatingCount"]
        buyerReviewCount <- map["buyerReviewCount"]
        address <- map["address"]
        approvalStatus <- map["approvalStatus"]
        cardImage <- map["cardImage"]
        isSellerGivenFeedback <- map["isSellerGivenFeedback"]
        ratingCount <- map["ratingCount"]
        ratingStar <- map["ratingStar"]
    }
}

// MARK: - Formatted data
extension Product {
    
    class func formattedArray(data: [[String: Any]]) -> [Product]? {
        return Mapper<Product>().mapArray(JSONArray: data)
    }
    
    class func formattedData(data: [String: Any]) -> Product? {
        return Mapper<Product>().map(JSON:data)
    }
}


//MARK: - QuestionsAndAnswersModel

class Question: Mappable {
    
    var questionId : Int?
    var question : String?
    var userId : Int?
    var userName : String?
    var createdAt : String?
    var profilePic : String?
    var reply : [Reply]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        questionId <- map["questionId"]
        question <- map["question"]
        userId <- map["userId"]
        userName <- map["userName"]
        createdAt <- map["createdAt"]
        profilePic <- map["profilePic"]
        reply <- map["reply"]
    }
}

//MARK: - ReplyModel

class Reply: Mappable {
    
    var replyId : Int?
    var reply : String?
    var createdAt : String?
    var sellerId : Int?
    var sellerName : String?
    var approvalStatus : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        replyId <- map["replyId"]
        reply <- map["reply"]
        createdAt <- map["createdAt"]
        sellerId <- map["sellerId"]
        sellerName <- map["sellerName"]
        approvalStatus <- map["approvalStatus"]
    }
}

/*
 ["Success": 1, "Status": 200, "Message": Products detail is fetched successfully, "Result": {
 ProductsList =     (
 {
 condition = 2;
 imageFirstUrl = "https://s3.amazonaws.com/appinventiv-development/8D22AF1B-E37A-4407-8163-8FFF7B4DC261-1168-0000017BCE41C214.png";
 isLike = 0;
 itemId = 102;
 itemName = "washing machine";
 likeCount = 0;
 price = 500;
 shipping = 3;
 }
 );
 totalItemsFound = 1;
 }] */

