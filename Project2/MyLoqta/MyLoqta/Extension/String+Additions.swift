//
//  String+Additions.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 05/12/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation

extension String {
    
    public func toDateInstance() -> Date? {
        return UserSession.sharedSession.dateFormatter.date(from: self)
    }
    
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func hasSubString(_ string: String) -> Bool {
        //return self.contains(string)
        if self.lowercased().range(of: string.lowercased()) != nil {
            return true
        } else {
            return false
        }
    }
    
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
    
    public func localizedString() -> String {
        
        return NSLocalizedString(self, comment: self)
    }
    
    public func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    public func trimSpace() -> String {
        let trimmedString = self.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        return trimmedString
    }
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func checkNoSpecialChacter() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func validString() -> String
    {
        if(self == "<null>" || self == "<NULL>")
        {
            return ""
        }
        else if(self == "<nil>" || self == "<NIL>")
        {
            return ""
        }
        else if(self == "null" || self == "NULL")
        {
            return ""
        }
        else if(self == "NIL" || self == "nil")
        {
            return ""
        }
        else if(self == "(null)")
        {
            return ""
        }
        
        return self
    }
    
    //Convert UTC time to Local
    func UTCToLocal(toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = toFormat
            dateFormatter.timeZone = NSTimeZone.local
            return dateFormatter.string(from: dt)
        }
        return self
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}



extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let value = numberFormatter.string(from: NSNumber(value:self)) {
           return value
        }
        return ""
    }
}

extension Float {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let value = numberFormatter.string(from: NSNumber(value: self)) {
            return value
        }
        return ""
    }
}
