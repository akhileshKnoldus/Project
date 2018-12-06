//
//  AppDelegate.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 03/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//
/*
 201, 199 191
 222 */
 

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import AWSCore
import SwiftyUserDefaults
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //http://www.myloqta.com/resetPassword/69/Xh9CVhpgNRmKooUr7gkristI5XL7l2gd
    var window: UIWindow?

    class var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "896283309594-j2chiu194sr7eoptcph6a11sf07akbng.apps.googleusercontent.com"
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.registerForPushNotifications(application: application)
        self.checkUserStatus()
        //self.showHome()
 //       self.checkUserStatus()
        self.initializeS3()
        
        if let option = launchOptions, let url = option[UIApplicationLaunchOptionsKey.url] as? URL {
            self.handleDeepLinking(url: url)
        }
        
        return true
    }
    
    func initializeS3() {
        let poolId = "us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439"
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: poolId)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        TAS3Manager.sharedInst.createS3Folder()
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            if url.absoluteString.hasSubString("myloqta") {
                return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            }
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
 
    
    //- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options

    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //<a href="myloqta://seller/14">Click here to switch to app OR on page load</a>
        //<a href="myloqta://product/20">Click here to switch to app OR on page loadp</a>
        if url.absoluteString.hasSubString("myloqta") {
            self.handleDeepLinking(url: url)
            return true
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //http://www.myloqta.com/resetPassword/69/Xh9CVhpgNRmKooUr7gkristI5XL7l2gd
    //http://www.myloqta.com/SellerDeeplink/product/id
    //http://appinventive.com:8194/deeplinkForget?token=Xh9CVhpgNRmKooUr7gkristI5XL7l2gd&userId=69
    func handleDeepLinking(url: URL) {
        
        let urlStr = url.absoluteString
        let array = urlStr.components(separatedBy: "/")
        let arrayCount = array.count
        
        if arrayCount >= 3 {
            let resetPass = array[(arrayCount - 3)]
            if resetPass == "resetPassword" {
                let idValue = array[(arrayCount - 2)]
                let token = array[(arrayCount - 1)]
                self.deepLinkingResetPassword(userId: idValue, token: token)
                return
            }
        }
        
        if arrayCount >= 2 {
            let idValue = array[(arrayCount - 1)]
            let pushType = array[(arrayCount - 2)]
            self.deepLinking(idValue: idValue, isSeller: (pushType == "seller"))
        }        
    }
    
    func deepLinking(idValue: String, isSeller: Bool) {
        if let topVC = Helper.topMostViewController(rootViewController: Helper.rootViewController()) {
            
            if isSeller {
                if let sellerProfileVC = DIConfigurator.sharedInst().getSellerProfileVC(), let storeId = Int(idValue) {
                    //sellerProfileVC.isSelfProfile = false
                    sellerProfileVC.sellerId = storeId
                    //sellerProfileVC.delegate = self
                    topVC.navigationController?.pushViewController(sellerProfileVC, animated: false)
                }
            } else {
                if let detailVC = DIConfigurator.sharedInst().getBuyerProducDetail(), let itemId = Int(idValue) {
                    detailVC.productId = itemId
                    topVC.navigationController?.pushViewController(detailVC, animated: false)
                }
            }
        }
    }
    
    func deepLinkingResetPassword(userId: String, token: String) {
        if UserSession.sharedSession.isLoggedIn() {
            return
        }
        
        if let topVC = Helper.topMostViewController(rootViewController: Helper.rootViewController()), let updatePassVC = DIConfigurator.sharedInst().getUpdatePasswordVC()  {
            updatePassVC.userId = userId
            updatePassVC.token = token
            topVC.navigationController?.pushViewController(updatePassVC, animated: false)
        }
    }
    
    
   

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK: - Push Notification Methods

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //MARK: - Push Notification
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(token)
        Defaults[.deviceToken] = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
    }
    
    // Banner Tapped - App Active
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("User info -----\(userInfo)")
        
        guard let dictData = userInfo["data"] as? [String : AnyObject],
            let pushType = userInfo["pushType"] as? String
            else {
                return;
        }
        self.navigateToDetail(pushType: pushType, dictData: dictData)
    }
    
    // This method will be called when app receives push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        
        print("received notification\(notification.request.content)")
        completionHandler([.alert,.sound,.badge])
    }
}

