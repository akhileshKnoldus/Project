//
//  Enumerations.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/05/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

enum TutorialType: Int {
    case explore = 0
    case seller = 1
    case delivery = 2
}

enum OTPView: Int {
    case first = 0
    case second = 1
    case third = 2
    case fourth = 3
}

// Buyer profile view
enum BuyerProfileCell: Int {
    case profileDetailCell = 0
    case orderCell = 1
    case myLikeCell = 2
    case reviewAboutMe = 3
    
    var height: CGFloat {
        switch self {
        case .profileDetailCell:
            return 166
        case .orderCell:
            return 205
        default:
            return 55
        }
    }
}

// Home Feeds View
enum HomeFeedsCell: Int {
    case firstFeedCell = 0
    case forYouCell = 1
    case secondFeedCell = 2
    case categoryCell = 3
    case lastFeedCell = 4
}

// Explore Main View
enum ExploreMainCell: Int {
    case categoriesCell = 0
    case featuredShopCell = 1
    case popularCell = 2
    case onSaleCell = 3
    
    var title: String? {
        switch self {
        case .categoriesCell:
            return ""
        case .featuredShopCell:
            return "Popular Shops".localize()
        case .popularCell:
            return "Popular".localize()
        case .onSaleCell:
            return "On sale".localize()
        }
    }
}

//Explore Category View
enum ExploreCategoryCell: Int {
    case subCategoryCell = 0
    case featuredShopCell = 1
    case popularCell = 2
    case onSaleCell = 3
    
    var title: String? {
        switch self {
        case .subCategoryCell:
            return ""
        case .featuredShopCell:
            return "Popular Shops".localize()
        case .popularCell:
            return "Popular".localize()
        case .onSaleCell:
            return "On sale".localize()
        }
    }
}

//ManageProducts View
enum ManageProductsCell: Int {
    case profileCell = 0
    case headerCell = 1
    case productsCell = 2
    case reviewHeaderCell = 3
    case reviewCell = 4
}

//ManageStores View
enum ManageStoresType: Int {
    case products = 0
    case info = 1
    case reviews = 2
}

// Categories Type
enum CategoryType: Int {
    case electronics = 0, man, woman, sportOutfit
    
    var title: String? {
        switch self {
        case .electronics:
            return "Electronics".localize()
        case .man:
            return "Man".localize()
        case .woman:
            return "Woman".localize()
        case .sportOutfit:
            return "Sport & Outfit".localize()
        }
    }
    
    var icon: String? {
        switch self {
        case .electronics: return "electronics"
        case .man: return "man"
        case .woman: return "women"
        case .sportOutfit: return "sports"
        }
    }
}

//Seller Type
enum sellerType: Int {
    case individual = 1
    case business = 2
}

//User Role
enum userRole: Int {
    case buyer = 1
    case seller = 2
    case admin = 3
    case driver = 4
}

//Login Type
enum loginType: Int {
    case manual = 0
    case facebook = 1
    case google = 2
}

enum ImageStatus : String {
    case empty = "empty"
    case uploading = "uploading"
    case uploaded = "uploaded"
    case uploadFailed = "uploadFailed"
}

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

enum cellType: Int {
    case productName = 1
    case productDetail = 2
    case productQuantity = 3
    case productQuestions = 4
    case productDeactivate = 5
    case draftProductName = 6
}

enum sectionIndex: Int {
    case firstSection = 1
    case secondSection = 2
    case thirdSection = 3
}

enum productCondition: Int {
    case new = 1
    case used = 2
    
    var title: String? {
        switch self {
        case .new:
            return "New".localize()
        case .used:
            return "Used".localize()
        }
    }
}

enum productShipping: Int {
    case buyerWillPay = 1
    case iWillPay = 2
    case pickup = 3
    case iWillDeliver = 4
    case homeDelivery = 5
    
