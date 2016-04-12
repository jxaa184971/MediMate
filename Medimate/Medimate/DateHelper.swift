//
//  DateHelper.swift
//  Medimate
//
//  Created by 一川 黄 on 12/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class DateHelper: NSObject {

    static func getCurrentDayName() -> String
    {
        let today = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: today)
        let weekDay = myComponents.weekday
                
        if (weekDay >= 0 && weekDay <= 4)
        {
            return "weekday"
        }
        if (weekDay == 5)
        {
            return "sat"
        }
        if (weekDay == 6)
        {
            return "sun"
        }

        return ""
    }
    
    static func timeFromString(string:String) -> NSDate
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let dateFromString = formatter.dateFromString(string)
        return dateFromString!
    }
    
    static func currentTime() -> NSDate
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let date = NSDate()
        let currentTimeString = formatter.stringFromDate(date)
        let currentTime = formatter.dateFromString(currentTimeString)
        return currentTime!
    }
    
}
