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
import BTNavigationDropdownMenu
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


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
        selectButton.backgroundColor = UIColor.orange
        selectButton.options = categories
        Search.searchResultsUpdater = self
        Search.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        slider.frame = CGRect(x: 10, y: 5, width: self.tableView.frame.width - 130, height: 31)
        slider.maximumValue = 25
        slider.minimumValue = 0.1
        slider.value = 5
        slider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
        sliderValue.frame = CGRect(x: self.slider.frame.width + 10, y: 5, width: 110, height: 31)
        sliderValue.text = "Range: 5 Miles"
        sliderValue.font = UIFont(name: "Chalkduster", size: 20)
        sliderValue.adjustsFontSizeToFitWidth = true
        sliderValue.textAlignment = .center
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

    func category() {
        let bundle = Bundle(for: BTConfiguration.self)
        print(bundle)
        let url = bundle.url(forResource: "BTNavigationDropdownMenu", withExtension: "bundle")
        print(url)
        let imageBundle = Bundle(url: url!)
        let alert = UIAlertController(title: "Catigories", message: nil, preferredStyle: .actionSheet)
        var image = UIImage(contentsOfFile: imageBundle!.path(forResource: "checkmark_icon", ofType: "png")!)
        image = image!.withRenderingMode(.alwaysTemplate)
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
        let FoodAction = UIAlertAction(title: "Restaurants", style: .default) { (Alert) in
            imageViewF.center = CGPoint(x: 30, y: 200)
            alert.view.addSubview(imageViewF)
            if imageViewF.isHidden == true {
                imageViewF.isHidden = false
            } else {
                if imageViewAll.isHidden == false {
                    imageViewAll.isHidden = true
                }
                imageViewF.isHidden = true
            }
        }
        let PetsAction = UIAlertAction(title: "Pet Servicies", style: .default) { (Alert) in
            imageViewP.center = CGPoint(x: 30, y: 250)
            alert.view.addSubview(imageViewP)
            if imageViewP.isHidden == true {
                imageViewP.isHidden = false
            } else {
                if imageViewAll.isHidden == false {
                    imageViewAll.isHidden = true
                }
                imageViewP.isHidden = true
            }
        }
        let GasStationsAction = UIAlertAction(title: "Gas Stations", style: .default) { (Alert) in
            imageViewG.center = CGPoint(x: 30, y: 350)
            alert.view.addSubview(imageViewG)
            if imageViewG.isHidden == true {
                imageViewG.isHidden = false
            } else {
                if imageViewAll.isHidden == false {
                    imageViewAll.isHidden = true
                }
                imageViewG.isHidden = true
            }
        }
        /*let ConvenienceStoresAction = UIAlertAction(title: "Convenience Stores", style: .Default) { (Alert) in
            imageView.center = CGPoint(x: 30, y: 200)
        }*/
        let ParksAndRecreationAction = UIAlertAction(title: "Parks and Recreation", style: .default) { (Alert) in
            imageViewPAR.center = CGPoint(x: 30, y: 400)
            alert.view.addSubview(imageViewPAR)
            if imageViewPAR.isHidden == true {
                imageViewPAR.isHidden = false
            } else {
                if imageViewAll.isHidden == false {
                    imageViewAll.isHidden = true
                }
                imageViewPAR.isHidden = true
            }
        }
        let ShoppingAction = UIAlertAction(title: "Stores", style: .default) { (Alert) in
            imageViewS.center = CGPoint(x: 30, y: 450)
            alert.view.addSubview(imageViewS)
            if imageViewS.isHidden == true {
                imageViewS.isHidden = false
            } else {
                if imageViewAll.isHidden == false {
                    imageViewAll.isHidden = true
                }
                imageViewS.isHidden = true
            }
        }
        let AllAction = UIAlertAction(title: "All", style: .default) { (Alert) in
            imageViewAll.center = CGPoint(x: 30, y: 450)
            alert.view.addSubview(imageViewAll)
            if imageViewAll.isHidden == true {
                imageViewAll.isHidden = false
                for imageView in imageViews {
                    imageView.isHidden = false
                }
            } else {
                imageViewAll.isHidden = true
                if !self.selectedCatigories.contains("Food") {
                    imageViewF.isHidden = true
                }
                if !self.selectedCatigories.contains("Pets") {
                    imageViewP.isHidden = true
                }
                if !self.selectedCatigories.contains("Gas Stations") {
                    imageViewG.isHidden = true
                }
                if !self.selectedCatigories.contains("Parks and Recreation") {
                    imageViewPAR.isHidden = true
                }
                if !self.selectedCatigories.contains("Shopping") {
                    imageViewS.isHidden = true
                }
            }
        }
        let doneAction = UIAlertAction(title: "Done", style: .cancel) { (Alert) in
            if imageViewG.isHidden == true && imageViewPAR.isHidden == true && imageViewP.isHidden == true && imageViewS.isHidden == true && imageViewF.isHidden == true {
                imageViewG.isHidden = false
                imageViewPAR.isHidden = false
                imageViewP.isHidden = false
                imageViewS.isHidden = false
                imageViewF.isHidden = false
                imageViewAll.isHidden = false
                self.notifyUser("None Selected", message: "Since you did not select one category, all categories are now selected!")
            }
            if imageViewAll.isHidden == false {
                //self.selectButton.titleLabel?.text = "All"
                self.selectedCatigories.append("Food")
                self.selectedCatigories.append("Pets")
                self.selectedCatigories.append("Gas Stations")
                self.selectedCatigories.append("Parks and Recreation")
                self.selectedCatigories.append("Shopping")
            } else {
                if imageViewF.isHidden == false {
                    if !self.selectedCatigories.contains("Food") {
                        self.selectedCatigories.append("Food")
                    }
                } else if self.selectedCatigories.contains("Food") {
                    self.selectedCatigories.remove(at: self.selectedCatigories.index(of: "Food")!)
                }
                if imageViewP.isHidden == false {
                    if !self.selectedCatigories.contains("Pets") {
                        self.selectedCatigories.append("Pets")
                    }
                } else if self.selectedCatigories.contains("Pets") {
                    self.selectedCatigories.remove(at: self.selectedCatigories.index(of: "Pets")!)
                }
                if imageViewG.isHidden == false {
                    if !self.selectedCatigories.contains("Gas Stations") {
                        self.selectedCatigories.append("Gas Stations")
                    }
                } else if self.selectedCatigories.contains("Gas Stations") {
                    self.selectedCatigories.remove(at: self.selectedCatigories.index(of: "Gas Stations")!)
                }
                if imageViewF.isHidden == false {
                    if !self.selectedCatigories.contains("Parks and Recreation") {
                        self.selectedCatigories.append("Parks and Recreation")
                    }
                } else if self.selectedCatigories.contains("Parks and Recreation") {
                    self.selectedCatigories.remove(at: self.selectedCatigories.index(of: "Parks and Recreation")!)
                }
                if imageViewF.isHidden == false {
                    if !self.selectedCatigories.contains("Shopping") {
                        self.selectedCatigories.append("Shopping")
                    }
                } else if self.selectedCatigories.contains("Shopping") {
                    self.selectedCatigories.remove(at: self.selectedCatigories.index(of: "Shopping")!)
                }
                if self.selectedCatigories.count > 1 {
                    for category in self.selectedCatigories {
                        if self.selectedCatigories.index(of: category) == self.selectedCatigories.count - 1 {
                            // self.selectButton.titleLabel?.text? += category
                        } else if self.selectedCatigories.index(of: category) == self.selectedCatigories.count - 2 {
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
            alert.dismiss(animated: true, completion: nil)
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
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        // Hide the keyboard.
        self.present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityLabel.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print(cityLabel.count)
        print(indexPath.row)
        if cityLabel.count < indexPath.row {
            self.tableView.reloadData()
            return cell
        }
        print(self.tableView.numberOfRows(inSection: 1))
        cell.textLabel?.text = cityLabel[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //AddDogCity = cityLabel[indexPath.row]
        //wperformSegueWithIdentifier("AddDogImage", sender: self)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !Search.searchBar.text!.isEmpty {
            return 1
        } else {
            return 7
        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        presentSearchController(Search)
        return true
    }
    func presentSearchController(_ searchController: UISearchController) {
        self.tableView.tableHeaderView = Search.searchBar
        Search.isEditing = true
        //presentViewController(Search, animated: true, completion: nil)
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        print(Search.searchBar.superview == HeaderView)
        self.tableView.tableHeaderView = Search.searchBar
    }
    /*func willDismissSearchController(searchController: UISearchController) {
        UIView.animateWithDuration(0.2) {
            self.Search.searchBar.frame = CGRect(x: self.Search.searchBar.frame.minX, y: 40, width: self.Search.searchBar.frame.width, height: self.Search.searchBar.frame.height)
        }
    }*/
    func didDismissSearchController(_ searchController: UISearchController) {
        print(Search.searchBar.frame)
        print(definesPresentationContext)
        self.tableView.tableHeaderView = HeaderView
        UIView.animate(withDuration: 0.2, animations: {
            self.Search.searchBar.frame = CGRect(x: self.Search.searchBar.frame.minX, y: 40, width: self.Search.searchBar.frame.width, height: self.Search.searchBar.frame.height)
            self.HeaderView.addSubview(self.Search.searchBar)
            self.HeaderView.addSubview(self.slider)
            self.HeaderView.bringSubview(toFront: self.Search.searchBar)
            self.HeaderView.bringSubview(toFront: self.slider)
            
        }) 
        print(Search.searchBar.frame)
        print(Search.searchBar.superview == HeaderView)
        print(HeaderView)
        print(Search.searchBar.superview!)
    }
    func updateSearchResults(for searchController: UISearchController) {
        if !Search.searchBar.text!.isEmpty {
            var first = abs(latitude) - 90
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
            localSearch.start { (localSearchResponse, error) -> Void in
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
            var first = abs(latitude) - 90
            if first == 0{
                first += 0.0000000000001
            }
            let second = abs(90 / first) / 69
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
                localSearch.start { (localSearchResponse, error) -> Void in
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
            localSearch.start { (localSearchResponse, error) -> Void in
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
    func postalAddressFromAddressDictionary(_ addressdictionary: Dictionary<String,AnyObject>) -> CNMutablePostalAddress {
        
        let address = CNMutablePostalAddress()
        
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.isoCountryCode = addressdictionary["Country Code"] as? String ?? ""
        
        return address
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //print("Found user's location: \(location)")
            placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as! AddDogImage
        DestViewController.AddDogCode = AddDogCode
        DestViewController.AddDogName = AddDogName
        DestViewController.AddDogBreed = AddDogBreed
        DestViewController.AddDogCity = AddDogCity
        DestViewController.AddDogColor = AddDogColor
    }
    
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
    }
    

}
