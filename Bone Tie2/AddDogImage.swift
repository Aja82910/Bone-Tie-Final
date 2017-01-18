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
    let container = CKContainer.default()
    var publicDatabase: CKDatabase?
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var photoURL: URL?
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidDogName()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        Connect.isEnabled = false
    }
    
    func checkValidDogName() {
        // Disable the Save button if the text field is empty.
        let text = DogImage.image == UIImage(named: "Image")
        Connect.isEnabled = (!text)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        DogImage.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        checkValidDogName()
    }
    @IBAction func Cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func TryToConnect(_ sender: AnyObject) {
        let photo = DogImage.image
        let date = Date()
        pictures.append(photo!)
        text.append(AddDogName)
        if let doggies = dog(name: AddDogName, photo: photo, date: date, breed: AddDogBreed, trackerNumber: AddDogCode, city: AddDogCity, color:  AddDogColor, sound:  AddDogSound, id: id) {
                self.performSegue(withIdentifier: "Connected", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Connected" {
            Connect.tintColor = UIColor.clear
            Connect.isEnabled = false
            self
            let photo = DogImage.image
            AddDogImage = photo
            let date = Date()
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
            newRecord.setObject(AddDogCity as CKRecordValue?, forKey: "City")
            newRecord.setObject(AddDogBreed as CKRecordValue?, forKey: "Breed")
            newRecord.setObject(AddDogName as CKRecordValue?, forKey: "Name")
            publicDatabase!.save(newRecord, completionHandler:
                ({returnRecord, error in
                    if let err = error {
                        DispatchQueue.main.async {
                            self.notifyUser("Save Error", message: err.localizedDescription)
                            print(err.localizedDescription)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.notifyUser("Success!", message: "Record saved successfully.")
                            print("Record Saved")
                        }
                        self.currentRecord = newRecord
                    }
                }))
            privateDatabase?.save(newRecord, completionHandler: { (returnRecord, error) in
                if let err = error {
                    DispatchQueue.main.async {
                        self.notifyUser("Save Error", message: err.localizedDescription)
                        print(err.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.notifyUser("Success!", message: "Record saved successfully.")
                        print("Record Saved")
                    }
                    self.currentRecord = newRecord
                }
            })
        }
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
    
    func photoLibrary (_ alertAction: UIAlertAction!) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func takePhoto (_ alertAction: UIAlertAction!) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.modalPresentationStyle = .fullScreen
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Add an Image For Your Dog", message: nil, preferredStyle: .actionSheet)
        
        let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: photoLibrary)
        let TakePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: takePhoto)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(PhotoLibrary)
        alert.addAction(TakePhoto)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        // Hide the keyboard.
        self.present(alert, animated: true, completion: nil)
    }

    func saveImageToFile(_ image: UIImage) -> URL {
        let dirPaths = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true)
    
        let docsDir: NSString = dirPaths[0] as NSString
    
        let filePath = docsDir.appendingPathComponent("img")
    
        try? UIImageJPEGRepresentation(image, 0.5)!.write(to: URL(fileURLWithPath: filePath),
                                                       options: [.atomic])
    
        return URL(fileURLWithPath: filePath)
    }
    func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myNewDog!, toFile: dog.archiveURL!.path)
        if !isSuccessfulSave {
        }
    }
}

