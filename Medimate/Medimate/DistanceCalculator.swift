//
//  DistanceCalculator.swift
//  Medimate
//
//  Created by Yichuan Huang on 1/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import CoreLocation

class DistanceCalculator: NSObject {

    static func distanceBetween(curLocation:CLLocation, facilityArray: Array<Facility>)
    {
        for facility in facilityArray
        {
            let latitude = facility.latitude
            let longitude = facility.longitude
            let facilityLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            let distance = curLocation.distanceFromLocation(facilityLocation) / 1000
            facility.distance = distance
        }
    }
    
    
    static func distanceBetween(curLocation:CLLocation, facility: Facility)
    {
        let latitude = facility.latitude
        let longitude = facility.longitude
        let facilityLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        let distance = curLocation.distanceFromLocation(facilityLocation) / 1000
        facility.distance = distance
    }
    
    static func averageRating(reviews: Array<Review>) -> Double
    {
        var sum:Double = 0
        
        for review in reviews
        {
            sum += review.waitingRating
            sum += review.parkingRating
            sum += review.disabilityRating
            sum += review.languageRating
            sum += review.transportRating
        }
        
        return sum / (Double(reviews.count) * 5.0)
    }
}
