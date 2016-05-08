//
//  GP.swift
//  Medimate
//
//  Created by Yichuan Huang on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import Foundation

class Facility: NSObject, NSCoding {
    
    var id:Int!
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
    var distance:Double!
    
    var imageURL:String!
    var website:String!
    var bulkBilling:Bool!
    
    var reviews: Array<Review>?
    
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
    
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeInteger(self.id, forKey: "id")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.address, forKey: "address")
        aCoder.encodeObject(self.suburb, forKey: "suburb")
        aCoder.encodeObject(self.phone, forKey: "phone")
        aCoder.encodeObject(self.language, forKey: "language")
        aCoder.encodeObject(self.type, forKey: "type")
        aCoder.encodeDouble(self.latitude, forKey: "latitude")
        aCoder.encodeDouble(self.longitude, forKey: "longitude")
        aCoder.encodeObject(self.openningHourWeek, forKey: "openningHourWeek")
        aCoder.encodeObject(self.openningHourSat, forKey: "openningHourSat")
        aCoder.encodeObject(self.openningHourSun, forKey: "openningHourSun")
        aCoder.encodeDouble(self.rating, forKey: "rating")
        aCoder.encodeDouble(self.distance, forKey: "distance")
        aCoder.encodeInteger(self.numberOfReview, forKey: "numberOfReview")
        aCoder.encodeObject(self.imageURL, forKey: "imageURL")
        aCoder.encodeObject(self.website, forKey: "website")
        aCoder.encodeBool(self.bulkBilling, forKey: "bulkBilling")
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init()
        self.id = aDecoder.decodeIntegerForKey("id")
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.address = aDecoder.decodeObjectForKey("address") as! String
        self.suburb = aDecoder.decodeObjectForKey("suburb") as! String
        self.phone = aDecoder.decodeObjectForKey("phone") as! String
        self.language = aDecoder.decodeObjectForKey("language") as! String
        self.type = aDecoder.decodeObjectForKey("type") as! String
        self.latitude = aDecoder.decodeDoubleForKey("latitude")
        self.longitude = aDecoder.decodeDoubleForKey("longitude")
        self.openningHourWeek = aDecoder.decodeObjectForKey("openningHourWeek") as! String
        self.openningHourSat = aDecoder.decodeObjectForKey("openningHourSat") as! String
        self.openningHourSun = aDecoder.decodeObjectForKey("openningHourSun") as! String
        self.rating = aDecoder.decodeDoubleForKey("rating")
        self.distance = aDecoder.decodeDoubleForKey("distance")
        self.numberOfReview = aDecoder.decodeIntegerForKey("numberOfReview")
        self.imageURL = aDecoder.decodeObjectForKey("imageURL") as! String
        self.website = aDecoder.decodeObjectForKey("website") as! String
        self.bulkBilling = aDecoder.decodeBoolForKey("bulkBilling")
    }
}
