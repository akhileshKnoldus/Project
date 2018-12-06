//
//  UserSession.swift
//  TheDon
//
//  Created by Ashish Chauhan on 10/03/18.
//  Copyright © 2018 Ashish Chauhan. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class UserSession {
    
    static let sharedSession = UserSession()
    var userId: String?
    var userName: String?
    var userType: Int?
    var name: String?
    let dateFormatter = DateFormatter()
    
    var testOrder = 0
    var socialAccount = false
    var guestCheckout = false
    var product: Product?
    var param = [String: AnyObject]()
    
    init() {
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "dd MMM yyyy | hh:mm a"
    }
    
    func getUserId() -> String {
        //return "1"
        
        if let userIdValue = self.userId {
            return userIdValue
        } else {
            if let user = Defaults[.user], let userIdValue = user.userId  {
                self.userId = String(userIdValue)
                return self.userId!
            } else {
                return "0"
            }
        }
    }
    
    func getName() -> String {
        if let user = Defaults[.user] {
            return user.fullName
        } else {
            return ""
        }
    }
    
    func isLoggedIn() -> Bool {
        if let user = Defaults[.user], let userId = user.userId  {
            return !"\(userId)".isEmpty
        } else {
            return false
        }
    }
    
    
    func getSellerType() -> sellerType? {
        
        if let user = Defaults[.user], let seller = user.seller, let sellerTypeValue = seller.sellerType {
            if sellerTypeValue == 1 {
                return sellerType.individual
            } else  if sellerTypeValue == 2 {
                return sellerType.business
            }
        }
        return nil
    }
    
    func clearDataOfUserSession() {
        let deviceToken = Defaults[.deviceToken]
        let selectedTheme = Defaults[.selectedTheme]
        userId = nil
        userName = nil
        name = nil
        userType = nil
        Defaults.removeAll()
        Defaults[.deviceToken] = deviceToken
        Defaults[.selectedTheme] = selectedTheme
    }
    
    func getInt16Value(_ obj: AnyObject?) -> Int16 {
        if let object = obj as? String, let intValue = Int16(object) {
            return intValue
        } else if let intValue = obj as? Int16 {
            return intValue
        } else {
            return 0
        }
    }
    
    func getInt64Value(_ obj: AnyObject?) -> Int64 {
        if let object = obj as? String, let intValue = Int64(object) {
            return intValue
        } else if let intValue = obj as? Int64 {
            return intValue
        } else {
            return 0
        }
    }
    
    func getShippingType(intValue: Int) -> String {
        switch intValue {
        case 1: return "Buyer will pay".localize()
        case 2: return "I will pay".localize()
        case 3: return "Self pickup".localize()
        default: return "I will deliver".localize()
            
        }
    }
    
    func getHeightOfQuestionCell(question: Question) -> CGFloat {
        
        var questionStr = ""
        var replyStr = ""
        var htQuestion = CGFloat(0)
        var htReply = CGFloat(0)
        
        if let questionstr = question.question {
            questionStr = questionstr
        }
        
        if let arrayReply = question.reply, arrayReply.count > 0 {
            let reply = arrayReply[0]
            if let replystr = reply.reply {
                replyStr = replystr
            }
        }
        
        let font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
        
        if !questionStr.isEmpty {
            let constraintRect = CGSize(width: (Constant.screenWidth - 116), height: .greatestFiniteMagnitude)
            let boundingBox = questionStr.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
            var ht = ceil(boundingBox.height)
            if ht < 27.0 {
                ht = 27
            }
            htQuestion = ht
        }
        
        if !replyStr.isEmpty {
            let constraintRect = CGSize(width: (Constant.screenWidth - 90), height: .greatestFiniteMagnitude)
            let boundingBox = questionStr.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
            var ht = ceil(boundingBox.height)
            if ht < 20.0 {
                ht = 20.0
            }
            htReply = ht
        }
        
        return (130 + htQuestion + htReply)
        
    }
    
    func getHieghtof(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func shareLink(idValue: Int, isProduct: Bool, fromVC: UIViewController) {
        let shareLink = isProduct ? "http://appinventive.com:8194/productDeepLink?itemId=\(idValue)" : "http://appinventive.com:8194/sellerDeepLink?sellerId=\(idValue)"
        let activityVC = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
        fromVC.present(activityVC, animated: true, completion: nil)
    }
    //Testing
//    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
//        // this needs to return some random image to make sure Twitter and Instagram show up in the sharing actionsheet
//        return UIImage(named: "someImage")!
//    }
    
    func removeGuestItems() {
        self.param.removeAll()
        self.guestCheckout = false
    }
}





