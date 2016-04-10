//
//  SuburbHelper.swift
//  Medimate
//
//  Created by 一川 黄 on 2/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import CoreLocation

class SuburbHelper: NSObject {
    
    static let suburbArray = [NSLocalizedString("Current Location", comment:""), "Melbourne", "East Melbourne", "West Melbourne",  "Southbank", "Kensington", "Flemington", "North Melbourne", "Parkville", "Carlton", "Carlton North", "South Yarra", "Caulfield East", "Marvern East", "Caulfield North", "Caulfield", "Caulfield South", "Carnegie", "Glen Huntly", "Bentleigh East", "St Kilda East", "Elsternwik", "Ripponlea", "Bentleigh", "Ormond", "Mckinnon", "Port Melbourne"]
    
    static let postCodeArray = ["", "3000", "3002", "3003", "3006", "3031", "3031", "3051", "3052", "3053", "3054", "3141", "3145", "3145", "3161", "3162", "3162", "3163", "3163", "3165", "3183", "3185", "3185", "3204", "3204", "3204", "3207"]
    
    static let latitudeArray = [0, -37.814161, -37.813764, -37.808559, -37.825877, -37.794147, -37.785881, -37.798194, -37.786166, -37.800792, -37.78625, -37.838829, -37.881764, -37.874383, -37.872241, -37.884063, -37.895907, -37.89404, -37.892613, -37.922407, -37.866433, -37.88503, -37.877654, -37.918100, -37.903188, -37.911002, -37.834858]
    
    static let longitudeArray = [0, 144.963204, 144.983065, 144.945587, 144.960094, 144.927562, 144.919564, 144.946228, 144.949676, 144.967068, 144.973629, 144.991559, 145.04407, 145.059829, 145.021077, 145.026272, 145.027218, 145.056244, 145.041446, 145.067894, 145.000117, 145.006261, 144.995683, 145.037102, 145.039939, 145.03781, 144.92509]
    
    static func locationFromSuburb(suburbString:String) -> CLLocation
    {
        var index = 0
        for suburb in suburbArray
        {
            if suburb == suburbString
            {
                index = suburbArray.indexOf(suburb)!
            }
        }
        return CLLocation(latitude: latitudeArray[index], longitude: longitudeArray[index])
    }
    
    static func stringFromSuburbAndPostCode() -> Array<String>
    {
        var results = Array<String>()
        results.append(NSLocalizedString("Current Location", comment:""))
        //results.append("All")
        for index in 1...(suburbArray.count - 1)
        {
            results.append("\(self.suburbArray[index]) \(self.postCodeArray[index])")
        }
        return results
    }
}
