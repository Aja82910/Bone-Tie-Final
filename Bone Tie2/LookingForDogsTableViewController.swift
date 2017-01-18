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
        let defaults = UserDefaults.standard
        if let savedBreeds = defaults.object(forKey: "myBreeds") as? [String] {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveTapped))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func saveTapped() {
        if subscriptionDogs != myBreeds {
            let defaults = UserDefaults.standard
            defaults.set(myBreeds, forKey: "myBreeds")
            let database = CKContainer.default().publicCloudDatabase
            database.fetchAllSubscriptions { (subscriptions, error) in
                var errors = true
                while errors {
                    if error == nil {
                        errors = false
                        if let subscriptions = subscriptions {
                            var x = 0
                            for dogBreed in subscriptionDogs {
                                if self.myBreeds.index(of: dogBreed) == nil {
                                    database.delete(withSubscriptionID: subscriptions[subscriptionDogs.index(of: dogBreed)! - x].subscriptionID, completionHandler: { (str,   error) in
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
                                    let subscription = CKSubscription(recordType: "Dogs", predicate: breedPredicate, options: .firesOnRecordCreation)
                                    let notification = CKNotificationInfo()
                                    notification.alertBody = "Woof! There's a new \(breed) in town!"
                                    notification.soundName = "Dog Bark.mp3"
                                    subscription.notificationInfo = notification
                                    database.save(subscription, completionHandler: { (result, error) -> Void in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                            errors = true
                                        }
                                        else {
                                            print("Saved Subscription")
                                        }
                                    }) 
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
            self.dismiss(animated: true, completion: nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let breed = self.filtered[indexPath.row]
        cell.textLabel?.text = breed
        
        if myBreeds.contains(breed) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let selectedBreed = self.filtered[indexPath.row]
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                myBreeds.append(selectedBreed)
            }
            else {
                cell.accessoryType = .none
                if let index = myBreeds.index(of: selectedBreed) {
                    myBreeds.remove(at: index)
                }
            }
        }
     tableView.deselectRow(at: indexPath, animated: true)
    }
    func updateSearchResults(for searchController: UISearchController) {
        filtered = Breeds.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: Search.searchBar.text!, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filtered.isEmpty {
            filtered = Breeds
        }
        self.tableView.reloadData()
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = Breeds.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filtered.isEmpty {
            filtered = Breeds
        }
        self.tableView.reloadData()
    }

}
