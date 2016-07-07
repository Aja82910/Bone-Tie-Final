//
//  LookingForDogsTableViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/11/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import CloudKit

var subscriptionDogs: [String] = []

class LookingForDogsTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    var Search = UISearchController(searchResultsController: nil)
    var myBreeds: [String] = []
    var city = String()
    var filtered:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Breeds"
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedBreeds = defaults.objectForKey("myBreeds") as? [String] {
            myBreeds = savedBreeds
            subscriptionDogs = savedBreeds
        }
        else {
            myBreeds = [String]()
        }
        Search.searchResultsUpdater = self
        Search.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = Search.searchBar
        Search.delegate = self
        filtered = Breeds
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(self.saveTapped))
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func saveTapped() {
        if subscriptionDogs != myBreeds {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(myBreeds, forKey: "myBreeds")
            let database = CKContainer.defaultContainer().publicCloudDatabase
            database.fetchAllSubscriptionsWithCompletionHandler { (subscriptions, error) in
                var errors = true
                while errors {
                    if error == nil {
                        errors = false
                        if let subscriptions = subscriptions {
                            var x = 0
                            for dogBreed in subscriptionDogs {
                                if self.myBreeds.indexOf(dogBreed) == nil {
                                    database.deleteSubscriptionWithID(subscriptions[subscriptionDogs.indexOf(dogBreed)! - x].subscriptionID, completionHandler: { (str,   error) in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                            errors = true
                                        }
                                    })
                                    if errors {
                                        break
                                    }
                                }
                                x += 1
                            }
                            //more code coming soon
                            for breed in self.myBreeds {
                                if !subscriptionDogs.contains(breed) {
                                    let breedPredicate = NSPredicate(format: "Breed = %@", breed)
                                    let cityPredicate =  NSPredicate(format: "City = %@", self.city)
                                    //let predicate: NSPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [breedPredicate, cityPredicate])
                                    let subscription = CKSubscription(recordType: "Dogs", predicate: breedPredicate, options: .FiresOnRecordCreation)
                                    let notification = CKNotificationInfo()
                                    notification.alertBody = "Woof! There's a new \(breed) in town!"
                                    notification.soundName = "Dog Bark.mp3"
                                    subscription.notificationInfo = notification
                                    database.saveSubscription(subscription) { (result, error) -> Void in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                            errors = true
                                        }
                                        else {
                                            print("Saved Subscription")
                                        }
                                    }
                                    if errors {
                                        break
                                    }
                                }
                            }
                        } else {
                            errors = true
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let breed = self.filtered[indexPath.row]
        cell.textLabel?.text = breed
        
        if myBreeds.contains(breed) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let selectedBreed = self.filtered[indexPath.row]
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                myBreeds.append(selectedBreed)
            }
            else {
                cell.accessoryType = .None
                if let index = myBreeds.indexOf(selectedBreed) {
                    myBreeds.removeAtIndex(index)
                }
            }
        }
     tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered = Breeds.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(Search.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if filtered.isEmpty {
            filtered = Breeds
        }
        self.tableView.reloadData()
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = Breeds.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if filtered.isEmpty {
            filtered = Breeds
        }
        self.tableView.reloadData()
    }

}
