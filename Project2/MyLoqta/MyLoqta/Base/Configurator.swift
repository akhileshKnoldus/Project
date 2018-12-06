//
//  Configurator.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/05/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

enum StoryboardType: String {
    
    case LaunchScreen
    case Main
    case LoginSignup
    case SellerLoginSignup
    case Profile
    case Home
    case Product
    
    var storyboardName: String {
        return rawValue
    }
}
