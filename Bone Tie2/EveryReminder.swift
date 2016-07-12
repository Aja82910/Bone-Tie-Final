//
//  EveryReminder.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 7/6/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit

class EveryReminder: NSObject {
    var reminderDogID: Int?
    var name: String?
    var photo: UIImage?
    var launchDate: NSDate?
    var location: CLLocation?
    var range: CLLocationDistance?
    var reminderID: Int?
    
    static let doccumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    static let archiveURL = doccumentDirectory?.URLByAppendingPathComponent("EveryReminder")
    
    // MARK: Initialization
    struct propertyKey {
        static let reminderDogIDKey = "dogName"
        static let nameKey = "Name"
        static let photoKey = "Photo"
        static let launchDateKey = "launchDate"
        static let locationKey = "location"
        static let rangeKey = "range"
        static let reminderIDKey = "reminderID"
     }
     
    init?(reminderDogID: Int?, name: String, photo: UIImage?, launchDate: NSDate, location: CLLocation, range: CLLocationDistance, reminderID: Int?) {
        // Initialize stored properties.
        self.reminderDogID = reminderDogID
        self.name = name
        self.photo = photo
        self.launchDate = launchDate
        self.location = location
        self.range = range
        self.reminderID = reminderID
     }
     // Initialization should fail if there is no name or if the rating is negative.
     // return nil
     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(reminderDogID, forKey: propertyKey.reminderDogIDKey)
        aCoder.encodeObject(name, forKey: propertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: propertyKey.photoKey)
        aCoder.encodeObject(launchDate, forKey: propertyKey.launchDateKey)
        aCoder.encodeObject(location, forKey: propertyKey.locationKey)
        aCoder.encodeObject(range, forKey: propertyKey.rangeKey)
        aCoder.encodeObject(reminderID, forKey: propertyKey.reminderIDKey)
     }
     required convenience init?(coder aDecoder: NSCoder) {
        let reminderDogID = aDecoder.decodeObjectForKey(propertyKey.reminderDogIDKey) as! Int
        let name = aDecoder.decodeObjectForKey(propertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage
        let launchDate = aDecoder.decodeObjectForKey(propertyKey.launchDateKey) as! NSDate
        let location = aDecoder.decodeObjectForKey(propertyKey.locationKey) as! CLLocation
        let range = aDecoder.decodeObjectForKey(propertyKey.rangeKey) as! CLLocationDistance
        let reminderID = aDecoder.decodeObjectForKey(propertyKey.reminderIDKey) as! Int
        self.init(reminderDogID: reminderDogID, name: name, photo: photo, launchDate: launchDate, location: location, range: range, reminderID: reminderID)
     }

}
