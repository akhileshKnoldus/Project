
//
//  TabBarViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 05/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class TabBarViewC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func isSellerProfileComplete() -> Bool {
        
        var isSeller = false
        
        if let sellerId = Defaults[.sellerId], sellerId != 0 {
            isSeller = true
        }
        
        if let user = Defaults[.user], let role = user.role, role == 2 {
            isSeller = true
        }
        
        return isSeller
    }
}

extension TabBarViewC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let index = tabBarController.viewControllers?.index(of: viewController) {
            print("new index is \(index)")
            
            if index == 4 {
                if UserSession.sharedSession.isLoggedIn() {
                    if let user = Defaults[.user], let phoneVerified = user.isPhoneVerified {
                        if phoneVerified == 1 {
                            return true
                        } else {
                            AppDelegate.delegate.showTermsAndCondition()
                            return false
                        }
                    }
                } else {
                    AppDelegate.delegate.showEmptyProfile()
                    return false
                }
            }
            
            //if index == 1 {
                //AppDelegate.delegate.showExploreMainVC()
                //return false
            //}
            
            if index == 2 {
                if UserSession.sharedSession.isLoggedIn() {
                    if !isSellerProfileComplete() {
                        AppDelegate.delegate.showSellerSignup()
                        return false
                    } else {
                        //AppDelegate.delegate.showSellerProductsVC()
                        return true
                    }
                } else {
                    AppDelegate.delegate.showEmptyProfile()
                    return false
                }
            }
            
            if index == 3 {
                if !UserSession.sharedSession.isLoggedIn() {
                    AppDelegate.delegate.showEmptyProfile()
                    return false
                } else {
                    return true
                }
            }
        }
        
        return true
    }
}
