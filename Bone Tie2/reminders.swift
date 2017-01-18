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
    var reminderDogId: Int?
    var name: String?
    var photo: UIImage?
    var repeatType: String?
    var repeatTime: Int?
    var created: Date
    var firstLaunchTime: Date
    var location: CLLocation?
    var range: CLLocationDistance?
    var type: String
    var stillRepeating: Bool
    var notification: UILocalNotification
    var id: Int
    static let doccumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let archiveURL = doccumentDirectory?.appendingPathComponent("Reminders")
    
    struct propertyKey {
        static let reminderDogIdKey = "DogName"
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
     
    init?(reminderDogId: Int?, name: String?, photo: UIImage?, repeatType: String?, repeatTime: Int?, created: Date, firstLaunchTime: Date, location: CLLocation?, range: CLLocationDistance?, type: String, stillRepeating: Bool, notification: UILocalNotification, id: Int) {
        // Initialize stored properties.
        self.reminderDogId = reminderDogId
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
     func encode(with aCoder: NSCoder) {
        aCoder.encode(reminderDogId, forKey: propertyKey.reminderDogIdKey)
        aCoder.encode(name, forKey: propertyKey.nameKey)
        aCoder.encode(photo, forKey: propertyKey.photoKey)
        aCoder.encode(repeatType, forKey: propertyKey.repeatTypeKey)
        aCoder.encode(repeatTime, forKey: propertyKey.repeatTimeKey)
        aCoder.encode(created, forKey: propertyKey.createdKey)
        aCoder.encode(firstLaunchTime, forKey: propertyKey.firstLaunchTimeKey)
        aCoder.encode(location, forKey: propertyKey.locationKey)
        aCoder.encode(range, forKey: propertyKey.rangeKey)
        aCoder.encode(type, forKey: propertyKey.typeKey)
        aCoder.encode(stillRepeating, forKey: propertyKey.stillRepeatingKey)
        aCoder.encode(notification, forKey: propertyKey.notificationKey)
        aCoder.encode(id, forKey: propertyKey.idKey)
     }
     required convenience init?(coder aDecoder: NSCoder) {
        let reminderDogId = aDecoder.decodeObject(forKey: propertyKey.reminderDogIdKey) as! Int
        let name = aDecoder.decodeObject(forKey: propertyKey.nameKey) as! String?
        let photo = aDecoder.decodeObject(forKey: propertyKey.photoKey) as? UIImage?
        let repeatType = aDecoder.decodeObject(forKey: propertyKey.repeatTypeKey) as! String?
        let repeatTime = aDecoder.decodeObject(forKey: propertyKey.repeatTimeKey) as! Int?
        let created = aDecoder.decodeObject(forKey: propertyKey.createdKey) as! Date
        let firstLaunchTime = aDecoder.decodeObject(forKey: propertyKey.firstLaunchTimeKey) as! Date
        let location = aDecoder.decodeObject(forKey: propertyKey.locationKey) as! CLLocation?
        let range = aDecoder.decodeObject(forKey: propertyKey.rangeKey) as! CLLocationDistance?
        let type = aDecoder.decodeObject(forKey: propertyKey.typeKey) as! String
        let stillRepeating = aDecoder.decodeObject(forKey: propertyKey.stillRepeatingKey) as! Bool
        let notification = aDecoder.decodeObject(forKey: propertyKey.notificationKey) as! UILocalNotification
        let id = aDecoder.decodeObject(forKey: propertyKey.idKey) as! Int
        self.init(reminderDogId: reminderDogId, name: name, photo: photo!, repeatType: repeatType, repeatTime: repeatTime, created: created, firstLaunchTime: firstLaunchTime, location: location, range: range, type: type, stillRepeating: stillRepeating, notification: notification, id: id)
     }
}
