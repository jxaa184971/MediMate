//
//  GP.swift
//  Medimate
//
//  Created by 一川 黄 on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import Foundation

class GP: NSObject {
    
    var name:String!
    var address:String!
    var phone:String!
    var language: String!
    var breif:String?
    
    var latitude:Double!
    var longitude:Double!
    
    var openningHourWeek:String!
    var openningHourSat:String!
    var openningHourSun:String!
    
    var rating:Double!
    var numberOfReview:Int!
    var reviews:Array<Review>?
    var distance:Double!
    
    var imageURL:String!
    var website:String!
 
    init(name:String) {
        self.name = name
        self.address = "900 Dandenong Rd, Caulfield East VIC 3145"
        self.phone = "(03) 9903 2000"
        self.breif = "Kevin Bob is a fully accredited General Proctioner with AGPAL who has excellent medical service."
        self.latitude = -37.876356
        self.longitude = 145.044417
        
        self.openningHourWeek = "8:30am ~ 9:00pm"
        self.openningHourSat = "9:00 ~ 6:00pm"
        self.openningHourSun = "Closed"
        
        self.rating = 3.5
        self.numberOfReview = 7
        self.reviews = Array()
        self.distance = 1.8
        
        self.website = "russellbensky.wordpress.com"
        self.imageURL = "http://gloucestershire.respectyourself.info/wp-content/uploads/2012/07/Brunswick-clinic-Room.jpg"
    }
    
    init(name:String, address:String, phone:String, language:String, rating:Double, numberOfReview: Int, distance:Double, website:String, imageURL:String) {
        self.name = name
        self.address = address
        self.phone = phone
        self.language = language
        self.rating = rating
        self.numberOfReview = numberOfReview
        self.distance = distance
        self.website = website
        self.imageURL = imageURL
    }
}
