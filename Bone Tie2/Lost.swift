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
    let container = CKContainer.default()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    override func viewDidLoad() {
        super.viewDidLoad()
        LostButton.isHidden = true
        FoundButton.isHidden = true
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
    override func viewDidAppear(_ animated: Bool) {
        if let savedDogs = loadDogs() {
        dogs = savedDogs
        }
    }
    var isSelected = false
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1 }
    func tableView(_ tableView: UITableView, numberOfSections: Int) -> Int{
        return 0 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dogs.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! LostTableViewCell
        let doggies = dogs[indexPath.row]
        cell.DogNames.text = doggies.name
        cell.DogImages.image = doggies.photo
        return cell }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if MyLostDogs != [] {
            LostButton.isHidden = true
            FoundButton.isHidden = false
            if isSelected{
                isSelected = false
                var numberLost = 0
                for dog in lostDogs {
                    if dog == dogs[indexPath.row] {
                        break
                    }
                    numberLost += 1
                }
                lostDogs.remove(at: numberLost)
                if lostDogs == [] {
                    LostButton.isHidden = true
                    FoundButton.isHidden = true
                }
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            else{
                lostDogs.append(dogs[indexPath.row])
                isSelected = true
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        } else {
            LostButton.isHidden = false
            FoundButton.isHidden = true
            if isSelected{
                isSelected = false
                var numberLost = 0
                for dog in lostDogs {
                    if dog == dogs[indexPath.row] {
                        break
                    }
                    numberLost += 1
                }
                lostDogs.remove(at: numberLost)
                if lostDogs == [] {
                    LostButton.isHidden = true
                    FoundButton.isHidden = true
                }
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            else{
                lostDogs.append(dogs[indexPath.row])
                isSelected = true
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }

        }
    }
    @IBAction func Found(_ sender: AnyObject) {
        LostButton.isHidden = true
        FoundButton.isHidden = true
        lost = "No"
        let LostFound = Api().Found()
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.Found), userInfo: nil, repeats: !LostFound)
        for dog in lostDogs {
            if let index = MyLostDogs.index(of: dog) {
                MyLostDogs.remove(at: index)
            }
            publicDatabase?.delete(withRecordID: CKRecordID(recordName: dog.name + dog.breed + dog.city), completionHandler: ({returnRecord, error in
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
        lostDogs = []
        let cells = TableView.indexPathsForVisibleRows
        let cell = TableView.cellForRow(at: cells![0])
        cell?.accessoryType = UITableViewCellAccessoryType.none
        isSelected = false
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
    @IBAction func LostMode(_ sender: AnyObject) {
        lost = "Yes"
        let LostModes = Api().LostMode()
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.LostMode), userInfo: !LostModes, repeats: true)
        Timer.scheduledTimer(timeInterval: 3, target: Api(), selector: #selector(Api.updateLocationLost), userInfo: lost == "Yes", repeats: true)
        MyLostDogs += lostDogs
        lostDogs = []
        for dog in MyLostDogs {
            let dogID = CKRecordID(recordName: dog.name + dog.breed + dog.city)
            let newRecord = CKRecord(recordType: "Lost", recordID: dogID)
            let photo = saveImageToFile(dog.photo!)
            newRecord.setObject(CKAsset(fileURL: photo), forKey: "Photo")
            let lostDate = DateFormatter()
            lostDate.timeZone = TimeZone.current
            newRecord.setObject(lostDate.date(from: lostDate.string(from: Date())) as CKRecordValue?, forKey: "LostDate")
            let Latitude: CLLocationDegrees = latitude
            let Longitude: CLLocationDegrees = longitude
            newRecord.setObject(CLLocation(latitude: Latitude, longitude: Longitude), forKey: "Location")
            newRecord.setObject(dog.name as CKRecordValue?, forKey: "Name")
            publicDatabase!.save(newRecord, completionHandler: ({returnRecord, error in
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
                    print("suceess")
                    self.currentRecord = newRecord
                }
            }))
        }
        LostButton.isHidden = true
        FoundButton.isHidden = true
        let cells = TableView.indexPathsForVisibleRows
        let cell = TableView.cellForRow(at: cells![0])
        cell?.accessoryType = UITableViewCellAccessoryType.none
        isSelected = false
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
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


