//
//  AddDogNameAndBreed.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/5/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit

class AddDogName: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    @IBOutlet weak var Category: UIPickerView!
    @IBOutlet weak var DogName: UITextField!
    @IBOutlet weak var Connect: UIBarButtonItem!
    
    var AddDogCode = String()
    var AddDogName = String()
    
    var dogs: dog?
    let pickerData = ["Light Red", "Red", "Purple", "Pink", "Orange", "Yellow", "Light Green", "Green", "Light Blue", "Blue", "Dark Blue", "Black", "Grey"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //Category.dataSource = self
        Category.delegate = self
        // Handle the text field’s user input through delegate callbacks.
        DogName.delegate = self
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidDogName()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerData[row] {
            case "Light Red":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            case "Red":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)])
            case "Purple":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.purpleColor()])
            case "Pink":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.95, green: 0.2, blue: 0.3, alpha: 1.0)])
            case "Orange":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
            case "Yellow":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.yellowColor()])
            case "Light Green":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.greenColor()])
            case "Green":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)])
            case "Light Blue":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.2, green: 0.7, blue: 0.9, alpha: 1.0)])
            case "Blue":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.blueColor()])
            case "Dark Blue":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.0, green: 0.0, blue: 0.7, alpha: 1.0)])
            case "Black":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
            case "Grey":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
            default:
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDogName()
        if textField == DogName {
            navigationItem.title = textField.text
            if textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
                navigationItem.title = "New Dog"
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        Connect.enabled = false
    }
    
    func checkValidDogName() {
        // Disable the Save button if the text field is empty.
        let text = DogName.text ?? ""
        Connect.enabled = (!text.isEmpty)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    @IBAction func Cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func TryToConnect(sender: AnyObject) {
        if !DogName.text!.isEmpty {
            AddDogName = DogName.text!
        } else {
            notifyUser("Could not Connect", message: "Your Dog's Name is Empty")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let targetController = segue.destinationViewController as! AddDogBreed
        if !DogName.text!.isEmpty {
            AddDogName = DogName.text!
        }
        targetController.AddDogCode = AddDogCode
        targetController.AddDogName = AddDogName
        targetController.AddDogColor = pickerData[self.Category.selectedRowInComponent(0)]
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
        DogName.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    func takePhoto (alertAction: UIAlertAction!) {
        DogName.resignFirstResponder()
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
}
