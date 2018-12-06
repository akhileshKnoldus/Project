//
//  Alert.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 15/11/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation
import UIKit


class Alert {
    
    // MARK: Alert methods
    class func Alert(_ message: String, okButtonTitle: String? = nil, target: UIViewController? = nil) {
        
        //BZBanner.showMessage(nil, message: message)
    }
    
    class func showOkAlert(title: String?, message: String)
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok".localize(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if let topViewController: UIViewController = Helper.topMostViewController(rootViewController: Helper.rootViewController()) {
            topViewController.present(alertController, animated: true, completion: nil)
        } else if let viewC = AppDelegate.delegate.window?.rootViewController {
            viewC.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showOkAlertWithCallBack(title: String, message: String ,completeion_: @escaping (_ compl:Bool)->())
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok".localize(), style: .cancel, handler: { (action:UIAlertAction!) -> Void in
            completeion_(true) //returns true in callback to perform action on last screen
        })
        alertController.addAction(cancelAction)
        if let topViewController: UIViewController = Helper.topMostViewController(rootViewController: Helper.rootViewController()) {
            topViewController.present(alertController, animated: true, completion: nil)
        } else if let viewC = AppDelegate.delegate.window?.rootViewController {
            viewC.present(alertController, animated: true, completion: nil)
        }
        /*
        let topViewController: UIViewController = Helper.topMostViewController(rootViewController: Helper.rootViewController())!
        topViewController.present(alertController, animated: true, completion: nil)
 */
    }
    
    class func showOkGrayAlertWithCallBack(title: String, message: String ,completeion_: @escaping (_ compl:Bool)->())
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok".localize(), style: .cancel, handler: { (action:UIAlertAction!) -> Void in
            completeion_(true) //returns true in callback to perform action on last screen
        })
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        if let topViewController: UIViewController = Helper.topMostViewController(rootViewController: Helper.rootViewController()) {
            topViewController.present(alertController, animated: true, completion: nil)
        } else if let viewC = AppDelegate.delegate.window?.rootViewController {
            viewC.present(alertController, animated: true, completion: nil)
        }
        /*
         let topViewController: UIViewController = Helper.topMostViewController(rootViewController: Helper.rootViewController())!
         topViewController.present(alertController, animated: true, completion: nil)
         */
    }
    
    class func showAlert(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .alert, actions: UIAlertAction...) {
        
        let topViewController: UIViewController? = Helper.topMostViewController(rootViewController: Helper.rootViewController())
        var strTitle: String = ""
        if let titleStr = title {
            strTitle = titleStr
        } else {
            strTitle = ConstantTextsApi.AppName.localizedString
        }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: style)
        if !actions.isEmpty {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            let cancelAction = UIAlertAction(title: ConstantTextsApi.cancel.localizedString, style: .default, handler: nil)
            alertController.addAction(cancelAction)
        }
        topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithAction(title: String?, message: String?, style: UIAlertControllerStyle, actionTitles:[String?], action:((UIAlertAction) -> Void)?) {
        
        showAlertWithActionWithCancel(title: nil, message: message, style: style, actionTitles: actionTitles, showCancel: false, deleteTitle: nil, action: action)
    }
    
    class func showAlertWithActionWithCancel(title: String?, message: String?, style: UIAlertControllerStyle, actionTitles:[String?], showCancel:Bool, deleteTitle: String? ,_ viewC: UIViewController? = nil, action:((UIAlertAction) -> Void)?) {
        
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: style)
        if deleteTitle != nil {
            let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: action)
            alertController.addAction(deleteAction)
        }
        
        for (_, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: action)
            alertController.addAction(action)
        }
        
        if showCancel {
            let cancelAction = UIAlertAction(title: ConstantTextsApi.cancel.localizedString, style: .default, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        if let viewController = viewC {
            
            viewController.present(alertController, animated: true, completion: nil)
            
        } else {
            let topViewController: UIViewController? = Helper.topMostViewController(rootViewController: Helper.rootViewController())
            topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Logout Alert
    class func showAlertWithActionWithColor(title: String?, message: String?, actionTitle: String?, showCancel:Bool,_ viewC: UIViewController? = nil, action:((UIAlertAction) -> Void)?) {
        
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        if showCancel {
            let cancelAction = UIAlertAction(title: ConstantTextsApi.cancel.localizedString, style: .default, handler: nil)
            cancelAction.setValue(UIColor.actionRedColor, forKey: "titleTextColor")
            alertController.addAction(cancelAction)
        }
        
        let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
        action.setValue(UIColor.appOrangeColor, forKey: "titleTextColor")
        alertController.addAction(action)
                
        if let viewController = viewC {
            
            viewController.present(alertController, animated: true, completion: nil)
            
        } else {
            let topViewController: UIViewController? = Helper.topMostViewController(rootViewController: Helper.rootViewController())
            topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //More Options ActionSheet
    class func showAlertSheetWithColor(title: String?, message: String?, actionItems: [[String: Any]], showCancel:Bool,_ viewC: UIViewController? = nil, action:((UIAlertAction) -> Void)?) {
        
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        for actionItem in actionItems {
            if let title = actionItem[Constant.keys.kTitle] as? String, let color = actionItem[Constant.keys.kColor] as? UIColor {
                let action = UIAlertAction(title: title, style: .default, handler: action)
                action.setValue(color, forKey: "titleTextColor")
                alertController.addAction(action)
            }
        }
        
        if showCancel {
            let cancelAction = UIAlertAction(title: ConstantTextsApi.cancel.localizedString, style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.actionBlackColor, forKey: "titleTextColor")
            alertController.addAction(cancelAction)
        }
        
        if let viewController = viewC {
            
            viewController.present(alertController, animated: true, completion: nil)
            
        } else {
            let topViewController: UIViewController? = Helper.topMostViewController(rootViewController: Helper.rootViewController())
            topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
