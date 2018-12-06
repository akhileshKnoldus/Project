//
//  AppDelegate+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 11/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

//Notification Navigation Methods
extension AppDelegate {
    
    func navigateToDetail(pushType: String, dictData: [String: AnyObject]) {
        if let typePush = PushType(rawValue: pushType) {
            switch typePush {
            case .buyerOrderSuccess: self.moveToMyOrdersListView()
            case .sellerOrderReceived: self.moveToSellerOrderScreen()
            case .buyerOrderAccept: self.moveToBuyerOrderDetail(dictData: dictData)
            case .buyerOrderReject: self.moveToBuyerOrderDetail(dictData: dictData)
            case .buyerAdminOrderReject: self.moveToBuyerOrderDetail(dictData: dictData)
            case .sellerAdminOrderReject: self.moveToSellerOrderDetail(dictData: dictData)
            case .buyerOrderAcceptPickup: self.moveToBuyerOrderDetail(dictData: dictData)
            case .buyerOrderDeliveredPickup: self.moveToMyOrdersListView() //Accept/Reject Screen
            case .driverOrderAssigned: break
            case .sellerOrderAssignedToDriver: self.moveToSellerOrderScreen()
            case .sellerDriverStartedPickup: self.moveToSellerOrderScreen()
            case .buyerDriverStartDelivery: self.moveToMyOrdersListView()
            case .sellerDriverStartDelivery: self.moveToSellerOrderScreen()
            case .buyerDriverDeliveredOrder: self.moveToMyOrdersListView() //Accept/Reject Screen
            case .sellerDriverDeliveredOrder: self.moveToSellerOrderScreen()
            case .sellerBuyerLeavesFeedback: break /*self.moveToSellerFeedbackView()*/
            case .sellerBuyerRejectsOrder: break
            case .sellerItemBecomesActive: self.moveToSellerProductsScreen()
            case .sellerBuyerAsksQuestion: self.moveToNotificationTab()
            case .buyerSellerRepliesQuestion: self.moveToNotificationTab()
            case .sellerBuyerFollow: self.moveToNotificationTab()
            }
        }
    }
}

extension AppDelegate {
    
    func checkUserStatus() {
        if UserSession.sharedSession.isLoggedIn() {
            self.showHome()
        } else {
           self.showTutorial()
        }
        // For test purposone only, need to remove later
        //self.forTestPurposeOnly()
    }
    
    func forTestPurposeOnly() {
        //PrepareProfileViewC
        if let tutorialVC = DIConfigurator.sharedInst().getOTPViewC() {
            let navC = UINavigationController(rootViewController: tutorialVC)
            navC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = nil
            self.window?.rootViewController = navC
        }
    }
    
    func showTutorial() {
        if let tutorialVC = DIConfigurator.sharedInst().getTutotialVC() {
            self.window?.rootViewController = nil
            self.window?.rootViewController = tutorialVC
        }
    }
    
    func getUserId() -> String {
        return UserSession.sharedSession.getUserId()
    }
    
    func showHome() {
        if let tabbar = DIConfigurator.sharedInst().getTabBar() {
            self.window?.rootViewController = tabbar
        }
    }
    
    func showTermsAndCondition() {
        if let termsCondVC = DIConfigurator.sharedInst().getTermsAndCondVC() {
            let navC = UINavigationController(rootViewController: termsCondVC)
            navC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navC
        }
    }
    
    func showSingup() {
        if let signupVC = DIConfigurator.sharedInst().getSigup() {
            self.window?.rootViewController = signupVC
        }
    }
    
    func showEmptyProfile() {
        if let profileNavC = DIConfigurator.sharedInst().getProfileNavC() {
            self.window?.rootViewController = profileNavC
        }
    }
    
    func showSellerSignup() {
        if let sellerNavC = DIConfigurator.sharedInst().getSellerNavC() {
            self.window?.rootViewController = nil
            self.window?.rootViewController = sellerNavC
        }
    }
    
