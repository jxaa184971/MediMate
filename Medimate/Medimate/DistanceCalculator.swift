//
//  DistanceCalculator.swift
//  Medimate
//
//  Created by 一川 黄 on 1/04/2016.
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
    
    
    
    
}
