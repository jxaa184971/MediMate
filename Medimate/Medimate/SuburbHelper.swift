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
    
    static let suburbArray = [NSLocalizedString("Current Location (Within 5km)", comment:""), NSLocalizedString("Current Location (Within 10km)", comment:""), "Bentleigh 3204",  "Bentleigh East 3165",  "Carlton 3053",  "Carlton North 3054",  "Carnegie 3163",  "Caulfield 3162",  "Caulfield East 3145",  "Caulfield North 3161",  "Caulfield South 3162",  "East Melbourne 3002",  "Elsternwick 3185",  "Flemington 3031",  "Glen Huntly 3163",  "Kensington 3031",  "Malvern East 3145",  "Mckinnon 3204",  "Melbourne 3000",  "Melbourne 3004",   "North Melbourne 3051",  "Ormond 3204",  "Parkville 3052",  "Port Melbourne 3207", "Ripponlea 3185",  "South Yarra 3141",  "Southbank 3006",  "St Kilda East 3183",  "West Melbourne 3003"]
    
    static let latitudeArray = [0, 0, -37.918100, -37.922407,  -37.800792,  -37.78625,  -37.89404,  -37.884063,  -37.881764,  -37.872241,  -37.895907,  -37.813764,  -37.88503,  -37.785881,  -37.892613, -37.794147,  -37.874383,  -37.911002,  -37.814161,  -37.836427,  -37.798194,  -37.903188,  -37.786166, -37.839264, -37.877654,  -37.838829,  -37.825877,  -37.866433,  -37.808559]
    
    static let longitudeArray = [0, 0, 145.037102, 145.067894, 144.967068, 144.973629, 145.056244, 145.026272, 145.04407, 145.021077, 145.027218, 144.983065, 145.006261, 144.919564, 145.041446, 144.927562, 145.059829, 145.03781, 144.963204, 144.975219, 144.946228, 145.039939, 144.949676, 144.941805,144.995683, 144.991559, 144.960094, 145.000117, 144.945587]
    
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
