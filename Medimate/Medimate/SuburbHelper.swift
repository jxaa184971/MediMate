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
    
    static let suburbArray = [NSLocalizedString("Current Location", comment:""), "Melbourne 3000", "East Melbourne 3002", "West Melbourne 3003", "Melbourne 3004",  "Southbank 3006", "Kensington 3031", "Flemington 3031", "North Melbourne 3051", "Parkville 3052", "Carlton 3053", "Carlton North 3054", "South Yarra 3141", "Caulfield East 3145", "Marvern East 3145", "Caulfield North 3161", "Caulfield 3162", "Caulfield South 3162", "Carnegie 3163", "Glen Huntly 3163", "Bentleigh East 3165", "St Kilda East 3183", "Elsternwik 3185", "Ripponlea 3185", "Bentleigh 3204", "Ormond 3204", "Mckinnon 3204", "Port Melbourne 3207"]
    
    static let latitudeArray = [0, -37.814161, -37.813764, -37.808559, -37.836427, -37.825877, -37.794147, -37.785881, -37.798194, -37.786166, -37.800792, -37.78625, -37.838829, -37.881764, -37.874383, -37.872241, -37.884063, -37.895907, -37.89404, -37.892613, -37.922407, -37.866433, -37.88503, -37.877654, -37.918100, -37.903188, -37.911002, -37.839264]
    
    static let longitudeArray = [0, 144.963204, 144.983065, 144.945587, 144.975219, 144.960094, 144.927562, 144.919564, 144.946228, 144.949676, 144.967068, 144.973629, 144.991559, 145.04407, 145.059829, 145.021077, 145.026272, 145.027218, 145.056244, 145.041446, 145.067894, 145.000117, 145.006261, 144.995683, 145.037102, 145.039939, 145.03781, 144.941805]
    
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

}
