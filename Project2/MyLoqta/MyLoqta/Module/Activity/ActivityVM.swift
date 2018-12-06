//
//  ActivityVM.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//


import Foundation
import SwiftyUserDefaults

protocol ActivityVModeling: class {
    func getDataSourceForActivity(arrActivities: [Activity]) -> [[ActivityNotificationsData]]
    func requestGetNotificationList(page: Int, isShowLoader: Bool, completion: @escaping (_ notificationList: [Activity]) ->Void)
    func requestToAcceptOrder(orderDetailId: Int, type: Int, completion: @escaping (_ success: Bool) ->Void)
}

typealias ActivityNotificationsData = (cellType: Int , height: CGFloat, activity: Activity)

class ActivityVM: ActivityVModeling, BaseModeling {
    
    func getDataSourceForActivity(arrActivities: [Activity]) -> [[ActivityNotificationsData]] {
        var arrActionActivities = [ActivityNotificationsData]()
        var otherActionActivities = [ActivityNotificationsData]()
        
        for activity in arrActivities {
            if let typeP = activity.pushType, let pushType = PushType(rawValue: typeP) {
                //Action Needed Notification
                if activity.actionType == 1 {
                    switch pushType {
                        
                    case .sellerOrderReceived:
                        let acceptRejectNoti = ActivityNotificationsData(ActivityCell.sellerOrderReceivedCell.rawValue, UITableViewAutomaticDimension, activity)
                        arrActionActivities.append(acceptRejectNoti)
                        
                    case .buyerOrderDeliveredPickup:
                        let buyerOrderDeliveredNoti = ActivityNotificationsData(ActivityCell.buyerOrderDeliveredPickupCell.rawValue, UITableViewAutomaticDimension, activity)
                        arrActionActivities.append(buyerOrderDeliveredNoti)
                       
                    case .buyerDriverDeliveredOrder:
                        let buyerOrderDeliveredNoti = ActivityNotificationsData(ActivityCell.buyerDriverDeliveredOrderCell.rawValue, UITableViewAutomaticDimension, activity)
                        arrActionActivities.append(buyerOrderDeliveredNoti)
                        
                    case .sellerBuyerLeavesFeedback:
                        let buyerLeavesFeedbckNoti = ActivityNotificationsData(ActivityCell.sellerBuyerLeavesFeedbackCell.rawValue, UITableViewAutomaticDimension, activity)
                        arrActionActivities.append(buyerLeavesFeedbckNoti)
                        
                    case .sellerBuyerAsksQuestion:
                        let buyerAsksNoti = ActivityNotificationsData(ActivityCell.sellerBuyerAsksQuestionCell.rawValue, UITableViewAutomaticDimension, activity)
                        arrActionActivities.append(buyerAsksNoti)
                        
                    default: continue
                    }
                } else {
                    //Other Notification
                    switch pushType {
                        
                    case .buyerOrderSuccess:
                        let orderSuccessNoti = ActivityNotificationsData(ActivityCell.buyerOrderSuccessCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(orderSuccessNoti)
                        
                    case .buyerOrderAccept:
                        let buyerOrderAcceptNoti = ActivityNotificationsData(ActivityCell.buyerOrderAcceptCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(buyerOrderAcceptNoti)
                        
                    case .buyerOrderReject:
                        let buyerOrderRejectNoti = ActivityNotificationsData(ActivityCell.buyerOrderRejectCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(buyerOrderRejectNoti)
                        
                    case .buyerAdminOrderReject:
                        let orderRejectNoti = ActivityNotificationsData(ActivityCell.buyerAdminOrderRejectCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(orderRejectNoti)
                        
                    case .buyerOrderAcceptPickup:
                        let itemActiveNoti = ActivityNotificationsData(ActivityCell.buyerOrderAcceptPickupCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(itemActiveNoti)
                        
                    case .sellerOrderAssignedToDriver:
                        let driverAssignNoti = ActivityNotificationsData(ActivityCell.sellerOrderAssignedToDriverCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(driverAssignNoti)
                        
                    case .sellerDriverStartedPickup:
                        let driverStartPickupNoti = ActivityNotificationsData(ActivityCell.sellerDriverStartedPickupCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(driverStartPickupNoti)
                        
                    case .buyerDriverStartDelivery:
                        let orderStatusNoti = ActivityNotificationsData(ActivityCell.buyerDriverStartDeliveryCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(orderStatusNoti)
                        
                    case .sellerDriverStartDelivery:
                        let driverStartDeliveryNoti = ActivityNotificationsData(ActivityCell.sellerDriverStartDeliveryCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(driverStartDeliveryNoti)
                        
                    case .sellerDriverDeliveredOrder:
                        let driverOrderDeliverNoti = ActivityNotificationsData(ActivityCell.sellerDriverDeliveredOrderCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(driverOrderDeliverNoti)
                        
                    case .sellerItemBecomesActive:
                        let itemActiveNoti = ActivityNotificationsData(ActivityCell.sellerItemBecomesActiveCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(itemActiveNoti)
                        
                    case .buyerSellerRepliesQuestion:
                        let sellerRepliesNoti = ActivityNotificationsData(ActivityCell.buyerSellerRepliesQuestionCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(sellerRepliesNoti)
                        
                    case .sellerBuyerFollow:
                        let buyerFollowsNoti = ActivityNotificationsData(ActivityCell.sellerBuyerFollowCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(buyerFollowsNoti)
                        
                    case .sellerAdminOrderReject:
                        let orderRejectNoti = ActivityNotificationsData(ActivityCell.sellerAdminOrderRejectCell.rawValue, UITableViewAutomaticDimension, activity)
                        otherActionActivities.append(orderRejectNoti)
                        
                    default: continue
                    }
                }
            }
        }
        return [arrActionActivities, otherActionActivities]
    }
    
    //MARK: - API Methods
    func requestGetNotificationList(page: Int, isShowLoader: Bool, completion: @escaping (_ notificationList: [Activity]) ->Void) {
        let params = ["page": page as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .notificationTab(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [[String: AnyObject]] {
                if let notificationList = Activity.formattedArray(data: newResponse) {
                    completion(notificationList)
                }
            }
        })
    }
    
    func requestToAcceptOrder(orderDetailId: Int, type: Int, completion: @escaping (_ success: Bool) ->Void) {
        //type = 2 for accepting order
        //type = 4 for item deliverd
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject, "orderDetailId": orderDetailId as AnyObject, "type": type as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .orderStatusChange(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                completion(success)
            }
        })
    }
}
