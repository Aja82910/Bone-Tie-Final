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
    var reminderDogID: Int
    var name: String?
    var photo: UIImage?
    var launchDate: Date?
    var location: CLLocation?
    var range: CLLocationDistance?
    var reminderID: Int
    var snoozed: Bool
    var notification: UILocalNotification
    
    static let doccumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let archiveURL = doccumentDirectory?.appendingPathComponent("EveryReminder")
    
    // MARK: Initialization
    struct propertyKey {
        static let reminderDogIDKey = "dogName"
        static let nameKey = "Name"
        static let photoKey = "Photo"
        static let launchDateKey = "launchDate"
        static let locationKey = "location"
        static let rangeKey = "range"
        static let reminderIDKey = "reminderID"
        static let snoozedKey = "snoozed"
        static let notificationKey = "notification"
     }
     
    init?(reminderDogID: Int, name: String, photo: UIImage?, launchDate: Date, location: CLLocation?, range: CLLocationDistance?, reminderID: Int, snoozed: Bool, notification: UILocalNotification) {
        // Initialize stored properties.
        self.reminderDogID = reminderDogID
        self.name = name
        self.photo = photo
        self.launchDate = launchDate
        self.location = location
        self.range = range
        self.reminderID = reminderID
        self.snoozed = snoozed
        self.notification = notification
     }
     // Initialization should fail if there is no name or if the rating is negative.
     // return nil
     func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(reminderDogID, forKey: propertyKey.reminderDogIDKey)
        aCoder.encode(name, forKey: propertyKey.nameKey)
        aCoder.encode(photo, forKey: propertyKey.photoKey)
        aCoder.encode(launchDate, forKey: propertyKey.launchDateKey)
        aCoder.encode(location, forKey: propertyKey.locationKey)
        aCoder.encode(range, forKey: propertyKey.rangeKey)
        aCoder.encode(reminderID, forKey: propertyKey.reminderIDKey)
        aCoder.encode(snoozed, forKey: propertyKey.snoozedKey)
        aCoder.encode(notification, forKey: propertyKey.notificationKey)
     }
     required convenience init?(coder aDecoder: NSCoder) {
        let reminderDogID = aDecoder.decodeObject(forKey: propertyKey.reminderDogIDKey) as! Int
        let name = aDecoder.decodeObject(forKey: propertyKey.nameKey) as! String
        let photo = aDecoder.decodeObject(forKey: propertyKey.photoKey) as? UIImage
        let launchDate = aDecoder.decodeObject(forKey: propertyKey.launchDateKey) as! Date
        let location = aDecoder.decodeObject(forKey: propertyKey.locationKey) as! CLLocation
        let range = aDecoder.decodeObject(forKey: propertyKey.rangeKey) as! CLLocationDistance
        let reminderID = aDecoder.decodeObject(forKey: propertyKey.reminderIDKey) as! Int
        let snoozed = aDecoder.decodeObject(forKey: propertyKey.snoozedKey) as! Bool
        let notification = aDecoder.decodeObject(forKey: propertyKey.notificationKey) as! UILocalNotification
        self.init(reminderDogID: reminderDogID, name: name, photo: photo, launchDate: launchDate, location: location, range: range, reminderID: reminderID, snoozed: snoozed, notification: notification)
     }

}
