//
//  AddDogImage.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/5/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import CloudKit

class AddDogImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var DogImage: UIImageView!
    @IBOutlet weak var Connect: UIBarButtonItem!
    var AddDogName = String()
    var AddDogCode = String()
    var AddDogCity = String()
    var AddDogBreed = String()
    var AddDogColor = String()
    var AddDogImage: UIImage?
    var AddDogSound = String()
    var myNewDog: dog?
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var photoURL: NSURL?
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id = getID()
        print(AddDogName)
        publicDatabase = container.publicCloudDatabase
        privateDatabase = container.privateCloudDatabase
        DogImage.frame = CGRect(x: self.DogImage.frame.minX, y: self.DogImage.frame.minY, width: self.DogImage.frame.height, height: self.DogImage.frame.height)
        navigationItem.title = AddDogName
        // Handle the text field’s user input through delegate callbacks.
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidDogName()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDogName()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        Connect.enabled = false
    }
    
    func checkValidDogName() {
        // Disable the Save button if the text field is empty.
        let text = DogImage.image == UIImage(named: "Image")
        Connect.enabled = (!text)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        DogImage.image = selectedImage
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        checkValidDogName()
    }
    @IBAction func Cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func TryToConnect(sender: AnyObject) {
        let photo = DogImage.image
        let date = NSDate()
        pictures.append(photo!)
        text.append(AddDogName)
        if let doggies = dog(name: AddDogName, photo: photo, date: date, breed: AddDogBreed, trackerNumber: AddDogCode, city: AddDogCity, color:  AddDogColor, sound:  AddDogSound, id: id) {
                self.performSegueWithIdentifier("Connected", sender: self)
                myNewDog = doggies
            }
        else {
            notifyUser("Could not Connect", message: "There was a saving error.\n Please Try Again")
        }
    }
    func getID() -> Int {
        var dogs = [dog]()
        if let savedDog = loadDogs() {
            dogs += savedDog
        }
        var id = 0
        if dogs.count != 0 {
            id = dogs[dogs.count - 1].id + 1
        }
        return id
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Connected" {
            Connect.tintColor = UIColor.clearColor()
            Connect.enabled = false
            self
            let photo = DogImage.image
            AddDogImage = photo
            let date = NSDate()
            pictures.append(photo!)
            text.append(AddDogName)
            myNewDog = dog(name: AddDogName, photo: photo, date: date, breed: AddDogBreed, trackerNumber: AddDogCode, city: AddDogCity, color: AddDogColor, sound: AddDogSound, id: id)
            saveDogs()
            let dogID = CKRecordID(recordName: AddDogName + AddDogCode)
            let newRecord = CKRecord(recordType: "Dogs", recordID: dogID)
            if AddDogImage == nil {
                notifyUser("No Photo", message: "Use the Photo Option to Choose a Photo for the dog")
                return
            } else {
                photoURL = saveImageToFile(AddDogImage!)
                if let URL = photoURL {
                    let imageAsset = CKAsset(fileURL: URL)
                    newRecord.setObject(imageAsset, forKey: "Photo")
                }
            }
            newRecord.setObject(AddDogCity, forKey: "City")
            newRecord.setObject(AddDogBreed, forKey: "Breed")
            newRecord.setObject(AddDogName, forKey: "Name")
            publicDatabase!.saveRecord(newRecord, completionHandler:
                ({returnRecord, error in
                    if let err = error {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.notifyUser("Save Error", message: err.localizedDescription)
                            print(err.localizedDescription)
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.notifyUser("Success!", message: "Record saved successfully.")
                            print("Record Saved")
                        }
                        self.currentRecord = newRecord
                    }
                }))
            privateDatabase?.saveRecord(newRecord, completionHandler: { (returnRecord, error) in
                if let err = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.notifyUser("Save Error", message: err.localizedDescription)
                        print(err.localizedDescription)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.notifyUser("Success!", message: "Record saved successfully.")
                        print("Record Saved")
                    }
                    self.currentRecord = newRecord
                }
            })
        }
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
    
    func photoLibrary (alertAction: UIAlertAction!) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    func takePhoto (alertAction: UIAlertAction!) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .Camera
        imagePickerController.cameraCaptureMode = .Photo
        imagePickerController.modalPresentationStyle = .FullScreen
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Add an Image For Your Dog", message: nil, preferredStyle: .ActionSheet)
        
        let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .Default, handler: photoLibrary)
        let TakePhoto = UIAlertAction(title: "Take Photo", style: .Default, handler: takePhoto)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(PhotoLibrary)
        alert.addAction(TakePhoto)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        // Hide the keyboard.
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func saveImageToFile(image: UIImage) -> NSURL {
        let dirPaths = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true)
    
        let docsDir: AnyObject = dirPaths[0]
    
        let filePath =
        docsDir.stringByAppendingPathComponent("img")
    
        UIImageJPEGRepresentation(image, 0.5)!.writeToFile(filePath,
                                                       atomically: true)
    
        return NSURL.fileURLWithPath(filePath)
    }
    func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myNewDog!, toFile: dog.archiveURL!.path!)
        if !isSuccessfulSave {
        }
    }
}

