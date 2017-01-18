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
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerData[row] {
            case "Light Red":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.red])
            case "Red":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)])
            case "Purple":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.purple])
            case "Pink":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.95, green: 0.2, blue: 0.3, alpha: 1.0)])
            case "Orange":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.orange])
            case "Yellow":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.yellow])
            case "Light Green":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.green])
            case "Green":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)])
            case "Light Blue":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.2, green: 0.7, blue: 0.9, alpha: 1.0)])
            case "Blue":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.blue])
            case "Dark Blue":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor(red: 0.0, green: 0.0, blue: 0.7, alpha: 1.0)])
            case "Black":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.black])
            case "Grey":
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.gray])
            default:
                return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidDogName()
        if textField == DogName {
            navigationItem.title = textField.text
            if textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
                navigationItem.title = "New Dog"
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        Connect.isEnabled = false
    }
    
    func checkValidDogName() {
        // Disable the Save button if the text field is empty.
        let text = DogName.text ?? ""
        Connect.isEnabled = (!text.isEmpty)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    @IBAction func Cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func TryToConnect(_ sender: AnyObject) {
        if !DogName.text!.isEmpty {
            AddDogName = DogName.text!
        } else {
            notifyUser("Could not Connect", message: "Your Dog's Name is Empty")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetController = segue.destination as! AddDogBreed
        if !DogName.text!.isEmpty {
            AddDogName = DogName.text!
        }
        targetController.AddDogCode = AddDogCode
        targetController.AddDogName = AddDogName
        targetController.AddDogColor = pickerData[self.Category.selectedRow(inComponent: 0)]
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
        DogName.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func takePhoto (_ alertAction: UIAlertAction!) {
        DogName.resignFirstResponder()
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
}
