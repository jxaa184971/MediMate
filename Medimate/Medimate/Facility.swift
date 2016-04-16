//
//  GP.swift
//  Medimate
//
//  Created by 一川 黄 on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import Foundation

class Facility: NSObject {
    
    var name:String!
    var address:String!
    var suburb:String!
    var phone:String!
    var language: String!
    var type:String!
    
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
    var bulkBilling:Bool!
    
    override init() {
        super.init()
    }
    
    init(name:String, address:String, phone:String, language:String, type: String,latitude:Double, longitude:Double,rating:Double, numberOfReview: Int, distance:Double, website:String, imageURL:String) {
        self.name = name
        self.address = address
        self.phone = phone
        self.language = language
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.numberOfReview = numberOfReview
        self.distance = distance
        self.website = website
        self.imageURL = imageURL
    }
}
