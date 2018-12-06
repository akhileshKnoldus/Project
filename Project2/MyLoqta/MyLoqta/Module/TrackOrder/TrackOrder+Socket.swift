//
//  TrackOrder+Socket.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import MapKit

class MLMapAnnotation: MKPointAnnotation {
    var pinImgName: String = "icMapCart"
}

class MLMapAnnotationView: MKAnnotationView {
}


extension TrackOrderViewC {
    
    
    func didUpdateLocationOfDriver(coordinate: CLLocationCoordinate2D) {
        let annotation = MLMapAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
    }
}
