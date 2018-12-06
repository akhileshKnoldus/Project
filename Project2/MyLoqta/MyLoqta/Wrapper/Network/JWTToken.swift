//
//  JWTToken.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 17/11/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation
import JWT

class JWTToken: BaseModeling {
    
    static let sharedHandler = JWTToken()
    let JWTSecretCode = "5rLiee5e5HNA9jKDlrIcIWdNRrZusfLg"
    
    
    func createJWTToken(userId:Any, expiry: Double?)->String
    {
        let enodedToken = JWT.encode(.hs256(JWTSecretCode.data(using: .utf8)!), closure: { (payLoadBuilder) in
            
            var expiryDate = Date()
            let currentDate = NSDate(timeIntervalSince1970:Double(Int(Date().timeIntervalSince1970)))
    
            if expiry != nil {
                expiryDate = currentDate.addingTimeInterval(expiry!*60) as Date
            }
            payLoadBuilder.expiration = expiryDate
            payLoadBuilder.issuedAt = currentDate as Date
            payLoadBuilder["sub"] = userId
        })
        return enodedToken
    }
    
}
