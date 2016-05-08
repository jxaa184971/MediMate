//
//  Review.swift
//  Medimate
//
//  Created by Yichuan Huang on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import Foundation

class Review: NSObject, NSCoding {

    var reviewId:Int!
    var deviceName:String!
    var deviceUID:String!
    var waitingRating:Double!
    var parkingRating:Double!
    var disabilityRating:Double!
    var languageRating:Double!
    var transportRating:Double!
    var date:String!
    var facilityId:Int!
    
    override init() {
        super.init()
    }
    
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeInteger(self.reviewId, forKey: "reviewId")
        aCoder.encodeObject(self.deviceName, forKey: "deviceName")
        aCoder.encodeObject(self.deviceUID, forKey: "deviceUID")

        aCoder.encodeDouble(self.waitingRating, forKey: "waitingRating")
        aCoder.encodeDouble(self.parkingRating, forKey: "parkingRating")
        aCoder.encodeDouble(self.disabilityRating, forKey: "disabilityRating")
        aCoder.encodeDouble(self.languageRating, forKey: "languageRating")
        aCoder.encodeDouble(self.transportRating, forKey: "transportRating")
        
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeInteger(self.facilityId, forKey: "facilityId")
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init()
        self.reviewId = aDecoder.decodeIntegerForKey("reviewId")
        self.deviceUID = aDecoder.decodeObjectForKey("deviceUID") as! String
        self.deviceName = aDecoder.decodeObjectForKey("deviceName") as! String
        
        self.waitingRating = aDecoder.decodeDoubleForKey("waitingRating")
        self.parkingRating = aDecoder.decodeDoubleForKey("parkingRating")
        self.disabilityRating = aDecoder.decodeDoubleForKey("disabilityRating")
        self.languageRating = aDecoder.decodeDoubleForKey("languageRating")
        self.transportRating = aDecoder.decodeDoubleForKey("transportRating")
        
        self.date = aDecoder.decodeObjectForKey("date") as! String
        self.facilityId = aDecoder.decodeIntegerForKey("facilityId")
    }
    
}