    func showExploreMainVC() {
        if let exploreMainNavC = DIConfigurator.sharedInst().getExploreNavC() {
            self.window?.rootViewController = nil
            self.window?.rootViewController = exploreMainNavC
        }
    }
    
    func showSellerProductsVC() {
        if let sellerProductsNavC = DIConfigurator.sharedInst().getSellerProductsNavC() {
            self.window?.rootViewController = nil
            self.window?.rootViewController = sellerProductsNavC
        }
    }
    
    func showActivityViewC() {
        if let activityNavC = DIConfigurator.sharedInst().getActivityNavC() {
            self.window?.rootViewController = nil
            self.window?.rootViewController = activityNavC
        }
    }
    
    func moveToMyOrdersListView() {
        if let buyerOrderListViewC = DIConfigurator.sharedInst().getBuyerOrderListViewC() {
            buyerOrderListViewC.isFromMyOrders = true
            let navC = UINavigationController(rootViewController: buyerOrderListViewC)
            self.window?.rootViewController = nil
            self.window?.rootViewController = navC
        }
    }
    
    func moveToSellerOrderScreen() {
        if let tabbar = DIConfigurator.sharedInst().getTabBar() {
            self.window?.rootViewController = tabbar
            tabbar.selectedIndex = 2
            if let sellerProductsNavC = tabbar.selectedViewController as? UINavigationController {
                if let sellerProductsVC = sellerProductsNavC.topViewController as? SellerProductListViewC {
                    sellerProductsVC.selectOrder = true
                }
            }
        }
    }
    
    func moveToSellerProductsScreen() {
        if let tabbar = DIConfigurator.sharedInst().getTabBar() {
            self.window?.rootViewController = tabbar
            tabbar.selectedIndex = 2
            if let sellerProductsNavC = tabbar.selectedViewController as? UINavigationController {
                if let sellerProductsVC = sellerProductsNavC.topViewController as? SellerProductListViewC {
                    sellerProductsVC.selectOrder = false
                }
            }
        }
    }
    
    func moveToBuyerOrderDetail(dictData: [String: AnyObject]) {
        if let orderDVC = DIConfigurator.sharedInst().getOrderDetailVC() {
            var orderID = 0
            if let orderId = dictData["orderDetailId"] as? String, let intOrderId = Int(orderId) {
                orderID = intOrderId
            } else if let orderId = dictData["orderDetailId"] as? Int {
                orderID = orderId
            }
            orderDVC.orderId = orderID
            orderDVC.isFromNotification = true
            let navC = UINavigationController(rootViewController: orderDVC)
            self.window?.rootViewController = nil
            self.window?.rootViewController = navC
        }
    }
    
    func moveToSellerOrderDetail(dictData: [String: AnyObject]) {
        if let orderDVC = DIConfigurator.sharedInst().getItemStateVC(), let orderId = dictData["orderDetailId"] as? Int, let itemId = dictData["itemId"] as? Int {
            orderDVC.orderDetailId = orderId
            orderDVC.itemId = itemId
            orderDVC.isFromNotification = true
            let navC = UINavigationController(rootViewController: orderDVC)
            self.window?.rootViewController = nil
            self.window?.rootViewController = navC
        }
    }
    
    func moveToNotificationTab() {
        if let tabbar = DIConfigurator.sharedInst().getTabBar() {
            self.window?.rootViewController = tabbar
            tabbar.selectedIndex = 3
        }
    }
    
    func moveToSellerFeedbackView(dictData: [String: AnyObject]) {
        if let feedbackVC = DIConfigurator.sharedInst().getSellerFeedbackViewC(), let orderId = dictData["orderDetailId"] as? Int {
            feedbackVC.orderDetailId = orderId
            feedbackVC.isFromNotification = true
            let navC = UINavigationController(rootViewController: feedbackVC)
            self.window?.rootViewController = nil
            self.window?.rootViewController = navC
        }
    }
    
    func logout() {
        UserSession.sharedSession.clearDataOfUserSession()
        AppDelegate.delegate.showHome()
    }
}