    var title: String? {
        switch self {
        case .buyerWillPay:
            return "Buyer will pay".localize()
        case .iWillPay:
            return "I will pay".localize()
        case .pickup:
            return "Self pickup".localize()
        case .iWillDeliver:
            return "I will deliver".localize()
        case .homeDelivery:
            return "Home delivery".localize()
        }
    }
}

enum ProductStatus: Int {
    case pending = 1
    case approved = 2
    case rejected = 3
    case blocked = 4
    case deactivated = 5
    case drafted = 6
}

enum productListType: Int {
    case activeProducts = 1
    case reviewProducts = 2
    case draftedProducts = 3
    case activeAndReviewProducts = 4
}

//BuyerOrderList Type
enum buyerOrderListType: Int {
    case activeProduct = 1
    case archivedProduct = 2
}

// AddItemViewC action type
enum ActionType: Int {
    case promote = 0
    case addToSale = 1
    case saveAsDraft = 2
}

//SellerStatus
enum sellerStatus: Int {
    case pending = 0
    case approved = 1
    case rejected = 2
}

//ProductsList
enum productsList: Int {
    case popular = 0
    case relatedItems = 1
    case moreFromSeller = 2
    case forYouItems = 3
}

//Checkout View
enum checkoutCellType: Int {
    case itemCell = 0
    case locationCell = 1
    case paymentCell = 2
    case amountCell = 3
    
    var title: String? {
        switch self {
        case .itemCell:
            return "CheckoutItemTableCell"
        case .locationCell:
            return "CheckoutLocationTableCell"
        case .paymentCell:
            return "CheckoutPaymentMethodTableCell"
        case .amountCell:
            return "CheckoutTotalAmountTableCell"
        }
    }
}

// Activity Cell Type
enum ActivityCellType: Int {
    case acceptRejectCell = 0
    case leaveFeedbackCell = 1
    case productListCell = 2
    case trackStatusCell = 3
    case followingUserCell = 4
    
    var title: String? {
        switch self {
        case .acceptRejectCell:
            return "AcceptRejectActivityTableCell"
        case .leaveFeedbackCell:
            return "LeaveFeedbackActivityTableCell"
        case .productListCell:
            return "ProductListingActivityTableViewCell"
        case .trackStatusCell:
            return "TrackStatusActivityTableCell"
        case .followingUserCell:
            return "FollowingActivityTableCell"
        }
    }
}

// Search type
enum SearchType: Int {
    case product = 1
    case store = 2
    case tag = 3
}


//OrderStatus
enum OrderStatus: Int {
    case newOrder = 1
    case waitingForPickup = 2
    case onTheWay = 3
    case delivered = 4
    case completed = 5
    case cancelledByMerchant = 6
    case rejected_byCustomer = 7
    case rejected_onTheWayToSeller = 8
    case rejected_recievedByMerchant = 9
    case cancelled_byAdmin = 10
}

// Seller Product List
enum SellerProductCell: Int {
    case activeProductCell = 0
    case reviewProductCell = 1
    case rejectedProductCell = 2
    case draftProductCell = 3
    case newOrderCell = 4
    case readyForPickupOrderCell = 5
    case buyerPickupOrderCell = 6
    case driverDropOrderCell = 7
    case rejectedOrderCell = 8
    
    var height: CGFloat {
        switch self {
        case .activeProductCell:
            return 110.0
        case .reviewProductCell:
            return 110.0
        case .rejectedProductCell:
            return UITableViewAutomaticDimension
        case .draftProductCell:
            return 110.0
        case .newOrderCell:
            return 255.0
        case .readyForPickupOrderCell:
            return 205.0
        case .buyerPickupOrderCell:
            return 313.0
        case .driverDropOrderCell:
            return 265.0
        case .rejectedOrderCell:
            return UITableViewAutomaticDimension
        }
    }
}

enum FilterDuration: Int {
    case lastWeek = 1
    case lastMonth = 2
    case lastYear = 3
    
