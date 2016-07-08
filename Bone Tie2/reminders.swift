//
//  reminders.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 7/6/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit

class reminders: NSObject, NSCoding {
    var reminderDog: dog?
    var name: String?
    var photo: UIImage?
    var repeatType: String?
    var repeatTime: Int?
    var created: NSDate
    var firstLaunchTime: NSDate
    var location: CLLocation?
    var range: CLLocationDistance?
    var type: String
    var stillRepeating: Bool
    var notification: UILocalNotification
    var id: Int
    static let doccumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    static let archiveURL = doccumentDirectory?.URLByAppendingPathComponent("Reminders")
    
    struct propertyKey {
        static let reminderDogKey = "DogName"
        static let nameKey = "Name"
        static let photoKey = "Photo"
        static let repeatTypeKey = "repeatType"
        static let repeatTimeKey = "repeatTime"
        static let createdKey = "created"
        static let firstLaunchTimeKey = "firstLaunchTime"
        static let locationKey = "location"
        static let rangeKey = "renge"
        static let typeKey = "type"
        static let stillRepeatingKey = "stillRepeating"
        static let notificationKey = "notification"
        static let idKey = "id"
     }
     
    init?(reminderDog: dog?, name: String?, photo: UIImage?, repeatType: String?, repeatTime: Int?, created: NSDate, firstLaunchTime: NSDate, location: CLLocation?, range: CLLocationDistance?, type: String, stillRepeating: Bool, notification: UILocalNotification, id: Int) {
        // Initialize stored properties.
        self.reminderDog = reminderDog
        self.name = name
        self.photo = photo
        self.repeatType = repeatType
        self.repeatTime = repeatTime
        self.created = created
        self.firstLaunchTime = firstLaunchTime
        self.location = location
        self.range = range
        self.type = type
        self.stillRepeating = stillRepeating
        self.notification = notification
        self.id = id
     }
     // Initialization should fail if there is no name or if the rating is negative.
     // return nil
     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(reminderDog, forKey: propertyKey.reminderDogKey)
        aCoder.encodeObject(name, forKey: propertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: propertyKey.photoKey)
        aCoder.encodeObject(repeatType, forKey: propertyKey.repeatTypeKey)
        aCoder.encodeObject(repeatTime, forKey: propertyKey.repeatTimeKey)
        aCoder.encodeObject(created, forKey: propertyKey.createdKey)
        aCoder.encodeObject(firstLaunchTime, forKey: propertyKey.firstLaunchTimeKey)
        aCoder.encodeObject(location, forKey: propertyKey.locationKey)
        aCoder.encodeObject(range, forKey: propertyKey.rangeKey)
        aCoder.encodeObject(type, forKey: propertyKey.typeKey)
        aCoder.encodeObject(stillRepeating, forKey: propertyKey.stillRepeatingKey)
        aCoder.encodeObject(notification, forKey: propertyKey.notificationKey)
        aCoder.encodeObject(id, forKey: propertyKey.idKey)
     }
     required convenience init?(coder aDecoder: NSCoder) {
        let reminderDog = aDecoder.decodeObjectForKey(propertyKey.reminderDogKey) as! dog
        let name = aDecoder.decodeObjectForKey(propertyKey.nameKey) as! String?
        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage?
        let repeatType = aDecoder.decodeObjectForKey(propertyKey.repeatTypeKey) as! String?
        let repeatTime = aDecoder.decodeObjectForKey(propertyKey.repeatTimeKey) as! Int?
        let created = aDecoder.decodeObjectForKey(propertyKey.createdKey) as! NSDate
        let firstLaunchTime = aDecoder.decodeObjectForKey(propertyKey.firstLaunchTimeKey) as! NSDate
        let location = aDecoder.decodeObjectForKey(propertyKey.locationKey) as! CLLocation?
        let range = aDecoder.decodeObjectForKey(propertyKey.rangeKey) as! CLLocationDistance?
        let type = aDecoder.decodeObjectForKey(propertyKey.typeKey) as! String
        let stillRepeating = aDecoder.decodeObjectForKey(propertyKey.stillRepeatingKey) as! Bool
        let notification = aDecoder.decodeObjectForKey(propertyKey.notificationKey) as! UILocalNotification
        let id = aDecoder.decodeObjectForKey(propertyKey.idKey) as! Int
        self.init(reminderDog: reminderDog, name: name, photo: photo!, repeatType: repeatType, repeatTime: repeatTime, created: created, firstLaunchTime: firstLaunchTime, location: location, range: range, type: type, stillRepeating: stillRepeating, notification: notification, id: id)
     }
}