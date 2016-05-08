//
//  HTTPHelper.swift
//  Medimate
//
//  Created by Yichuan Huang on 31/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import CoreLocation

class HTTPHelper: NSObject {

    static let URL = "http://13.73.117.26:23294/Medimate/webresources/"
    static let FACILITY = "entities.facility/"
    static let REVIEWS = "entities.reviews/"
    
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
    
    static func requestForFacilitiesNearby(curLocation:CLLocation) -> Array<Facility>?
    {
        let url = NSURL(string: "\(HTTPHelper.URL)\(HTTPHelper.FACILITY)facilityWithKM/5/\(curLocation.coordinate.latitude)/\(curLocation.coordinate.longitude)")
        
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
    
    static func requestAllReviews() -> Array<Review>?
    {
        let url = NSURL(string: "\(HTTPHelper.URL)\(HTTPHelper.REVIEWS)")
        
        let request: NSURLRequest = NSURLRequest(URL: url!)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        do
        {
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            let results = HTTPHelper.parseJSONToReviews(data)
            if results != nil
            {
                return results
            }
        }
        catch
        {
            print("Error: There is a error when downloading all reviews")
        }
        return nil
    }
    
    static func requestForReviewsByFacilityID(facilityID: Int) -> Array<Review>?
    {
        let url = NSURL(string: "\(HTTPHelper.URL)\(HTTPHelper.REVIEWS)getReviewsByFacilityID/\(facilityID)")
        
        let request: NSURLRequest = NSURLRequest(URL: url!)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        do
        {
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            let results = HTTPHelper.parseJSONToReviews(data)
            if results != nil
            {
                return results
            }
        }
        catch
        {
            print("Error: There is a error when downloading reviews by facility ID")
        }
        return nil
    }
    
    static func parseJSONToReviews(data:NSData) -> Array<Review>?
    {
        var results = Array<Review>()
        
        do {
            let entries: NSArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSArray
            
            for oneEntry in entries
            {
                let review = Review()
                let reviewEntry = oneEntry as! NSDictionary
                review.reviewId = reviewEntry.valueForKey("reviewId") as! Int
                review.deviceName = reviewEntry.valueForKey("deviceName") as! String
                review.deviceUID = reviewEntry.valueForKey("deviceUid") as! String
                review.waitingRating = reviewEntry.valueForKey("waitingTime") as! Double
                review.parkingRating = reviewEntry.valueForKey("parking") as! Double
                review.disabilityRating = reviewEntry.valueForKey("disability") as! Double
                review.languageRating = reviewEntry.valueForKey("language") as! Double
                review.transportRating = reviewEntry.valueForKey("transport") as! Double
                review.date = reviewEntry.valueForKey("date") as! String
                review.facilityId = reviewEntry.valueForKey("facilityId") as! Int
                
                results.append(review)
            }
            
            return results
        }
        catch
        {
            print("error serializing JSON: \(error)")
            return nil
        }

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
                facility.id = facilityEntry.valueForKey("facilityId") as! Int
                facility.name = facilityEntry.valueForKey("name") as! String
                facility.address = facilityEntry.valueForKey("address") as! String
                let suburbString = facilityEntry.valueForKey("suburb") as! String
                let postCodeString = facilityEntry.valueForKey("postcode") as! String
                facility.suburb = "\(suburbString) \(postCodeString)"
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
                
                let bulkBillingString = facilityEntry.valueForKey("bulkBilling") as! String
                if bulkBillingString == "Y"
                {
                    facility.bulkBilling = true
                }
                else
                {
                    facility.bulkBilling = false
                }
                facility.rating = 0
                facility.numberOfReview = 0
                facility.reviews = Array<Review>()
                
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
    
    static func isConnectedToNetwork() -> Bool {
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        do
        {
            var data =  try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }
        }
        catch
        {
            Status = false
        }
        
        return Status
    }

}
