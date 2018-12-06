//
//  SellerMoreOptionsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol SellerMoreOptionsVModeling: class {
    func getDataSource() -> [SettingData]
}

class SellerMoreOptionsVM: BaseModeling, SellerMoreOptionsVModeling {
    
    func getDataSource() -> [SettingData] {
        let soldItems = SettingData(#imageLiteral(resourceName: "dallor"), "Sold".localize())
        //let coupons = SettingData(#imageLiteral(resourceName: "coupon"), "Coupons".localize())
        let withdraw = SettingData(#imageLiteral(resourceName: "wallet"), "Withdraw".localize())
        let referral = SettingData(#imageLiteral(resourceName: "icInvite"), "Invite & earn".localize())
//        let statistics = SettingData(#imageLiteral(resourceName: "stats"), "Promote your store".localize())
        let help = SettingData(#imageLiteral(resourceName: "question"), "Help".localize())
        
        return [soldItems, withdraw, referral, help]
    }
}
