//
//  AddDogCity.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/5/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class AddDogCity: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, CLLocationManagerDelegate {
    var Search = UISearchController(searchResultsController: nil)
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var matchingItems:[MKMapItem] = []
    var error:NSError!
    var cityLabel: [String] = []
    var AddDogName = String()
    var AddDogCode = String()
    var AddDogBreed = String()
    var AddDogCity = String()
    var AddDogColor = String()
    var dogs: dog?
    var manager: CLLocationManager!
    var placemark: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Search.searchResultsUpdater = self
        Search.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = Search.searchBar
        Search.delegate = self
        self.navigationItem.title = AddDogName
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        if let place = manager.location {
            placemark = MKPlacemark(coordinate: place.coordinate, addressDictionary: nil)
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityLabel.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddDogTableViewCell
        cell.CityName.text = cityLabel[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        AddDogCity = cityLabel[indexPath.row]
        performSegueWithIdentifier("AddDogSound", sender: self)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !Search.searchBar.text!.isEmpty {
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = Search.searchBar.text
            localSearch = MKLocalSearch(request: localSearchRequest)
            cityLabel.removeAll()
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                for searchResponse in localSearchResponse!.mapItems {
                    CLGeocoder().reverseGeocodeLocation(searchResponse.placemark.location!, completionHandler: { (placemarks, error) -> Void in
                        if error != nil {
                            self.notifyUser("Error Serching", message: "Could Not Find its Location Information from this City")
                            return
                        }
                        else if placemarks?.count >= 0 {
                            let pm = placemarks![0]
                            let country = pm.country
                            let State = pm.administrativeArea
                            let City = pm.locality
                            if self.cityLabel.contains(City! + ", " + State! + " " + country!) {
                                return
                            } else {
                                self.cityLabel.append(City! + ", " + State! + " " + country!)
                                self.tableView.reloadData()
                            }
                        }
                        
                    })

                }
                self.matchingItems = localSearchResponse!.mapItems
            }
        }
        else {
            //let user = MKMapItem.mapItemForCurrentLocation()
            cityLabel.removeAll()
            CLGeocoder().reverseGeocodeLocation(placemark!.location!, completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                else if placemarks?.count > 0 {
                    let pm = placemarks![0]
                    let country = pm.country
                    let State = pm.administrativeArea
                    let City = pm.locality
                    self.cityLabel.append(City! + ", " + State! + " " + country!)
                    self.tableView.reloadData()
                    }

            })
        }

    }
    func postalAddressFromAddressDictionary(addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress {
        
        let address = CNMutablePostalAddress()
        
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.ISOCountryCode = addressdictionary["Country Code"] as? String ?? ""
        
        return address
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //print("Found user's location: \(location)")
            placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
        }
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = Search.searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        cityLabel.removeAll()
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            for searchResponse in localSearchResponse!.mapItems {
                let placemark = searchResponse.placemark
                let country = placemark.countryCode
                let State = placemark.administrativeArea
                let City = placemark.locality
                self.cityLabel.append(City! + ", " + State! + " " + country!)
            }
            self.matchingItems = localSearchResponse!.mapItems
        }
        }
        else {
            let user = MKMapItem.mapItemForCurrentLocation()
            let placemark = user.placemark
            let country = placemark.countryCode
            let State = placemark.administrativeArea
            let City = placemark.locality
            self.cityLabel.append(City! + ", " + State! + " " + country!)
        }

    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController = segue.destinationViewController as! SampleSoundsViewController
        DestViewController.AddDogCode = AddDogCode
        DestViewController.AddDogName = AddDogName
        DestViewController.AddDogBreed = AddDogBreed
        DestViewController.AddDogCity = AddDogCity
        DestViewController.AddDogColor = AddDogColor
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
    
        func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }
    
    }
