//
//  APIEndPoint.swift
//  AV
//


import Foundation
import Alamofire

enum APIEndpoint {
    
    case none
    case signup(param: APIParams)
    case login(param: APIParams)
    case forgotPassword(param: APIParams)
    case home(userId: String)
    case sendOtp(param: APIParams)
    case verifyPhone(param: APIParams)
    case becomeSeller(param: APIParams)
    case getMyProfile(param: APIParams, isShowLoader: Bool)
    case updateProfile(param: APIParams)
    
    case getCategory(param: APIParams, isShowLoader: Bool)
    case getSubCategory(param: APIParams, isShowLoader: Bool)
    case addItem(param: APIParams)
    case viewItem(param: APIParams)
    case viewSellerItems(param: APIParams, isShowLoader: Bool)
    case updateItem(param: APIParams)
    case addAddress(param: APIParams)
    case addressList(userId: String)
    case getPopularProducts(param: APIParams, isShowLoader: Bool)
    case likeProduct(param: APIParams)
    case suggestionItems(param: APIParams, isShowLoader: Bool)
    case sellerProfile(param: APIParams)
    case getActiveProducts(param: APIParams)
    
    case questionAnswers(param: APIParams)
    case searchTags(param: APIParams)
    case askQuestion(param: APIParams)
    
    case reportProduct(param: APIParams)
    case updateStatus(param: APIParams)
    
    case replyQuestion(param: APIParams)
    case updateStore(param: APIParams)
    case getBankList(param: APIParams)
    case search(param: APIParams)
    case productTabDetail(param: APIParams)
    case viewCart(param: APIParams)
    case removeCartItem(param: APIParams)
    case increaseItemQty(param: APIParams)
    case checkout(param: APIParams)
    case addCartItem(param: APIParams)
    case SellerOrders(param: APIParams, isShowLoader: Bool)
    case buyerOrderDetail(param: APIParams)
    case BuyerOrders(param: APIParams, isShowLoader: Bool)
    case myLikes(param: APIParams, isShowLoader: Bool)
    case placeOrder(param: APIParams)
    case SellerSoldOrders(param: APIParams, isShowLoader: Bool)
    case removeAddress(param: APIParams)
    case editAddress(param: APIParams)
    case homeFeed(param: APIParams, isShowLoader: Bool)
    case follower(param: APIParams)
    case followCategory(param: APIParams)
    case viewRecentItems()
    case forYou(param: APIParams, isShowLoader: Bool)
    case rejectReasons()
    case orderStatusReject(param: APIParams)
    case orderStatusChange(param: APIParams)
    case cartSellerId()
    case publishItemOrder(param: APIParams)
    case SellerOrderDetail(param: APIParams)
    case resetPassword(param: APIParams)
    case ResellerProduct(param: APIParams)
    case leaveFeedbackBuyer(param: APIParams)
    case leaveFeedbackSeller(param: APIParams)
    case myReviews(param: APIParams, isShowLoader: Bool)
    case reviewsAboutMe(param: APIParams, isShowLoader: Bool)
    case productReviews(param: APIParams)
    case myStatistic(param: APIParams, isShowLoader: Bool)
    case insightSelling(param: APIParams, isShowLoader: Bool)
    case insightSearch(param: APIParams, isShowLoader: Bool)
    case getSubjectList()
    case sendEmail(param: APIParams)
    case getHelpDeskNumber()
    case getCityList(param: APIParams)
    case viewItemStats(param: APIParams)
    case sellerCommission()
    case withdrawlRequestList(param: APIParams, isShowLoader: Bool)
    case withdrawlRequest(param: APIParams)
    case userLogout()
    case notificationTab(param: APIParams, isShowLoader: Bool)
}

