//
//  Setings.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 3/24/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import CloudKit

class Setings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var deletedDog: dog?
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var photoURL: NSURL?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var FoundButton: UIButton!
    @IBOutlet weak var LostButton: UIButton!
    var dogs = [dog]()
    
    override func viewDidLoad() {
        publicDatabase = container.publicCloudDatabase
        privateDatabase = container.privateCloudDatabase
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }

        tableView.delegate = self
        tableView.dataSource = self
        if lost == "Yes" {
            FoundButton.hidden = false
            LostButton.hidden = true
        }
        else {
            FoundButton.hidden = true
            LostButton.hidden = false
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfSections: Int) -> Int{
        return 0 }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Device", forIndexPath: indexPath) as! SettingsTableViewCell
        return cell
    }
    @IBAction func DeletingDog(sender: AnyObject) {
        confirmDelete(deletedDog!.name)
    }
    func confirmDelete(Dog: String) {
        let alert = UIAlertController(title: "Delete Dog", message: "Are you sure you want to permanently delete \(Dog)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteDog)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteDog)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // ...
    
    func handleDeleteDog(alertAction: UIAlertAction!) -> Void {
        if MyLostDogs.indexOf(deletedDog!) != nil {
            foundDog(deletedDog)
        }
            let myDeletedDog = deletedDog
            let dogID = CKRecordID(recordName: myDeletedDog!.name)
            let newRecord = CKRecord(recordType: "deletedDog", recordID: dogID)
            if let url = photoURL {
                let imageAsset = CKAsset(fileURL: url)
                newRecord.setObject(imageAsset, forKey: "Photo")
            }
            newRecord.setObject(myDeletedDog!.name, forKey: "Name")
                privateDatabase?.deleteRecordWithID(CKRecordID(recordName: myDeletedDog!.name + myDeletedDog!.trackerNumber) , completionHandler: { (Record, Error) in
                    if Error == nil {
                        repeat {
                            self.publicDatabase?.deleteRecordWithID(newRecord.recordID, completionHandler: ({
                            returnRecord, error in
                                if let err = error {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.notifyUser("Error Deleting From Public Database", message: "Trying Again")
                                    }
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.notifyUser("Success!", message: "Record Deleted successfully.")
                                    }
                                    self.currentRecord = newRecord
                                    
                                    self.removeDogsWithID(myDeletedDog!.id)
                                    self.saveDogs()
                                }
                            }))
                        } while Error != nil
                    }
                    else {
                        print(Error)
                        return
                    }
                })
            /*
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            deleteDogIndexPath = nil
            */
            saveDogs()
            self.performSegueWithIdentifier("Deleted", sender: self)
        
        
        }
    func removeDogsWithID(id: Int) {
        if let savedDogs = self.loadDogs() {
            self.dogs += savedDogs
        }
        var indexes = [Int]()
        for index in 1...dogs.count {
            if dogs[index - 1].id == id {
                indexes.append(index - 1)
            }
        }
        indexes = indexes.reverse()
        for deleteIndex in indexes {
            dogs.removeAtIndex(deleteIndex)
        }
    }
     func foundDog(theDog: dog?) {
        let LostFound = Api().Found()
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.Found), userInfo: nil, repeats: !LostFound)
        if let index = MyLostDogs.indexOf(theDog!) {
            MyLostDogs.removeAtIndex(index)
        }
        publicDatabase?.deleteRecordWithID(CKRecordID(recordName: theDog!.name + theDog!.breed + theDog!.city), completionHandler: ({returnRecord, error in
            if let err = error {
                dispatch_async(dispatch_get_main_queue()) {
                    self.notifyUser("Save Error", message: err.localizedDescription)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.notifyUser("Success!", message: "Record saved successfully.")
                }
            }
        }))
    }

    func cancelDeleteDog(alertAction: UIAlertAction!) {
    }
func notifyUser(title: String, message: String) -> Void
{
    let alert = UIAlertController(title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "OK",
        style: .Cancel, handler: nil)
    
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true,
        completion: nil)
}
func saveImageToFile(image: UIImage) -> NSURL
{
    let dirPaths = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true)
    
    let docsDir: AnyObject = dirPaths[0]
    
    let filePath =
    docsDir.stringByAppendingPathComponent("img")
    
    UIImageJPEGRepresentation(image, 0.5)!.writeToFile(filePath,
        atomically: true)
    
    return NSURL.fileURLWithPath(filePath)
}
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "deletedDog" {
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! EditDogViewController
            let video = deletedDog
            targetController.dogs = video
        }

    }
