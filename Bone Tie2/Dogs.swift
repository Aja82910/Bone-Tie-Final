//
//  Dogs.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 11/13/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CloudKit
class Dogs: UITableViewController {
    
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var photoURL: NSURL?

    var dogs = [dog]()
    //var headerView = UIView()
    var x = 1
    //var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        else {
            //loadSampleDogs()
        }
        //Lost().dogs = dogs
       // self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: 152 / 192 * (self.view.frame.width), height: self.view.frame.height))

        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    /* Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())*/

        publicDatabase = container.publicCloudDatabase
        /*self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, 150)
        self.headerView.backgroundColor = UIColor(colorLiteralRed: 255/255.0, green: 105/255.0, blue: 0/255.0, alpha: 1.0)
        var images: [UIImage] = []
        for dog in dogs {
            images.append(dog.photo!)
        }
        images.append(UIImage(named: "Medicine")!)
        images.append(UIImage(named: "Photo")!)
        images.append(UIImage(named: "Nimble")!)
        images.append(UIImage(named: "Food")!)
        imageView = UIImageView(frame: CGRect(origin: self.headerView.frame.origin, size: CGSize(width: 133 / 192 * (headerView.frame.width), height: headerView.frame.height)))
        imageView.animationImages = images
        print(images.count)
        print(dogs.count)
        imageView.animationDuration = 15
        imageView.animationRepeatCount = 0
        headerView.addSubview(imageView)
        imageView.startAnimating()
        /*let label = UILabel(frame: self.headerView.frame)
        label.text = "My Dogs"
        self.headerView.addSubview(label)*/
        self.tableView.tableHeaderView = headerView*/
        self.clearsSelectionOnViewWillAppear = false

        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        dogs = []
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        tableView.reloadData()
        }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1 }
    func tableView(tableView: UITableView, numberOfSections: Int) -> Int{
        return 0 }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dogs.count + 5
        
    }
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            
            if indexPath.row >= 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DogNamesTableViewCell
                if dogs.count != 0 {
                    let doggies = dogs[indexPath.row - 5]
                    cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                    cell.DogName.textColor = UIColor.whiteColor()
                    cell.DogName.text = doggies.name
                    cell.DogImage.image = doggies.photo
                    cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 152 / 192 * cell.frame.width, height: cell.frame.height)
                }
            return cell
                
            }
            else if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Map", forIndexPath: indexPath) as UITableViewCell
                cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 152 / 192 * cell.frame.width, height: cell.frame.height)
                x += 1
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Lost", forIndexPath: indexPath) as UITableViewCell
                cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 152 / 192 * cell.frame.width, height: cell.frame.height)
                x += 1
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Add", forIndexPath: indexPath) as UITableViewCell
                cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 152 / 192 * cell.frame.width, height: cell.frame.height)
                print(cell.frame.width)
                x += 1
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Subscribe", forIndexPath: indexPath) as UITableViewCell
                cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 15 / 192 * cell.frame.width, height: cell.frame.height)
                print(tableView.frame.width)
                print(cell.frame.width)
                x += 1
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("Lost Dogs", forIndexPath: indexPath) as UITableViewCell
                cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
                cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 152 / 192 * cell.frame.width, height: cell.frame.height)
                x += 1
                return cell
        }
    }

    let EdittingDogs = EditDogViewController()
    var deleteDogIndexPath: NSIndexPath? = nil
    var indexpathed: NSIndexPath?
        // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedObject = self.dogs[sourceIndexPath.row]
        dogs.removeAtIndex(sourceIndexPath.row)
        dogs.insert(movedObject, atIndex: destinationIndexPath.row)
        //NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(dogs)")
        saveDogs()
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   // }
    func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dogs, toFile: dog.archiveURL!.path!)
        if !isSuccessfulSave {
        }
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

        
   
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        //let source  = sender.sourceViewController as? AddDogImage
        if let sourceViewController = sender.sourceViewController as? AddDogImage, pupies = sourceViewController.myNewDog {
            // Add a new meal.
            let newIndexPath = NSIndexPath(forRow: dogs.count + 5, inSection: 0)
            dogs.append(pupies)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        saveDogs()
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
    override func viewDidDisappear(animated: Bool) {
        UIView.animateWithDuration(0.2) {
            self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: 15 / 192 * (self.view.frame.width), height: self.view.frame.height))
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UIView.animateWithDuration(0.2) {
            self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: (self.view.frame.width), height: self.view.frame.height))
        }
        if segue.identifier == "ShowDogs" {
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! LostViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let videos = self.dogs[indexPath!.row - 5]
            targetController.doggie = videos
        }

    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }
    
    func loadSampleDogs () {
        let Dog1 = UIImage(named: "Nimble")!
        let sound = "Dog Bark.mp3"
        let Dog = dog(name: "Nimble", photo: Dog1, date: NSDate(), breed: "Labrador Retriever", trackerNumber: "Sw8w5u2", city: "city", color:  "Red", sound: sound, id: 1000)!
        dogs += [Dog]
    }
}