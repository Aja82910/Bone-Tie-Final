//
//  NearbyBuildingsViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 6/5/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class NearbyBuildingsViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, CLLocationManagerDelegate {

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
    var slider = UISlider()
    var sliderValue = UILabel()
    var HeaderView = UIView()
    let selectButton = ZHDropDownMenu()
    var first = true
    let categories = ["Food", "Pets", "Gas Stations", /*"Convenience Stores",*/ "Parks", "Recreation", "Shopping"]
    var selectedCatigories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80 + Search.searchBar.frame.height))
        print(selectButton.frame.height)
        selectButton.buttonImage = UIImage(named: "Down")
        selectButton.tintColor = self.view.tintColor
        selectButton.frame = CGRect(x: 10, y: 50 + Search.searchBar.frame.maxY, width: 80, height: 30)
        selectButton.center = CGPoint(x: self.view.center.x, y: self.selectButton.center.y)
        //selectButton.addTarget(self, action: #selector(self.category), forControlEvents: .TouchUpInside)
        //selectButton.titleLabel?.adjustsFontSizeToFitWidth = true
        selectButton.backgroundColor = UIColor.orangeColor()
        selectButton.options = categories
        Search.searchResultsUpdater = self
        Search.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        slider.frame = CGRect(x: 10, y: 5, width: self.tableView.frame.width - 130, height: 31)
        slider.maximumValue = 25
        slider.minimumValue = 0.1
        slider.value = 5
        slider.addTarget(self, action: #selector(self.sliderChanged), forControlEvents: .ValueChanged)
        sliderValue.frame = CGRect(x: self.slider.frame.width + 10, y: 5, width: 110, height: 31)
        sliderValue.text = "Range: 5 Miles"
        sliderValue.font = UIFont(name: "Chalkduster", size: 20)
        sliderValue.adjustsFontSizeToFitWidth = true
        sliderValue.textAlignment = .Center
        sliderValue.textColor = self.view.tintColor
        Search.searchBar.frame = CGRect(x: self.Search.searchBar.frame.minX, y: 40, width: self.Search.searchBar.frame.width, height: self.Search.searchBar.frame.height)
        Search.searchBar.delegate = self
        HeaderView.addSubview(Search.searchBar)
        HeaderView.addSubview(slider)
        HeaderView.addSubview(sliderValue)
        HeaderView.addSubview(selectButton)
        tableView.tableHeaderView = HeaderView
        Search.delegate = self
        self.navigationItem.title = dogs?.name
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        self.tableView.frame = CGRect(origin: self.tableView.frame.origin, size: CGSize(width: self.tableView.frame.width, height: self.view.frame.height - 40))
        self.view.addSubview(slider)
        if let place = manager.location {
            placemark = MKPlacemark(coordinate: place.coordinate, addressDictionary: nil)
        }
    }
    func sliderChanged() {
        if Int(slider.value) != 0 {
            sliderValue.text = "Range: " + String(Int(slider.value)) + " Miles"
            slider.value = Float(Int(slider.value))
        } else {
            sliderValue.text = "Range: " + String(Double(round(slider.value * 10)) / 10) + " Miles"
        }
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

    func category() {
        let alert = UIAlertController(title: "Catigories", message: nil, preferredStyle: .ActionSheet)
        var image = UIImage(contentsOfFile: checkMarkImagePaths!)
        image = image!.imageWithRenderingMode(.AlwaysTemplate)
        let imageViewS = UIImageView(image: image)
        imageViewS.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageViewF = UIImageView(image: image)
        imageViewF.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageViewP = UIImageView(image: image)
        imageViewP.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageViewG = UIImageView(image: image)
        imageViewG.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageViewPAR = UIImageView(image: image)
        imageViewPAR.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageViewAll = UIImageView(image: image)
        imageViewAll.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageViews: [UIImageView] = [imageViewF, imageViewS, imageViewPAR, imageViewG, imageViewP]
        let FoodAction = UIAlertAction(title: "Restaurants", style: .Default) { (Alert) in
            imageViewF.center = CGPoint(x: 30, y: 200)
            alert.view.addSubview(imageViewF)
            if imageViewF.hidden == true {
                imageViewF.hidden = false
            } else {
                if imageViewAll.hidden == false {
                    imageViewAll.hidden = true
                }
                imageViewF.hidden = true
            }
        }
        let PetsAction = UIAlertAction(title: "Pet Servicies", style: .Default) { (Alert) in
            imageViewP.center = CGPoint(x: 30, y: 250)
            alert.view.addSubview(imageViewP)
            if imageViewP.hidden == true {
                imageViewP.hidden = false
            } else {
                if imageViewAll.hidden == false {
                    imageViewAll.hidden = true
                }
                imageViewP.hidden = true
            }
        }
        let GasStationsAction = UIAlertAction(title: "Gas Stations", style: .Default) { (Alert) in
            imageViewG.center = CGPoint(x: 30, y: 350)
            alert.view.addSubview(imageViewG)
            if imageViewG.hidden == true {
                imageViewG.hidden = false
            } else {
                if imageViewAll.hidden == false {
                    imageViewAll.hidden = true
                }
                imageViewG.hidden = true
            }
        }
        /*let ConvenienceStoresAction = UIAlertAction(title: "Convenience Stores", style: .Default) { (Alert) in
            imageView.center = CGPoint(x: 30, y: 200)
        }*/
        let ParksAndRecreationAction = UIAlertAction(title: "Parks and Recreation", style: .Default) { (Alert) in
            imageViewPAR.center = CGPoint(x: 30, y: 400)
            alert.view.addSubview(imageViewPAR)
            if imageViewPAR.hidden == true {
                imageViewPAR.hidden = false
            } else {
                if imageViewAll.hidden == false {
                    imageViewAll.hidden = true
                }
                imageViewPAR.hidden = true
            }
        }
        let ShoppingAction = UIAlertAction(title: "Stores", style: .Default) { (Alert) in
            imageViewS.center = CGPoint(x: 30, y: 450)
            alert.view.addSubview(imageViewS)
            if imageViewS.hidden == true {
                imageViewS.hidden = false
            } else {
                if imageViewAll.hidden == false {
                    imageViewAll.hidden = true
                }
                imageViewS.hidden = true
            }
        }
        let AllAction = UIAlertAction(title: "All", style: .Default) { (Alert) in
            imageViewAll.center = CGPoint(x: 30, y: 450)
            alert.view.addSubview(imageViewAll)
            if imageViewAll.hidden == true {
                imageViewAll.hidden = false
                for imageView in imageViews {
                    imageView.hidden = false
                }
            } else {
                imageViewAll.hidden = true
                if !self.selectedCatigories.contains("Food") {
                    imageViewF.hidden = true
                }
                if !self.selectedCatigories.contains("Pets") {
                    imageViewP.hidden = true
                }
                if !self.selectedCatigories.contains("Gas Stations") {
                    imageViewG.hidden = true
                }
                if !self.selectedCatigories.contains("Parks and Recreation") {
                    imageViewPAR.hidden = true
                }
                if !self.selectedCatigories.contains("Shopping") {
                    imageViewS.hidden = true
                }
            }
        }
        let doneAction = UIAlertAction(title: "Done", style: .Cancel) { (Alert) in
            if imageViewG.hidden == true && imageViewPAR.hidden == true && imageViewP.hidden == true && imageViewS.hidden == true && imageViewF.hidden == true {
                imageViewG.hidden = false
                imageViewPAR.hidden = false
                imageViewP.hidden = false
                imageViewS.hidden = false
                imageViewF.hidden = false
                imageViewAll.hidden = false
                self.notifyUser("None Selected", message: "Since you did not select one category, all categories are now selected!")
            }
            if imageViewAll.hidden == false {
                //self.selectButton.titleLabel?.text = "All"
                self.selectedCatigories.append("Food")
                self.selectedCatigories.append("Pets")
                self.selectedCatigories.append("Gas Stations")
                self.selectedCatigories.append("Parks and Recreation")
                self.selectedCatigories.append("Shopping")
            } else {
                if imageViewF.hidden == false {
                    if !self.selectedCatigories.contains("Food") {
                        self.selectedCatigories.append("Food")
                    }
                } else if self.selectedCatigories.contains("Food") {
                    self.selectedCatigories.removeAtIndex(self.selectedCatigories.indexOf("Food")!)
                }
                if imageViewP.hidden == false {
                    if !self.selectedCatigories.contains("Pets") {
                        self.selectedCatigories.append("Pets")
                    }
                } else if self.selectedCatigories.contains("Pets") {
                    self.selectedCatigories.removeAtIndex(self.selectedCatigories.indexOf("Pets")!)
                }
                if imageViewG.hidden == false {
                    if !self.selectedCatigories.contains("Gas Stations") {
                        self.selectedCatigories.append("Gas Stations")
                    }
                } else if self.selectedCatigories.contains("Gas Stations") {
                    self.selectedCatigories.removeAtIndex(self.selectedCatigories.indexOf("Gas Stations")!)
                }
                if imageViewF.hidden == false {
                    if !self.selectedCatigories.contains("Parks and Recreation") {
                        self.selectedCatigories.append("Parks and Recreation")
                    }
                } else if self.selectedCatigories.contains("Parks and Recreation") {
                    self.selectedCatigories.removeAtIndex(self.selectedCatigories.indexOf("Parks and Recreation")!)
                }
                if imageViewF.hidden == false {
                    if !self.selectedCatigories.contains("Shopping") {
                        self.selectedCatigories.append("Shopping")
                    }
                } else if self.selectedCatigories.contains("Shopping") {
                    self.selectedCatigories.removeAtIndex(self.selectedCatigories.indexOf("Shopping")!)
                }
                if self.selectedCatigories.count > 1 {
                    for category in self.selectedCatigories {
                        if self.selectedCatigories.indexOf(category) == self.selectedCatigories.count - 1 {
                            // self.selectButton.titleLabel?.text? += category
                        } else if self.selectedCatigories.indexOf(category) == self.selectedCatigories.count - 2 {
                            // self.selectButton.titleLabel?.text? += category + " and "
                        } else  {
                            //self.selectButton.titleLabel?.text? += category + ", "
                        }
                    }
                } else {
                    //self.selectButton.titleLabel?.text = self.selectedCatigories[0]
                }
                //self.selectButton.setTitle(self.selectButton.titleLabel?.text, forState: .Normal)
                //self.selectButton.setTitle(self.selectButton.titleLabel?.text, forState: .Selected)
            }
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(doneAction)
        alert.addAction(ShoppingAction)
        alert.addAction(AllAction)
        alert.addAction(ParksAndRecreationAction)
        alert.addAction(GasStationsAction)
        alert.addAction(PetsAction)
        alert.addAction(FoodAction)
        /*Using Table View*/
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        // Hide the keyboard.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityLabel.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        print(cityLabel.count)
        print(indexPath.row)
        if cityLabel.count < indexPath.row {
            self.tableView.reloadData()
            return cell
        }
        print(self.tableView.numberOfRowsInSection(1))
        cell.textLabel?.text = cityLabel[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //AddDogCity = cityLabel[indexPath.row]
        //wperformSegueWithIdentifier("AddDogImage", sender: self)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !Search.searchBar.text!.isEmpty {
            return 1
        } else {
            return 7
        }
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        presentSearchController(Search)
        return true
    }
    func presentSearchController(searchController: UISearchController) {
        self.tableView.tableHeaderView = Search.searchBar
        Search.editing = true
        //presentViewController(Search, animated: true, completion: nil)
    }
    func willPresentSearchController(searchController: UISearchController) {
        print(Search.searchBar.superview == HeaderView)
        self.tableView.tableHeaderView = Search.searchBar
    }
    /*func willDismissSearchController(searchController: UISearchController) {
        UIView.animateWithDuration(0.2) {
            self.Search.searchBar.frame = CGRect(x: self.Search.searchBar.frame.minX, y: 40, width: self.Search.searchBar.frame.width, height: self.Search.searchBar.frame.height)
        }
    }*/
    func didDismissSearchController(searchController: UISearchController) {
        print(Search.searchBar.frame)
        print(definesPresentationContext)
        self.tableView.tableHeaderView = HeaderView
        UIView.animateWithDuration(0.2) {
            self.Search.searchBar.frame = CGRect(x: self.Search.searchBar.frame.minX, y: 40, width: self.Search.searchBar.frame.width, height: self.Search.searchBar.frame.height)
            self.HeaderView.addSubview(self.Search.searchBar)
            self.HeaderView.addSubview(self.slider)
            self.HeaderView.bringSubviewToFront(self.Search.searchBar)
            self.HeaderView.bringSubviewToFront(self.slider)
            
        }
        print(Search.searchBar.frame)
        print(Search.searchBar.superview == HeaderView)
        print(HeaderView)
        print(Search.searchBar.superview)
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !Search.searchBar.text!.isEmpty {
            var first = CLLocationDegrees.abs(latitude) - 90
            if first == 0{
                first += 0.0000000000001
            }
            let second = (90 / first) / 69
            let third = second * Double(slider.value)
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: Double(slider.value) / 69, longitudeDelta: third))
            localSearchRequest.naturalLanguageQuery = Search.searchBar.text
            localSearch = MKLocalSearch(request: localSearchRequest)
            cityLabel.removeAll()
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                for searchResponse in localSearchResponse!.mapItems {
                    /*CLGeocoder().reverseGeocodeLocation(searchResponse.placemark.location!, completionHandler: { (placemarks, error) -> Void in
                        if error != nil {
                            self.notifyUser("Error Serching", message: "Could Not Find its Location Information from this City")
                            return
                        }
                        else if placemarks?.count >= 0 {
                            let pm = placemarks![0]
                            let country = pm.subLocality
                                print(pm.addressDictionary)
                            let State = pm.subThoroughfare
                            print(pm.areasOfInterest)
                            let City = pm.name
                            if self.cityLabel.contains(City! + ", " + State! + " " + country!) {
                                return
                            } else {
                                self.cityLabel.append(City! + ", " + State! + " " + country!)
                                self.tableView.reloadData()
                            }
                        }
                    })*/
                    self.cityLabel.append(searchResponse.name!)
                    self.tableView.reloadData()
                }
                self.matchingItems = localSearchResponse!.mapItems
            }
        }
        else {
            //let user = MKMapItem.mapItemForCurrentLocation()
            var first = CLLocationDegrees.abs(latitude) - 90
            if first == 0{
                first += 0.0000000000001
            }
            let second = CLLocationDegrees.abs(90 / first) / 69
            let third = second * Double(slider.value)
            print(third)
            print(second)
            print(first)
            print("Hello")
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: Double(slider.value) / 69, longitudeDelta: third))
            print(localSearchRequest.region)
            let places = ["Food", "Pets", "Gas Stations", /*"Convenience Stores",*/ "Parks", "Recreation", "Shopping"]
            cityLabel.removeAll()
            for place in places {
                localSearchRequest.naturalLanguageQuery = place
                    localSearch = MKLocalSearch(request: localSearchRequest)
                localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                    if localSearchResponse?.mapItems.count >= 1 {
                        for searchResponse in localSearchResponse!.mapItems {
                            print(searchResponse.name)
                            print(searchResponse.phoneNumber)
                            /*CLGeocoder().reverseGeocodeLocation(searchResponse.placemark.location!, completionHandler: { (placemarks, error) -> Void in
                                if error != nil {
                                    self.notifyUser("Error Serching", message: "Could Not Find its Location Information from this City")
                                    return
                                }
                                else if placemarks?.count >= 0 {
                                    let pm = placemarks![0]
                                    let country = pm.subLocality
                                    print(pm.addressDictionary)
                                    let State = pm.subThoroughfare
                                    print(pm.areasOfInterest)
                                    let City = pm.name
                                    if self.cityLabel.contains(City! + ", " + State! + " " + country!) {
                                        return
                                    } else {
                                        self.cityLabel.append(City! + ", " + State! + " " + country!)
                                        self.tableView.reloadData()
                                    }
                                }
                            })*/
                            self.cityLabel.append(searchResponse.name!)
                            self.tableView.reloadData()
                        }
                        self.matchingItems = localSearchResponse!.mapItems
                    }
                }
            }
            localSearchRequest.naturalLanguageQuery = "Shopping Center"
            localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                if localSearchResponse?.mapItems.count >= 1 {
                    for searchResponse in localSearchResponse!.mapItems {
                        /*CLGeocoder().reverseGeocodeLocation(searchResponse.placemark.location!, completionHandler: { (placemarks, error) -> Void in
                            if error != nil {
                                self.notifyUser("Error Serching", message: "Could Not Find its Location Information from this City")
                                return
                            }
                            else if placemarks?.count >= 0 {
                                let pm = placemarks![0]
                                let country = pm.subLocality
                                print(pm.addressDictionary)
                                let State = pm.subThoroughfare
                                print(pm.areasOfInterest)
                                let City = pm.name
                                if self.cityLabel.contains(City! + ", " + State! + " " + country!) {
                                    self.cityLabel.removeAtIndex(self.cityLabel.indexOf(City! + ", " + State! + " " + country!)!)
                                    self.tableView.reloadData()
                                } else {
                                    return
                                }
                            }
                        })*/
                    }
                    self.matchingItems = localSearchResponse!.mapItems
                }
            }

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
    
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
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
    */
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController = segue.destinationViewController as! AddDogImage
        DestViewController.AddDogCode = AddDogCode
        DestViewController.AddDogName = AddDogName
        DestViewController.AddDogBreed = AddDogBreed
        DestViewController.AddDogCity = AddDogCity
        DestViewController.AddDogColor = AddDogColor
    }
    
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }
    

}
