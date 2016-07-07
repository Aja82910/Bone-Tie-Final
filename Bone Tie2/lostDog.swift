//
//  lostDog.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/16/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class lostDog: NSObject {
    var name: String?
    var photo: UIImage?
    var lastUpdated: NSDate?
    var created: NSDate?
    var location: CLLocation?
    var breed: String?
    var user: CKRecordID?
    var home: CLLocation?
    var lostDate: NSDate?
    
    // MARK: Initialization
    /*struct propertyKey {
        static let nameKey = "Name"
        static let photoKey = "Photo"
        static let lastUpdatedKey = "lastUpdated"
        static let breedKey = "Breed"
        static let locationKey = "location"
        static let userKey = "user"
        static let createdKey = "created"
        static let lostDateKey = "lostDate"
    }
    
    init?(name: String, photo: UIImage?, lastUpdated: NSDate, breed: String, location: CLLocation, user: CKRecordID, created: NSDate, lostDate: NSDate) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.lastUpdated = lastUpdated
        self.breed = breed
        self.location = location
        self.user = user
        self.created = created
        self.lostDate = lostDate
    }
    // Initialization should fail if there is no name or if the rating is negative.
    // return nil
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: propertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: propertyKey.photoKey)
        aCoder.encodeObject(breed, forKey: propertyKey.breedKey)
        aCoder.encodeObject(lastUpdated, forKey: propertyKey.lastUpdatedKey)
        aCoder.encodeObject(location, forKey: propertyKey.locationKey)
        aCoder.encodeObject(user, forKey: propertyKey.userKey)
        aCoder.encodeObject(created, forKey: propertyKey.createdKey)
        aCoder.encodeObject(lostDate, forKey: propertyKey.lostDateKey)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(propertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage
        let lastUpdated = aDecoder.decodeObjectForKey(propertyKey.lastUpdatedKey) as! NSDate
        let breed = aDecoder.decodeObjectForKey(propertyKey.breedKey) as! String
        let location = aDecoder.decodeObjectForKey(propertyKey.locationKey) as! CLLocation
        let user = aDecoder.decodeObjectForKey(propertyKey.userKey) as! CKRecordID
        let created = aDecoder.decodeObjectForKey(propertyKey.createdKey) as! NSDate
        let lostDate = aDecoder.decodeObjectForKey(propertyKey.lostDateKey) as! NSDate
        self.init(name: name, photo: photo, lastUpdated: lastUpdated, breed: breed, location: location, user: user, created: created, lostDate: lostDate)
    }*/

}
