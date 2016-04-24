//
//  LanguageHelper.swift
//  Medimate
//
//  Created by Yichuan Huang on 1/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class LanguageHelper: NSObject {
    
    static let englishArray = ["English", "Spanish", "German", "Italian", "Russian", "French", "Greek", "Mandarin", "Cantonese", "Japanese", "Polish", "Arabic", "Indonesian", "Vietnamese", "Zulu", "Hindi", "Serbian", "Hebrew", "Bosnian", "Sinhalese", "Yiddish", "Croatian", "Malay"]
    
    static let otherLanguageArray = ["English", "Español", "Deutsch", "italiano", "русский", "français", "ελληνικά", "普通话", "广东话", "日本語", "Polskie", "العربية", "Indonesian", "Tiếng Việt", "Zulu", "हिंदी", "Српски", "עִברִית", "bosanski", "සිංහල", "ייִדיש", "hrvatski", "Malay"]
    
    static func englishFromOtherLanguage(otherLanguage: String) -> String
    {
        var index: Int?
        for language in otherLanguageArray
        {
            if language == otherLanguage
            {
                index = otherLanguageArray.indexOf(language)
            }
        }
        return englishArray[index!]
    }
    
    static func otherLanguageFromEnglish(englishLanguage: String) -> String
    {
        var index: Int?
        for language in englishArray
        {
            if language == englishLanguage
            {
                index = englishArray.indexOf(language)
            }
        }
        return otherLanguageArray[index!]
    }
    
}
