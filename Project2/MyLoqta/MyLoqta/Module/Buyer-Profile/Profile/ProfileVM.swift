//
//  ProfileVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

typealias BuyerProfileType = (cellType: Int , height: CGFloat)

protocol ProfileVModeling: class {
    func getDatasourceForProfile(orders: [Product]) -> [BuyerProfileType]
    func requestGetMyProfile(isShowLoader: Bool, completion: @escaping (_ user: User, _ orders: [Product]) ->Void)
}

class ProfileVM: BaseModeling, ProfileVModeling {
    
    func getDatasourceForProfile(orders: [Product]) -> [BuyerProfileType] {
        
        //DraftedProductDataSource
        var arrDataSource = [BuyerProfileType]()
        
        //ProfileDetailCell
        let profileCell = BuyerProfileType(BuyerProfileCell.profileDetailCell.rawValue, BuyerProfileCell.profileDetailCell.height)
        arrDataSource.append(profileCell)
        
        //OrderCell
        if orders.count > 0 {
            let orderCell = BuyerProfileType(BuyerProfileCell.orderCell.rawValue, BuyerProfileCell.orderCell.height)
            arrDataSource.append(orderCell)
        }
        
        //LikesCell
        let likeCell = BuyerProfileType(BuyerProfileCell.myLikeCell.rawValue, BuyerProfileCell.myLikeCell.height)
        arrDataSource.append(likeCell)
        
        //ReviewsCell
        let reviewsCell = BuyerProfileType(BuyerProfileCell.reviewAboutMe.rawValue, BuyerProfileCell.reviewAboutMe.height)
        arrDataSource.append(reviewsCell)
        
        return arrDataSource
    }

    func requestGetMyProfile(isShowLoader: Bool, completion: @escaping (_ user: User, _ orders: [Product]) ->Void) {
        let params = [:] as [String: AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .getMyProfile(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject], let orderResponse = newResponse["recentOrders"] as? [[String: AnyObject]] {
                //                let jwtToken = JWTToken.sharedHandler.creat createJWTToken(userId: userId)
                //                Defaults[.jwtToken] = jwtToken
                //                Defaults[.userType] = userType
                //                Defaults[.langCode] = languageCode
                if let user = User.formattedData(data: newResponse), let orders = Product.formattedArray(data: orderResponse) {
                    completion(user, orders)
                }
            }
        })
    }
}
