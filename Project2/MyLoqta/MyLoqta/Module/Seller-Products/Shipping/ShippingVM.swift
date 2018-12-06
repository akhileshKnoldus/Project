//
//  ShippingVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

protocol ShippingVModeling {
    func getModel() -> [[String: String]]
}

class ShippingVM: BaseModeling, ShippingVModeling {
    
    func getModel() -> [[String: String]] {
     
        var array = [[String: String]]()
        let firstDict = [Constant.keys.kTitle: "Buyer will pay".localize(), Constant.keys.kValue: "Delivery will be done by our driver and your customer will be charged for it".localize()]
        array.append(firstDict)
        
        let secondtDict = [Constant.keys.kTitle: "I will pay".localize(), Constant.keys.kValue: "Delivery will be done by our driver and you will be charged for it".localize()]
        array.append(secondtDict)
        
        let thirdDict = [Constant.keys.kTitle: "Self pickup".localize(), Constant.keys.kValue: "Your customer will choose: a pickup or a paid delivery made by our driver".localize()]
        array.append(thirdDict)
        
        let fourthDict = [Constant.keys.kTitle: "I will deliver".localize(), Constant.keys.kValue: "Delivery will be done by yourself or your driver".localize()]
        array.append(fourthDict)
        
        return array
    }
    
}
