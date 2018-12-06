//
//  NotificationSettingsVM.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

protocol NotificationSettingsVModeling: class {
    func getDataSourceForNotifications() -> [[NotificationSettingData]]
}

typealias NotificationSettingData = (onOffState: Bool, title: String)

class NotificationSettingsVM: BaseModeling, NotificationSettingsVModeling {
    func getDataSourceForNotifications() -> [[NotificationSettingData]] {
        
        //First Section
        let pushNotificationSetting = NotificationSettingData(true, "Push notifications".localize())
        
        //Second Section
        let buyerItemsInterested = NotificationSettingData(false, "Notify me with updates to items I’m interested in".localize())
        let buyerItemsPurchased = NotificationSettingData(false, "Notify me with updates on items I’ve purchased".localize())
        
        //Third section
        let sellerItemsSold = NotificationSettingData(true, "Notify me with updates about an item I’ve sold")
        let sellerItemStatus = NotificationSettingData(true, "Notify me with updates about an item statuses")
        
        //Fourth Section
        let generalSetting = NotificationSettingData(true, "Notify me when I receive a message from user")
        return [[pushNotificationSetting], [buyerItemsInterested, buyerItemsPurchased], [sellerItemsSold, sellerItemStatus], [generalSetting]]
    }
}
