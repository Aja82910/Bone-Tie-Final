//
//  FetchLost.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/16/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import CloudKit

var LostDogs = [lostDog]()

class FetchLost: NSObject {
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    func loadAll(viewcontroller: UIViewController) -> ([lostDog]?, NSError?) {
        var Error: NSError? = nil
        var newLostDogs = [lostDog]()
        let predicate = NSPredicate(value: true)//NSPredicate(format: "Found != %@", "Yes")
        let query  = CKQuery(recordType: "Lost", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Breed", "Photo", "Location", "Home", "LostDate"]
        operation.recordFetchedBlock = { (record) in
            let LostDog = lostDog()
            LostDog.lastUpdated = record.modificationDate
            LostDog.created = record.creationDate
            LostDog.user = record.creatorUserRecordID
            LostDog.name = record["Name"] as? String
            LostDog.location = record["Location"] as? CLLocation
            LostDog.breed = record["Breed"] as? String
            let photo = record["Photo"] as! CKAsset
            LostDog.photo = UIImage(data: NSData(contentsOfURL: photo.fileURL)!)
            LostDog.home = record["Home"] as? CLLocation
            LostDog.lostDate = record["LostDate"] as? NSDate
            print(LostDog.photo)
            print(record["Photo"] as? UIImage)
            newLostDogs.append(LostDog)
            print("record recieved")
        }
        operation.queryCompletionBlock = { (cursor, error) in
            //dispatch_async(dispatch_get_main_queue()) {
                if error == nil {
                    LostDogs = newLostDogs
                    Error = nil
                } else {
                    print("error")
                    let ac = UIAlertController(title: "Fetch Error", message: "Please check your connection: \(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    viewcontroller.presentViewController(ac, animated: true, completion: nil)
                    Error = error
                }
            //}
        }
        publicDatabase.addOperation(operation)
        if Error == nil {
            //LostDogsMap().RefreshStop()
            print(LostDogs)
            return (LostDogs, Error)
        } else {
            return (nil, Error)
        }
    }
}
