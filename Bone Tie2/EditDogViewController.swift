//
//  EditDogViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 1/18/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit

class EditDogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var EditDogName: UITextField!
    @IBOutlet weak var EditTrackerNumber: UITextField!
    @IBOutlet weak var EditPhoto: UIImageView!
    var dogs: dog?
    @IBOutlet weak var Done: UIBarButtonItem!
    @IBOutlet weak var Categories: UIPickerView!
    let pickerData = ["Labrador Retriever", "American Water Spaniel", "Beagle", "Poodle", "Bichon Frise"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        EditDogName.delegate = self
        EditDogName.text = (self.dogs?.name)
        EditPhoto.image = (self.dogs?.photo)
        EditPhoto.frame = CGRect(x: self.EditPhoto.frame.minX, y: self.EditPhoto.frame.minY, width: self.EditPhoto.frame.height, height: self.EditPhoto.frame.height)
        self.view.addSubview(EditDogName)
        self.view.addSubview(EditPhoto)
        Categories.dataSource = self
        Categories.delegate = self
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

    func sharing (Photo: UIImage, Name: String){
        EditDogName?.text = Name
        EditPhoto?.image = Photo
        if (EditPhoto != nil && EditDogName != nil) {
        self.view.addSubview(EditDogName)
        self.view.addSubview(EditPhoto)
        //var index = Indexpath
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDogName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        Done.enabled = false
    }
    
    func checkValidDogName() {
        // Disable the Save button if the text field is empty.
        let text = EditDogName?.text ?? ""
        Done?.enabled = !text.isEmpty
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
        EditPhoto?.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if Done === sender {
            let name = EditDogName?.text ?? ""
            let photo = EditPhoto?.image
            let date = dogs?.date
            let selected = Categories.selectedRowInComponent(0)
            let breed = pickerData[selected]
            dogs = dog(name: name, photo: photo, date: date!, breed: breed, trackerNumber: self.EditTrackerNumber.text!, city: "City", color:  dogs!.color, sound: dogs!.sound, id: dogs!.id)
        }
    }
    func photoLibrary (alertAction: UIAlertAction!) {
        EditDogName?.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    func takePhoto (alertAction: UIAlertAction!) {
        EditDogName?.resignFirstResponder()
        
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

    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        let alert = UIAlertController(title: "Edit the Image of Your Dog", message: nil, preferredStyle: .ActionSheet)
        
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
        self.presentViewController(alert, animated: true, completion: nil)    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
