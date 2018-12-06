//
//  AVLocationManager.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/21/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import CoreLocation

/**
 This class retuens the current Location and the adrress space using Location Manager
 and it's delegate.
 **/
class AVLocationManager: NSObject
{
    // MARK: - Singleton Instantiation
    
    private static let _sharedInstance: AVLocationManager = AVLocationManager()
    static var sharedInstance: AVLocationManager {
        return ._sharedInstance
    }
    
    // MARK: - Fileprivate Properties
    
    var locationManager: CLLocationManager!
    
    // MARK: - Public Properties
    
    public var currentLocationProvider: ((CLLocation)->())? = nil
//    public var locationAddressProvider: ((LMAddress)->())? = nil
    
    // MARK: - Initializers
    
    private override init() {
        // This will resctrict the instantiation of this class.
    }
    
    // MARK: - Public Methods
    
    func determineCurrentLocation(withAccuracy: CLLocationAccuracy =  kCLLocationAccuracyBest)
    {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
//    func getLocationAddress(paramLocation:CLLocation?) {
//        guard let location = paramLocation else {
//            return
//        }
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
//            var placemark:CLPlacemark!
//
//            if error == nil && placemarks != nil && placemarks!.count > 0
//            {
//                let address = LMAddress()
//
//                placemark = placemarks![0] as CLPlacemark
//
//                if placemark.name != nil
//                {
//                    address.city = placemark.locality
//                }
//                if placemark.postalCode != nil
//                {
//                    address.zipCode = placemark.postalCode
//                }
//                if placemark.locality != nil
//                {
//                    address.locality = placemark.thoroughfare
//                }
//                self.locationAddressProvider?(address)
//            }
//        })
//    }
}

// MARK: - Location Manager Delegates

extension AVLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        self.currentLocationProvider?(userLocation)
        manager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("LocationManager Error: ********* \(error)")
    }
}

