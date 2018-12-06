//
//  Date+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/31/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension Date {
    
    func getMonth() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        print(strMonth)
        return Int(strMonth)
    }
    
    public func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
    
    public var calendar: Calendar {
        return Calendar.current
    }
    
    /// Era.
    public var era: Int {
        return calendar.component(.era, from: self)
    }
    
    /// Year.
    public var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
    }
    
    func localDate() -> Date {
        
        if let timeZone = TimeZone(abbreviation: "UTC") {
            let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
            return Date(timeInterval: seconds, since: self)
        }
        return self
        //return Formatter.preciseLocalTime.string(for: self) ?? ""
    }
    // or GMT time
    func utcDate() -> Date {
        
        if let timeZone = TimeZone(abbreviation: "UTC") {
            let seconds = -TimeInterval(timeZone.secondsFromGMT(for: self))
            return Date(timeInterval: seconds, since: self)
        }
        return self
    }
    
    static func timeSince(_ dateStr: String, numericDates: Bool = false) -> String {
        
        let utcDate = dateStr.toDateInstaceFromStandardFormat()
        if let date = utcDate?.localDate() {
            let calendar = NSCalendar.current
            let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
            let now = Date()
            let earliest = now < date ? now : date
            let latest = (earliest == now) ? date : now
            let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
            if (components.year! >= 2) {
                return "\(components.year!)yrs ago"
            } else if (components.year! >= 1){
                if (numericDates){
                    return "1yr ago"
                } else {
                    return "1yr ago"
                }
            } else if (components.month! >= 2) {
                return "\(components.month!)mon ago"
            } else if (components.month! >= 1){
                if (numericDates){
                    return "1mon ago"
                } else {
                    return "1mon ago"
                }
            } else if (components.weekOfYear! >= 2) {
                return "\(components.weekOfYear!)w ago"
            } else if (components.weekOfYear! >= 1){
                if (numericDates){
                    return "1w ago"
                } else {
                    return "1w ago"
                }
            } else if (components.day! >= 2) {
                return "\(components.day!)d ago"
            } else if (components.day! >= 1){
                if (numericDates){
                    return "1d ago"
                } else {
                    return "1d ago"
                }
            } else if (components.hour! >= 2) {
                return "\(components.hour!)h ago"
            } else if (components.hour! >= 1){
                if (numericDates){
                    return "1h ago"
                } else {
                    return "1h ago"
                }
            } else if (components.minute! >= 2) {
                return "\(components.minute!)mins ago"
            } else if (components.minute! >= 1){
                if (numericDates){
                    return "1min ago"
                } else {
                    return "1min ago"
                }
            } else if (components.second! >= 3) {
                return "\(components.second!)secs ago"
            } else {
                return "Just now"
            }
        }
        return ""
    }
}

extension String {
    func toDateInstaceFromStandardFormat() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        return dateFormatter.date(from: self)
    }
    
    func getDateStringFrom(inputFormat: String, outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = inputFormat
        guard let dateInstance = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: dateInstance)
    }
}
