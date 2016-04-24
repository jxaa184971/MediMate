//
//  DateHelper.swift
//  Medimate
//
//  Created by Yichuan Huang on 12/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class DateHelper: NSObject {

    static func getCurrentDayName() -> String
    {
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.dateFormat = "E"

        let weekDay = formatter.stringFromDate(today)
        if weekDay == "Sat"
        {
            return "sat"
        }
        if weekDay == "Sun"
        {
            return "sun"
        }
        return "weekday"
    }
    
    static func timeFromString(string:String) -> NSDate
    {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "h:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let dateFromString = formatter.dateFromString(string)
        return dateFromString!
    }
    
    static func currentTime() -> NSDate
    {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "h:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let date = NSDate()
        let currentTimeString = formatter.stringFromDate(date)
        let currentTime = formatter.dateFromString(currentTimeString)
        return currentTime!
    }
    
    static func facilityNowOpen(facility: Facility) -> Bool
    {
        
        let currentTime = DateHelper.currentTime()
        
        var openingHour = ""
        let dayName = DateHelper.getCurrentDayName()
        if dayName == "weekday"
        {
            openingHour = facility.openningHourWeek
        }
        if dayName == "sat"
        {
            openingHour = facility.openningHourSat
        }
        if dayName == "sun"
        {
            openingHour = facility.openningHourSun
        }
        
        if openingHour == ""
        {
            return false
        }
        
        if openingHour == "Closed"
        {
            return false
        }
        
        
        let openingHourArray = openingHour.characters.split{$0 == "-"}.map(String.init)
        if openingHourArray.count > 1
        {
            let startTimeString = openingHourArray[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

            let endTimeString = openingHourArray[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            let startTime = DateHelper.timeFromString(startTimeString)
            let endTime = DateHelper.timeFromString(endTimeString)
            
            if (currentTime.timeIntervalSinceNow >= startTime.timeIntervalSinceNow) &&
                (currentTime.timeIntervalSinceNow <= endTime.timeIntervalSinceNow)
            {
                return true
            }
        }
        return false
    }
    
}