    var title: String {
        switch self {
        case .lastWeek:
            return "Last week".localize()
        case .lastMonth:
            return "Last month".localize()
        case .lastYear:
             return "Last year".localize()
        }
    }
    
    var statsTitle: String {
        switch self {
        case .lastWeek:
            return "from last week".localize()
        case .lastMonth:
            return "from last month".localize()
        case .lastYear:
            return "from last year".localize()
        }
    }
}

// Seller Product List
enum StatsCell: Int {
    case headerCell = 0
    case revenueCell = 1
    case graphCell = 2
    case orderCountCell = 3
    case searchStatCell = 4
    case sellingStatCell = 5
    case productStatsHeaderCell = 6
    case noDataCell = 7
    
    var height: CGFloat {
        switch self {
        case .headerCell:
            return 90.0
        case .revenueCell:
            return 55.0
        case .graphCell:
            return 130.0
        case .orderCountCell:
            return 35.0
        case .searchStatCell:
            return 70.0
        case .sellingStatCell:
            return 70.0
        case .productStatsHeaderCell:
            return 190.0
        case .noDataCell:
            return 150.0
        }
    }
}

//Withdraw Status
enum WithdrawStatus: Int {
    case pending = 1
    case processing = 2
    case success = 3
}

enum WithdrawType: Int {
    case cheque = 1
    case wireTransfer = 2
    
    var title: String {
        switch self {
        case .cheque:
            return "Cheque".localize()
        case .wireTransfer:
            return "Wire Transfer".localize()
        }
    }
}

//PushType
enum PushType: String {
    case buyerOrderSuccess = "1"
    case sellerOrderReceived = "2"
    case buyerOrderAccept = "3"
    case buyerOrderReject = "4"
    case buyerAdminOrderReject = "5"
    case buyerOrderAcceptPickup = "6"
    case buyerOrderDeliveredPickup = "7"
    case driverOrderAssigned = "8"
    case sellerOrderAssignedToDriver = "9"
    case sellerDriverStartedPickup = "10"
    case buyerDriverStartDelivery = "12"
    case sellerDriverStartDelivery = "13"
    case buyerDriverDeliveredOrder = "14"
    case sellerDriverDeliveredOrder = "15"
    case sellerBuyerLeavesFeedback = "16"
    case sellerBuyerRejectsOrder = "17"
    case sellerItemBecomesActive = "18"
    case sellerBuyerAsksQuestion = "19"
    case buyerSellerRepliesQuestion = "20"
    case sellerBuyerFollow = "21"
    case sellerAdminOrderReject = "22"
}

// Home Feeds View
enum ActivityCell: Int {
    
    case buyerOrderSuccessCell = 1
    case sellerOrderReceivedCell = 2
    case buyerOrderAcceptCell = 3
    case buyerOrderRejectCell = 4
    case buyerAdminOrderRejectCell = 5
    case buyerOrderAcceptPickupCell = 6
    case buyerOrderDeliveredPickupCell = 7
    case driverOrderAssignedCell = 8
    case sellerOrderAssignedToDriverCell = 9
    case sellerDriverStartedPickupCell = 10
    case buyerDriverStartDeliveryCell = 12
    case sellerDriverStartDeliveryCell = 13
    case buyerDriverDeliveredOrderCell = 14
    case sellerDriverDeliveredOrderCell = 15
    case sellerBuyerLeavesFeedbackCell = 16
    case sellerBuyerRejectsOrderCell = 17
    case sellerItemBecomesActiveCell = 18
    case sellerBuyerAsksQuestionCell = 19
    case buyerSellerRepliesQuestionCell = 20
    case sellerBuyerFollowCell = 21
    case sellerAdminOrderRejectCell = 22
}

enum TrackNotification: String {
    case driverData = "driverData"
    
    func name() -> NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}

enum NotificationName: String {
    case updateCategory = "updateCategory"
    
    func name() -> NSNotification.Name{
        return NSNotification.Name(rawValue: self.rawValue)
    }
}
