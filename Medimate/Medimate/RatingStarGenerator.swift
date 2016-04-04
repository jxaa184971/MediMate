//
//  RatingStarGenerator.swift
//  Medimate
//
//  Created by 一川 黄 on 20/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class RatingStarGenerator: NSObject {

    static func ratingStarsFromDouble(double: Double) -> String
    {
        var starts = ""
        var number = double
        while number > 1
        {
            starts += "★"
            number--
        }
        
        if number > 0 && number < 1
        {
            starts += "✩"
        }
        
        while starts.characters.count < 5
        {
            starts += "✩"
        }
        
        return starts
    }
}
