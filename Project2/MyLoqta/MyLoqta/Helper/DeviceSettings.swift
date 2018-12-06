//
//  DeviceSettings.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

enum HardWareAccessType: String {
    
    case camera = "camera"
    case library = "library"
    case email = "email"
    case location = "location"
}

class DeviceSettings {
    
    // MARK: - Camera and library validation
    
    class func checkCameraSettings( _ target: UIViewController? , completionClosure: @escaping (_ success: Bool) -> () = {(success) in}) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if(status == AVAuthorizationStatus.authorized) {
            completionClosure(true)
        }else if(status == AVAuthorizationStatus.denied){
            self.openSetting(HardWareAccessType.camera, target: target)
            completionClosure(false)
        }else if(status == AVAuthorizationStatus.notDetermined){
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                
                if granted == true
                {
                    completionClosure(true)
                }
                else
                {
                    completionClosure(false)
                    self.openSetting(HardWareAccessType.camera, target: target)
                }
            });
        }
    }
    
    // MARK: - Chech library settings
    
    class func checklibrarySettings(_ target: UIViewController? , completionClosure: @escaping (_ success: Bool) -> () = {(success) in}) {
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completionClosure(true)
            case .denied:
                completionClosure(false)
                DispatchQueue.main.async(execute: {
                    self.openSetting(HardWareAccessType.library, target: target)
                })
            default:
                completionClosure(true)
                break
            }
        }
    }
    
    // MARK: - Chech location settings
    
    class func checkLocationSettings(_ target: UIViewController? , completionClosure: @escaping (_ success: Bool) -> () = {(success) in}) {
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completionClosure(true)
        case .denied:
            completionClosure(false)
            DispatchQueue.main.async(execute: {
                self.openSetting(HardWareAccessType.location, target: target)
            })
        default:
            completionClosure(true)
            break
        }
    }
    
    // MARK: - Open settings for hardware type
    
    class func openSetting(_ hardWareAccessType : HardWareAccessType , target: UIViewController?){
        
        var InvalidHardware = ""
        switch hardWareAccessType {
        case .camera:
            InvalidHardware = NSLocalizedString("invalidCamera", comment: "")
        case .library:
            InvalidHardware = NSLocalizedString("invalidLibrary", comment: "")
        case .email:
            InvalidHardware = NSLocalizedString("invalidEmail", comment: "")
        case .location:
            InvalidHardware = NSLocalizedString("invalidLocation", comment: "")
        }
        
        let alertController = UIAlertController (title: "myLoqta".localize(),
                                                 message: InvalidHardware,
                                                 preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""),  style: .default) { (_) -> Void in
            
            var settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            
            if hardWareAccessType == .email {
                settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            }
            
            guard let url = settingsUrl else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, completionHandler: { (success) in
                    //print("Settings opened: \(success)")
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async(execute: {
            var topView: UIViewController? = target
            if topView == nil {
//                topView = Helper.getTopMostViewController()
            }
            topView?.present(alertController, animated: true, completion: nil)
        })
    }
}
