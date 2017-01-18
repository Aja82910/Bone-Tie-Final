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
    let container = CKContainer.default()
    var publicDatabase: CKDatabase?
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var photoURL: URL?
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
            FoundButton.isHidden = false
            LostButton.isHidden = true
        }
        else {
            FoundButton.isHidden = true
            LostButton.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfSections: Int) -> Int{
        return 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Device", for: indexPath) as! SettingsTableViewCell
        return cell
    }
    @IBAction func DeletingDog(_ sender: AnyObject) {
        confirmDelete(deletedDog!.name)
    }
    func confirmDelete(_ Dog: String) {
        let alert = UIAlertController(title: "Delete Dog", message: "Are you sure you want to permanently delete \(Dog)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteDog)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteDog)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    // ...
    
    func handleDeleteDog(_ alertAction: UIAlertAction!) -> Void {
        if MyLostDogs.index(of: deletedDog!) != nil {
            foundDog(deletedDog)
        }
            let myDeletedDog = deletedDog
            let dogID = CKRecordID(recordName: myDeletedDog!.name)
            let newRecord = CKRecord(recordType: "deletedDog", recordID: dogID)
            if let url = photoURL {
                let imageAsset = CKAsset(fileURL: url)
                newRecord.setObject(imageAsset, forKey: "Photo")
            }
            newRecord.setObject(myDeletedDog!.name as CKRecordValue?, forKey: "Name")
                privateDatabase?.delete(withRecordID: CKRecordID(recordName: myDeletedDog!.name + myDeletedDog!.trackerNumber) , completionHandler: { (Record, Error) in
                    if Error == nil {
                        repeat {
                            self.publicDatabase?.delete(withRecordID: newRecord.recordID, completionHandler: ({
                            returnRecord, error in
                                if let err = error {
                                    DispatchQueue.main.async {
                                        self.notifyUser("Error Deleting From Public Database", message: "Trying Again")
                                    }
                                } else {
                                    DispatchQueue.main.async {
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
                        print(Error!)
                        return
                    }
                })
            /*
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            deleteDogIndexPath = nil
            */
            saveDogs()
            self.performSegue(withIdentifier: "Deleted", sender: self)
        
        
        }
    func removeDogsWithID(_ id: Int) {
        if let savedDogs = self.loadDogs() {
            self.dogs += savedDogs
        }
        var indexes = [Int]()
        for index in 1...dogs.count {
            if dogs[index - 1].id == id {
                indexes.append(index - 1)
            }
        }
        indexes = indexes.reversed()
        for deleteIndex in indexes {
            dogs.remove(at: deleteIndex)
        }
    }
     func foundDog(_ theDog: dog?) {
        let LostFound = Api().Found()
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.Found), userInfo: nil, repeats: !LostFound)
        if let index = MyLostDogs.index(of: theDog!) {
            MyLostDogs.remove(at: index)
        }
        publicDatabase?.delete(withRecordID: CKRecordID(recordName: theDog!.name + theDog!.breed + theDog!.city), completionHandler: ({returnRecord, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.notifyUser("Save Error", message: err.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    self.notifyUser("Success!", message: "Record saved successfully.")
                }
            }
        }))
    }

    func cancelDeleteDog(_ alertAction: UIAlertAction!) {
    }
func notifyUser(_ title: String, message: String) -> Void
{
    let alert = UIAlertController(title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.alert)
    
    let cancelAction = UIAlertAction(title: "OK",
        style: .cancel, handler: nil)
    
    alert.addAction(cancelAction)
    self.present(alert, animated: true,
        completion: nil)
}
func saveImageToFile(_ image: UIImage) -> URL
{
    let dirPaths = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true)
    
    let docsDir: NSString = dirPaths[0] as NSString
    
    let filePath = docsDir.appendingPathComponent("img")
    
    try? UIImageJPEGRepresentation(image, 0.5)!.write(to: URL(fileURLWithPath: filePath),
        options: [.atomic])
    
    return URL(fileURLWithPath: filePath)
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deletedDog" {
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! EditDogViewController
            let video = deletedDog
            targetController.dogs = video
        }

    }
@IBAction func unwindToDogList(_ sender: UIStoryboardSegue) {
    if let sourceViewControllered = sender.source as? EditDogViewController, let pupies = sourceViewControllered.dogs {
            let dogID = CKRecordID(recordName: pupies.name)
            photoURL = saveImageToFile(pupies.photo!)
            dogs[0] = pupies
            deletedDog = pupies
            self.navigationItem.title = deletedDog?.name
            publicDatabase?.fetch(withRecordID: dogID, completionHandler: { (record, error) in
                if error != nil {
                    print("Error fetching record: \(error!.localizedDescription)")
                } else {
                    // Now you have grabbed your existing record from iCloud
                    // Apply whatever changes you want
                    record!.setObject(pupies.name as CKRecordValue?, forKey: "Name")
                    record!.setObject(pupies.breed as CKRecordValue?, forKey: "category")
                    
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
                    self.publicDatabase!.save(record!, completionHandler: { (savedRecord, saveError) in
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
    @IBAction func Found(_ sender: AnyObject) {
        LostButton.isHidden = false
        FoundButton.isHidden = true
        lost = "No"
        let LostFound = Api().Found()
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.Found), userInfo: nil, repeats: !LostFound)
        MyLostDogs.remove(at: MyLostDogs.index(of: deletedDog!)!)
        publicDatabase?.delete(withRecordID: CKRecordID(recordName: deletedDog!.name + deletedDog!.breed + deletedDog!.city), completionHandler: ({returnRecord, error in
            if let err = error {
                DispatchQueue.main.async {
                    //self.notifyUser("Save Error", message: err.localizedDescription)
                    print(err.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    //self.notifyUser("Success!", message: "Record saved successfully.")
                    print("Record Saved")
                }
            }
        }))
    }
    @IBAction func LostMode(_ sender: AnyObject) {
        lost = "Yes"
        let LostModes = Api().LostMode()
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.LostMode), userInfo: nil, repeats: !LostModes)
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.retrieveWeatherForecast), userInfo: nil, repeats: lost == "Yes")
        MyLostDogs.append(deletedDog!)
        let dogID = CKRecordID(recordName: deletedDog!.name + deletedDog!.breed + deletedDog!.city)
        let newRecord = CKRecord(recordType: "Lost", recordID: dogID)
        let photo = saveImageToFile(deletedDog!.photo!)
        newRecord.setObject(CKAsset(fileURL: photo), forKey: "Photo")
        let lostDate = DateFormatter()
        lostDate.timeZone = TimeZone.current
        newRecord.setObject(lostDate.date(from: lostDate.string(from: Date())) as CKRecordValue?, forKey: "LostDate")
        let Latitude: CLLocationDegrees = latitude
        let Longitude: CLLocationDegrees = longitude
        newRecord.setObject(CLLocation(latitude: Latitude, longitude: Longitude), forKey: "Location")
        newRecord.setObject(deletedDog!.name as CKRecordValue?, forKey: "Name")
        publicDatabase!.save(newRecord, completionHandler: ({returnRecord, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.notifyUser("Save Error", message: err.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    self.notifyUser("Success!", message: "Record saved successfully.")
                }
                print("suceess")
                self.currentRecord = newRecord
            }
        }))
        LostButton.isHidden = true
        FoundButton.isHidden = false
    }


    func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dogs, toFile: dog.archiveURL!.path)
        if !isSuccessfulSave {
            print("Failed to save deletedDog...")
        }
        
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
    }

}
