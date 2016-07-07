//
//  Lost.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 11/13/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

var MyLostDogs = [dog]()

class Lost: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var TableView: UITableView!
    var lostDogs = [dog]()
    @IBOutlet weak var LostButton: UIButton!
    @IBOutlet weak var FoundButton: UIButton!
    var Found = CGRect()
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    override func viewDidLoad() {
        super.viewDidLoad()
        LostButton.hidden = true
        FoundButton.hidden = true
        publicDatabase = container.publicCloudDatabase
        lost = isLost
        Found = FoundButton.frame
        Open.image = UIImage(named: "Open")
        Open.title = ""
        Open.tintColor = self.view.tintColor
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        dogs = Dogs().dogs
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        /*
        if lost == "Yes" {
            MyLostDogs = dogs
        }*/
    }
    var dogs = [dog]()
    override func viewDidAppear(animated: Bool) {
        if let savedDogs = loadDogs() {
        dogs = savedDogs
        }
    }
    var isSelected = false
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1 }
    func tableView(tableView: UITableView, numberOfSections: Int) -> Int{
        return 0 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dogs.count
    }
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cells", forIndexPath: indexPath) as! LostTableViewCell
        let doggies = dogs[indexPath.row]
        cell.DogNames.text = doggies.name
        cell.DogImages.image = doggies.photo
        return cell }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if MyLostDogs != [] {
            LostButton.hidden = true
            FoundButton.hidden = false
            if isSelected{
                isSelected = false
                var numberLost = 0
                for dog in lostDogs {
                    if dog == dogs[indexPath.row] {
                        break
                    }
                    numberLost += 1
                }
                lostDogs.removeAtIndex(numberLost)
                if lostDogs == [] {
                    LostButton.hidden = true
                    FoundButton.hidden = true
                }
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else{
                lostDogs.append(dogs[indexPath.row])
                isSelected = true
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        } else {
            LostButton.hidden = false
            FoundButton.hidden = true
            if isSelected{
                isSelected = false
                var numberLost = 0
                for dog in lostDogs {
                    if dog == dogs[indexPath.row] {
                        break
                    }
                    numberLost += 1
                }
                lostDogs.removeAtIndex(numberLost)
                if lostDogs == [] {
                    LostButton.hidden = true
                    FoundButton.hidden = true
                }
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else{
                lostDogs.append(dogs[indexPath.row])
                isSelected = true
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }

        }
    }
    @IBAction func Found(sender: AnyObject) {
        LostButton.hidden = true
        FoundButton.hidden = true
        lost = "No"
        let LostFound = Api().Found()
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.Found), userInfo: nil, repeats: !LostFound)
        for dog in lostDogs {
            if let index = MyLostDogs.indexOf(dog) {
                MyLostDogs.removeAtIndex(index)
            }
            publicDatabase?.deleteRecordWithID(CKRecordID(recordName: dog.name + dog.breed + dog.city), completionHandler: ({returnRecord, error in
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
        lostDogs = []
        let cells = TableView.indexPathsForVisibleRows
        let cell = TableView.cellForRowAtIndexPath(cells![0])
        cell?.accessoryType = UITableViewCellAccessoryType.None
        isSelected = false
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
    @IBAction func LostMode(sender: AnyObject) {
        lost = "Yes"
        let LostModes = Api().LostMode()
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.LostMode), userInfo: !LostModes, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.updateLocationLost), userInfo: lost == "Yes", repeats: true)
        MyLostDogs += lostDogs
        lostDogs = []
        for dog in MyLostDogs {
            let dogID = CKRecordID(recordName: dog.name + dog.breed + dog.city)
            let newRecord = CKRecord(recordType: "Lost", recordID: dogID)
            let photo = saveImageToFile(dog.photo!)
            newRecord.setObject(CKAsset(fileURL: photo), forKey: "Photo")
            let lostDate = NSDateFormatter()
            lostDate.timeZone = NSTimeZone.systemTimeZone()
            newRecord.setObject(lostDate.dateFromString(lostDate.stringFromDate(NSDate())), forKey: "LostDate")
            let Latitude: CLLocationDegrees = latitude
            let Longitude: CLLocationDegrees = longitude
            newRecord.setObject(CLLocation(latitude: Latitude, longitude: Longitude), forKey: "Location")
            newRecord.setObject(dog.name, forKey: "Name")
            publicDatabase!.saveRecord(newRecord, completionHandler: ({returnRecord, error in
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
                    print("suceess")
                    self.currentRecord = newRecord
                }
            }))
        }
        LostButton.hidden = true
        FoundButton.hidden = true
        let cells = TableView.indexPathsForVisibleRows
        let cell = TableView.cellForRowAtIndexPath(cells![0])
        cell?.accessoryType = UITableViewCellAccessoryType.None
        isSelected = false
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }
}
/*class Lost: UIViewController, UICollectionViewDelegate {
    var dogs = [dog]()
    @IBOutlet weak var Open: UIBarButtonItem!
    private var cellID = "CellID"
    let kCellSizeCoef: CGFloat = 0.75
    let kFirstItemTransform: CGFloat = 0.025
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        Open.image = UIImage(named: "Open")
        Open.title = ""
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        CollectionView.delegate = self
        CollectionView.dataSource = self
        let stickyLayout = CollectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = kFirstItemTransform
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        dogs = Dogs().dogs
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        title = "Lost Mode"
        CollectionView.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(CollectionView)
    }
    
    override func viewDidAppear(animated: Bool) {
        let savedDogs = loadDogs()
        if savedDogs != nil {
            dogs = savedDogs!
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  /*      }
    var isSelected = false
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1 }
    func tableView(tableView: UITableView, numberOfSections: Int) -> Int{
        return 0 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dogs.count
    }
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCellWithIdentifier("cells", forIndexPath: indexPath) as! LostTableViewCell
            let doggies = dogs[indexPath.row]
            cell.DogNames.text = doggies.name
            cell.DogImages.image = doggies.photo
            return cell }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if isSelected{
            isSelected = false
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            isSelected = true
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
} */
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }

}

extension Lost: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dogs.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let dog = dogs[indexPath.row]
        //let cell: LostCollectionViewCell = self.CollectionView.cellForItemAtIndexPath(indexPath) as! LostCollectionViewCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! LostCollectionViewCell
        cell.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        cell.DogNames.text = dog.name
        cell.DogImages.image = dog.photo
        //cell.DogNames.frame = CGRectMake(100, 100, 100, 100)
        return cell
    }
}

extension Lost: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(view.bounds), CGRectGetHeight(collectionView.bounds) * kCellSizeCoef)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
*/


