//
//  APIDetail.swift
//  BConnected
//
//  Created by Ashish on 08/11/17.
//  Copyright © 2017 BConnected. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults
import ObjectMapper

struct APIDetail {
    
    var path: String = ""
    var parameter: APIParams = APIParams()
    var method: Alamofire.HTTPMethod = .get
    var encoding: ParameterEncoding = URLEncoding.default
    var isBaseUrlNeedToAppend: Bool = true
    var showLoader: Bool = true
    var showAlert: Bool = true
    var showMessageOnSuccess = false
    var isHeaderTokenRequired: Bool = true
    var supportOffline = false
    var isUserIdInHeaderRequired = true
    var fullResponse = false
    
    //method = .put
    //encoding = JSONEncoding.default
    
    //method = .delete
    //encoding = URLEncoding.default
    
    init(endpoint: APIEndpoint) {
        
        switch endpoint {
      
        case .signup(let param):
            path = "signup"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            isUserIdInHeaderRequired = false
            
        case .forgotPassword(let param):
            path = "forgotPassword"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            isUserIdInHeaderRequired = false
            
        case .login(let param):
            path = "login"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            isUserIdInHeaderRequired = false
            
        case .home(let userId):
            path = "home/\(userId)"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .sendOtp(let param):
            path = "sendOtp"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            
        case .verifyPhone(let param):
            path = "verifyMobile"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            
        case .becomeSeller(let param):
            path = "becomeSeller"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .getMyProfile(let param, let isShowLoader):
            path = "myProfile"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = isShowLoader
            
        case .updateProfile(let param):
            path = "profile"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
        
        case .getCategory(let param, let isShowLoader):
            path = "category"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = isShowLoader
            
        case .getSubCategory(let param, let isShowLoader):
            path = "subCategory"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = isShowLoader
            
        case .addItem(let param):
            path = "addItem"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showMessageOnSuccess = true
            
        case .viewItem(let param):
            path = "viewItem"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            fullResponse = true
            

        case .viewSellerItems(let param, let isShowLoader):
            path = "viewSellerItems"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = isShowLoader
            
        case .updateItem(let param):
            path = "updateItem"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            
        case .addAddress(let param):
            path = "addAddress"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .addressList(let userId):
            path = "addressList"
            parameter = ["userId": userId as AnyObject]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            
        case .getPopularProducts(let param, let isShowLoader):
            path = "popularProducts"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = isShowLoader
            
        case .likeProduct(let param):
            path = "likeProduct"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            fullResponse = true
            showAlert = false
            showLoader = false
            
        case .suggestionItems(let param, let isShowLoader):
            path = "suggestionItems"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = isShowLoader
            
        case .sellerProfile(let param):
            path = "sellerProfile"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
           
        case .getActiveProducts(let param):
            path = "activeProducts"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = false
            
            
        case .questionAnswers(let param):
            path = "questionAnswers"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            
        case .searchTags(let param):
            path = "searchTags"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true            
            
        case .reportProduct(let param):
            path = "reportProduct"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showMessageOnSuccess = true
            
        case .updateStatus(let param):
            path = "updateStatus"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .askQuestion(let param):
            path = "askQuestion"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .replyQuestion(let param):
            path = "replyQuestion"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showMessageOnSuccess = true
            
        case .updateStore(let param):
            path = "updateStore"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .getBankList(let param):
            path = "bankList"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            showLoader = false
         
        case .search(let param):
            path = "tabSearch"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = false
            showLoader = true
    
        case .checkout(let param):
            path = "checkout"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = true
            
        case .viewCart(let param):
            path = "viewCart"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = true
            
        case .myLikes(let param, let isShowLoader):
            path = "myLikes"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .productTabDetail(let param):
            path = "productTabDetail"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            showAlert = true
            showLoader = true
            
        case .removeCartItem(let param):
            path = "removeCartItem"
            parameter = param
            method = .delete
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = true
            
        case .increaseItemQty(let param):
            path = "increaseItemQty"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = false

            
        case .addCartItem(let param):
            path = "addCartItem"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = true
            
        case .buyerOrderDetail(let param):
            path = "BuyerOrderDetail"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            showAlert = true
            showLoader = true
            
        case .BuyerOrders(let param, let isShowLoader):
            path = "BuyerOrders"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .placeOrder(let param):
            path = "placeOrder"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = true

        case .SellerSoldOrders(let param, let isShowLoader):
            path = "SellerSoldOrders"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .SellerOrders(let param, let isShowLoader):
            path = "SellerOrders"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
                        
        case .removeAddress(let param):
            path = "removeAddress"
            parameter = param
            method = .delete
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = true
            
        case .editAddress(let param):
            path = "editAddress"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .follower(let param):
            path = "follower"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .homeFeed(let param, let isShowLoader):
            path = "homeFeed"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = false
            showLoader = isShowLoader
            
        case .followCategory(let param):
            path = "followCategory"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .viewRecentItems():
            path = "viewRecentItems"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            showAlert = true
            showLoader = true
            
        case .forYou(let param, let isShowLoader):
            path = "forYou"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .rejectReasons():
            path = "rejectReasons"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .orderStatusReject(let param):
            path = "orderStatusReject"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .orderStatusChange(let param):
            path = "orderStatusChange"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .cartSellerId():
            path = "cartSellerId"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .publishItemOrder(let param):
            path = "publishItemOrder"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .SellerOrderDetail(let param):
            path = "SellerOrderDetail"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            
        case .resetPassword(let param):
            path = "resetPassword"
            parameter = param
            method = .put
            encoding = JSONEncoding.default
            isHeaderTokenRequired = false
            showAlert = true
            
        case .ResellerProduct(let param):
            path = "ResellerProduct"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .leaveFeedbackBuyer(let param):
            path = "leaveFeedbackBuyer"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .leaveFeedbackSeller(let param):
            path = "leaveFeedbackSeller"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
        
        case .myReviews(let param, let isShowLoader):
            path = "myReviews"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .reviewsAboutMe(let param, let isShowLoader):
            path = "reviewsAboutMe"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .productReviews(let param):
            path = "productReviews"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .myStatistic(let param, let isShowLoader):
            path = "myStatistic"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .insightSelling(let param, let isShowLoader):
            path = "insightSelling"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .insightSearch(let param, let isShowLoader):
            path = "insightSearch"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .getSubjectList():
            path = "getSubjectList"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = false
            
        case .sendEmail(let param):
            path = "sendEmail"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .getHelpDeskNumber():
            path = "getHelpDeskNumber"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .getCityList(let param):
            path = "getCityList"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .viewItemStats(let param):
            path = "viewItemStats"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .sellerCommission():
            path = "sellerCommission"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .withdrawlRequestList(let param, let isShowLoader):
            path = "withdrawlRequestList"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
        case .withdrawlRequest(let param):
            path = "withdrawlRequest"
            parameter = param
            method = .post
            encoding = JSONEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .userLogout():
            path = "userLogout"
            parameter = [:]
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            
        case .notificationTab(let param, let isShowLoader):
            path = "notificationTab"
            parameter = param
            method = .get
            encoding = URLEncoding.default
            isHeaderTokenRequired = true
            showAlert = true
            showLoader = isShowLoader
            
            
        default:
            break
        }
    }
}
