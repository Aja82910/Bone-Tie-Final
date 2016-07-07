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
    var reminderDog: dog?
    var name: String?
    var photo: UIImage?
    var launchDate: NSDate?
    var location: CLLocation?
    var range: CLLocationDistance?
    
    // MARK: Initialization
    struct propertyKey {
     static let reminderDogKey = "dogName"
     static let nameKey = "Name"
     static let photoKey = "Photo"
     static let launchDateKey = "launchDate"
     static let locationKey = "location"
     static let rangeKey = "range"
     }
     
    init?(reminderDog: dog?, name: String, photo: UIImage?, launchDate: NSDate, location: CLLocation, range: CLLocationDistance) {
        // Initialize stored properties.
        self.reminderDog = reminderDog
        self.name = name
        self.photo = photo
        self.launchDate = launchDate
        self.location = location
        self.range = range
     }
     // Initialization should fail if there is no name or if the rating is negative.
     // return nil
     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(reminderDog, forKey: propertyKey.reminderDogKey)
        aCoder.encodeObject(name, forKey: propertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: propertyKey.photoKey)
        aCoder.encodeObject(launchDate, forKey: propertyKey.launchDateKey)
        aCoder.encodeObject(location, forKey: propertyKey.locationKey)
        aCoder.encodeObject(range, forKey: propertyKey.rangeKey)
     }
     required convenience init?(coder aDecoder: NSCoder) {
        let reminderDog = aDecoder.decodeObjectForKey(propertyKey.reminderDogKey) as! dog
        let name = aDecoder.decodeObjectForKey(propertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage
        let launchDate = aDecoder.decodeObjectForKey(propertyKey.launchDateKey) as! NSDate
        let location = aDecoder.decodeObjectForKey(propertyKey.locationKey) as! CLLocation
        let range = aDecoder.decodeObjectForKey(propertyKey.rangeKey) as! CLLocationDistance
        self.init(reminderDog: reminderDog, name: name, photo: photo, launchDate: launchDate, location: location, range: range)
     }

}
