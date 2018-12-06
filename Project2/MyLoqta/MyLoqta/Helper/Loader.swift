//
//  Loader.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 15/11/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation
import ReachabilitySwift
import SVProgressHUD

class Loader {
    
    // MARK: - Loading Indicator
    
    static let thickness = CGFloat(6.0)
    static let radius = CGFloat(22.0)
    
    class func showLoader(title: String = "Loading...") {
        
        DispatchQueue.main.async {
//            UIApplication.shared.beginIgnoringInteractionEvents()
            
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setRingThickness(thickness)
            SVProgressHUD.setRingRadius(radius)
            SVProgressHUD.setForegroundColor(UIColor.gray)
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
            }
        }
    }
    
    class func showLoaderInView(title: String = "Loading...", view: UIView) {
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setRingThickness(thickness)
            SVProgressHUD.setRingRadius(radius)
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
            }
        }
    }
    
    class func hideLoader() {
        DispatchQueue.main.async {
//            UIApplication.shared.endIgnoringInteractionEvents()
            SVProgressHUD.dismiss()
        }
    }
    
    class func hideLoaderInView(view: UIView) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Reachability method
    class func isReachabile() -> Bool {
        let reachability = Reachability(hostname: "www.google.com")
        return reachability!.isReachable
    }
}

let isDebugModeOn = true

class Debug {
    
    class func Log<T>(message: T, functionName: String = #function, fileNameWithPath: String = #file, lineNumber: Int = #line ) {
        
        Threads.performTaskInBackground {
            if isDebugModeOn {
                let fileNameWithoutPath:String = NSURL(fileURLWithPath: fileNameWithPath).lastPathComponent ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss.SSS"
                let output = "\r\n❗️\(fileNameWithoutPath) => \(functionName) (line \(lineNumber), at \(dateFormatter.string(from: NSDate() as Date)))\r\n => \(message)\r\n"
                print(output)
            }
        }
    }
}
