//
//  NSDate.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/3/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

extension NSDate {
    public class func ISOStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.stringFromDate(date).stringByAppendingString("Z")
    }
    
    public class func dateFromISOString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.dateFromString(string)!
    }

    func yearsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        var offsetNumber = 0
        var offsetType = "second"
        
        if secondsFrom(date) >= 0 { offsetNumber = secondsFrom(date); offsetType = "second" }
        if minutesFrom(date) > 0 { offsetNumber = minutesFrom(date); offsetType = "minute" }
        if hoursFrom(date)   > 0 { offsetNumber = hoursFrom(date); offsetType = "hour" }
        if daysFrom(date)    > 0 { offsetNumber = daysFrom(date); offsetType = "day" }
        if weeksFrom(date)   > 0 { offsetNumber = weeksFrom(date); offsetType = "week" }
        if monthsFrom(date)  > 0 { offsetNumber = monthsFrom(date); offsetType = "month" }
        if yearsFrom(date)   > 0 { offsetNumber = yearsFrom(date); offsetType = "year" }
        
        let offsetIncrement = offsetNumber == 1 ? offsetType : "\(offsetType)s"

        return "\(offsetNumber) \(offsetIncrement) ago"
    }
}