@IBAction func unwindToDogList(sender: UIStoryboardSegue) {
    if let sourceViewControllered = sender.sourceViewController as? EditDogViewController, pupies = sourceViewControllered.dogs {
            let dogID = CKRecordID(recordName: pupies.name)
            photoURL = saveImageToFile(pupies.photo!)
            dogs[0] = pupies
            deletedDog = pupies
            self.navigationItem.title = deletedDog?.name
            publicDatabase?.fetchRecordWithID(dogID, completionHandler: { (record, error) in
                if error != nil {
                    print("Error fetching record: \(error!.localizedDescription)")
                } else {
                    // Now you have grabbed your existing record from iCloud
                    // Apply whatever changes you want
                    record!.setObject(pupies.name, forKey: "Name")
                    record!.setObject(pupies.breed, forKey: "category")
                    
                    if (pupies.photo == nil) {
                        self.notifyUser("No Photo", message: "Use the Photo option to choose a photo for the dog")
                        return
                    } else {
                        self.photoURL = self.saveImageToFile(pupies.photo!)
                    }
                    if let url = self.photoURL {
                        let imageAsset = CKAsset(fileURL: url)
                        record!.setObject(imageAsset, forKey: "Photo")
                    }
                    
                    // Save this record again
                    self.publicDatabase!.saveRecord(record!, completionHandler: { (savedRecord, saveError) in
                        if saveError != nil {
                            print("Error saving record: \(saveError!.localizedDescription)")
                        } else {
                            print("Successfully updated record!")
                        }
                    })
                }
            })
        // Update an existing meal.
        saveDogs()
        
    }
    saveDogs()
}
    @IBAction func Found(sender: AnyObject) {
        LostButton.hidden = false
        FoundButton.hidden = true
        lost = "No"
        let LostFound = Api().Found()
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.Found), userInfo: nil, repeats: !LostFound)
        MyLostDogs.removeAtIndex(MyLostDogs.indexOf(deletedDog!)!)
        publicDatabase?.deleteRecordWithID(CKRecordID(recordName: deletedDog!.name + deletedDog!.breed + deletedDog!.city), completionHandler: ({returnRecord, error in
            if let err = error {
                dispatch_async(dispatch_get_main_queue()) {
                    //self.notifyUser("Save Error", message: err.localizedDescription)
                    print(err.localizedDescription)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    //self.notifyUser("Success!", message: "Record saved successfully.")
                    print("Record Saved")
                }
            }
        }))
    }
    @IBAction func LostMode(sender: AnyObject) {
        lost = "Yes"
        let LostModes = Api().LostMode()
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.LostMode), userInfo: nil, repeats: !LostModes)
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.retrieveWeatherForecast), userInfo: nil, repeats: lost == "Yes")
        MyLostDogs.append(deletedDog!)
        let dogID = CKRecordID(recordName: deletedDog!.name + deletedDog!.breed + deletedDog!.city)
        let newRecord = CKRecord(recordType: "Lost", recordID: dogID)
        let photo = saveImageToFile(deletedDog!.photo!)
        newRecord.setObject(CKAsset(fileURL: photo), forKey: "Photo")
        let lostDate = NSDateFormatter()
        lostDate.timeZone = NSTimeZone.systemTimeZone()
        newRecord.setObject(lostDate.dateFromString(lostDate.stringFromDate(NSDate())), forKey: "LostDate")
        let Latitude: CLLocationDegrees = latitude
        let Longitude: CLLocationDegrees = longitude
        newRecord.setObject(CLLocation(latitude: Latitude, longitude: Longitude), forKey: "Location")
        newRecord.setObject(deletedDog!.name, forKey: "Name")
        publicDatabase!.saveRecord(newRecord, completionHandler: ({returnRecord, error in
            if let err = error {
                dispatch_async(dispatch_get_main_queue()) {
                    self.notifyUser("Save Error", message: err.localizedDescription)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.notifyUser("Success!", message: "Record saved successfully.")
                }
                print("suceess")
                self.currentRecord = newRecord
            }
        }))
        LostButton.hidden = true
        FoundButton.hidden = false
    }


    func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dogs, toFile: dog.archiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save deletedDog...")
        }
        
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }

}
