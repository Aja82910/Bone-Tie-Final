//
//  Dog.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 12/6/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import UIKit
class dog: NSObject, NSCoding {
    var name: String
    var photo: UIImage?
    var date: Date
    var trackerNumber: String
    var breed: String
    var city: String
    var color: String
    var sound: String
    var id: Int
    static let doccumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let archiveURL = doccumentDirectory?.appendingPathComponent("Dogs")
    
    // MARK: Initialization
    struct propertyKey {
        static let nameKey = "Name"
        static let photoKey = "Photo"
        static let dateKey = "Date"
        static let breedKey = "Breed"
        static let trackerNumberKey = "trackerNumber"
        static let cityKey = "city"
        static let colorKey = "color"
        static let soundKey = "sound"
        static let idKey = "id"
    }
    
    init?(name: String, photo: UIImage?, date: Date, breed: String, trackerNumber: String, city: String, color: String, sound: String, id: Int) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.date = date
        self.breed = breed
        self.trackerNumber = trackerNumber
        self.city = city
        self.color = color
        self.sound = sound
        self.id = id
    }
    // Initialization should fail if there is no name or if the rating is negative.
    // return nil
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: propertyKey.nameKey)
        aCoder.encode(photo, forKey: propertyKey.photoKey)
        aCoder.encode(breed, forKey: propertyKey.breedKey)
        aCoder.encode(date, forKey: propertyKey.dateKey)
        aCoder.encode(trackerNumber, forKey: propertyKey.trackerNumberKey)
        aCoder.encode(city, forKey: propertyKey.cityKey)
        aCoder.encode(date, forKey: propertyKey.dateKey)
        aCoder.encode(color, forKey:  propertyKey.colorKey)
        aCoder.encode(sound, forKey:  propertyKey.soundKey)
        aCoder.encode(id, forKey:  propertyKey.idKey) // RAM to Hardrive
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: propertyKey.nameKey) as! String // Hardrive to RAM
        let photo = aDecoder.decodeObject(forKey: propertyKey.photoKey) as? UIImage
        let date = aDecoder.decodeObject(forKey: propertyKey.dateKey) as! Date
        let breed = aDecoder.decodeObject(forKey: propertyKey.breedKey) as! String
        let trackerNumber = aDecoder.decodeObject(forKey: propertyKey.trackerNumberKey) as! String
        let city = aDecoder.decodeObject(forKey: propertyKey.cityKey) as! String
        let color = aDecoder.decodeObject(forKey: propertyKey.colorKey) as! String
        let sound = aDecoder.decodeObject(forKey: propertyKey.soundKey) as! String //If nil it is the default sound
        let id = aDecoder.decodeObject(forKey: propertyKey.idKey) as! Int
        self.init(name: name, photo: photo, date: date, breed: breed, trackerNumber: trackerNumber, city: city, color: color, sound: sound, id: id)
    }
}
