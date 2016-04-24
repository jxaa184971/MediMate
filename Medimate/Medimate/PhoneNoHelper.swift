//
//  PhoneNoHelper.swift
//  Medimate
//
//  Created by Yichuan Huang on 10/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class PhoneNoHelper: NSObject {

    static func phoneNumberFromString(string:String) -> String
    {
        return removeSpecialCharsFromString(string)
    }
    
    static func removeSpecialCharsFromString(text: String) -> String {
        let numberChars : Set<Character> =
            Set("1234567890".characters)
        return String(text.characters.filter {numberChars.contains($0) })
    }
}
