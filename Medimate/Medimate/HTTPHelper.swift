//
//  HTTPHelper.swift
//  Medimate
//
//  Created by 一川 黄 on 31/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class HTTPHelper: NSObject {

    static let URL = "http://13.73.117.26:23294/Medimate/webresources/"
    static let FACILITY = "entities.facility/"
    
    static func requestForFacilitiesByType(type: String) -> Array<Facility>?
    {
        let url = NSURL(string: "\(HTTPHelper.URL)\(HTTPHelper.FACILITY)findByType/\(type)")
        
        let request1: NSURLRequest = NSURLRequest(URL: url!)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        do
        {
            let data: NSData =  try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            let results = HTTPHelper.parseJSONToFacilities(data)
            if results != nil
            {
                return results
            }
        }
        catch
        {
            print("Error: There might have Internet Issues")
        }
        return nil
    }
    
    static func parseJSONToFacilities(data:NSData) -> Array<Facility>?
    {
        var results = Array<Facility>()
        
        do {
            let entries: NSArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSArray
            
            for oneEntry in entries
            {
                let facility = Facility()
                let facilityEntry = oneEntry as! NSDictionary
                facility.name = facilityEntry.valueForKey("name") as! String
                facility.address = facilityEntry.valueForKey("address") as! String
                facility.suburb = facilityEntry.valueForKey("suburb") as! String
                facility.phone = facilityEntry.valueForKey("phone") as! String
                facility.language = facilityEntry.valueForKey("language") as! String
                facility.type = facilityEntry.valueForKey("type") as! String
                facility.latitude = (facilityEntry.valueForKey("latitude") as! NSString).doubleValue
                facility.longitude = (facilityEntry.valueForKey("longitude") as! NSString).doubleValue
                facility.openningHourWeek = facilityEntry.valueForKey("openningHourWeek") as! String
                facility.openningHourSat = facilityEntry.valueForKey("openningHourSat") as! String
                facility.openningHourSun = facilityEntry.valueForKey("openningHourSun") as! String
                facility.website = facilityEntry.valueForKey("website") as! String
                facility.imageURL = facilityEntry.valueForKey("imageurl") as! String
                
                facility.rating = 3.5
                facility.numberOfReview = 20
                facility.distance = 1.7
                
                results.append(facility)
            }
            
            return results
        }
        catch
        {
            print("error serializing JSON: \(error)")
            return nil
        }
    }
}