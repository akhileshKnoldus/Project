//
//  Helper.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 10/31/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import AVKit

//import FirebaseDynamicLinks
//import SKPhotoBrowser

class Helper {
    
    // MARK: Layout direction
    class var layoutDirectionRTL: Bool {
        // arabic layout
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    class func getTargetViewC(_ anyObject: UIResponder) -> UIViewController? {
        if let viewC = anyObject.owningViewController() {
            if viewC.navigationController != nil {
                return viewC
            } else if let finalVC = viewC.owningViewController(), finalVC.navigationController != nil {
                return finalVC
            }
        }
        return nil
    }
    
    // MARK: - Get root view controller
    class func rootViewController() -> UIViewController {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    // MARK: - Get topmost view controller
    class func topMostViewController(rootViewController: UIViewController) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return topMostViewController(rootViewController: navigationController.visibleViewController!)
        }
        if let tabBarController = rootViewController as? UITabBarController {
            if let selectedTabBarController = tabBarController.selectedViewController {
                return topMostViewController(rootViewController: selectedTabBarController)
            }
        }
        if let presentedViewController = rootViewController.presentedViewController {
            return topMostViewController(rootViewController: presentedViewController)
        }
        return rootViewController
    }
    
    class func visibleController() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
    
    class func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {
        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
    }
    
    class func getIndexPathFor(view: UIView, collectionView: UICollectionView) -> IndexPath? {
        let point = collectionView.convert(view.bounds.origin, from: view)
        let indexPath = collectionView.indexPathForItem(at: point)
        return indexPath
    }
    
    class func getDatestring(date: Date) -> String {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    class func isValidEmail(emailString:String, strictFilter:Bool) -> Bool {
        let strictEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = strictFilter ? strictEmailRegEx : laxString
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailString)
    }
    

    class public func toJsonString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    /*
    class func getFileSize(url: URL) -> Double {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: url.path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / (Constant.byte1024 * Constant.byte1024)
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }*/
    
    class func getDeviceLanguage() -> String
    {
        var strDeviceCurrentLanguage:String
        
        let languageObj = NSLocale.preferredLanguages.first
        //let languageDic = NSLocale.components(fromLocaleIdentifier: languageObj)
        let languageDic = NSLocale.components(fromLocaleIdentifier: languageObj!)
        let language = languageDic["kCFLocaleLanguageCodeKey"]
        
        if (language == "ar") {
            strDeviceCurrentLanguage = "arabic"
        } else {
            strDeviceCurrentLanguage = ""
        }
        return strDeviceCurrentLanguage
    }
    
    // Done Toolbar
    public class func getDoneToolBarInstanceWith(selector: Selector, target: Any?) -> UIToolbar
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done".localize(), style: UIBarButtonItemStyle.done, target: target, action: selector)
        done.tintColor = UIColor.appOrangeColor
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        return doneToolbar
    }
    
    //Return Product Shipping Title
    public class func returnShippingTitle(shipping: Int) -> String {
        switch shipping {
        case productShipping.buyerWillPay.rawValue:
            return "Buyer will pay".localize()
        case productShipping.iWillPay.rawValue:
            return "I will pay".localize()
        case productShipping.pickup.rawValue:
            return "Self pickup".localize()
        case productShipping.iWillDeliver.rawValue:
            return "I will deliver".localize()
        case productShipping.homeDelivery.rawValue:
            return "Home delivery".localize()
        default:
            return ""
        }
    }
    
    //Return Product Condition Title
    public class func returnConditionTitle(condition: Int) -> String {
        switch condition {
        case productCondition.new.rawValue:
            return "New".localize()
        case productCondition.used.rawValue:
            return "Used".localize()
        default:
            return ""
        }
    }
    
    //ReturnOrderStatusTextAndColor
    public class func getOrderStatsText(orderStatus: OrderStatus) -> (title: String, textColor: UIColor, bgColor: UIColor ){
        switch orderStatus {
        case .newOrder: return ("NEW".localize(), UIColor.colorWithRGBA(redC: 40, greenC: 139, blueC: 255, alfa: 1), UIColor.colorWithRGBA(redC: 40, greenC: 139, blueC: 255, alfa: 0.3))
            
        case .waitingForPickup: return ("WAITING FOR PICKUP".localize(), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 1), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 0.3))
            
        case .onTheWay: return ("ON THE WAY".localize(), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 1), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 0.3))
            
        case .delivered: return ("DELIVERED".localize(), UIColor.colorWithRGBA(redC: 119, greenC: 213, blueC: 15, alfa: 1), UIColor.colorWithRGBA(redC: 119, greenC: 213, blueC: 15, alfa: 0.3))
            
        case .completed: return ("COMPLETED".localize(), UIColor.colorWithRGBA(redC: 119, greenC: 213, blueC: 15, alfa: 1), UIColor.colorWithRGBA(redC: 119, greenC: 213, blueC: 15, alfa: 0.3))
            
        case .cancelledByMerchant: return ("REJECTED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .rejected_byCustomer: return ("REJECTED BY CUSTOMER".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .rejected_onTheWayToSeller: return ("RETURNED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .rejected_recievedByMerchant: return ("RETURNED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .cancelled_byAdmin: return ("REJECTED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
        }
    }
}
