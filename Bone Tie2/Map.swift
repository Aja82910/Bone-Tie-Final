//
//  SecondViewController.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 11/13/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var mapsType: UISegmentedControl!
    var dogInfo: dog?
    @IBOutlet weak var Open: UIBarButtonItem!
    var activePlace = 0
    var places = [Dictionary<String, String>()]
    let api = Api()
    var dogs = [dog]()
    var doneReloading = true
    
    @IBOutlet weak var Refresh: UIBarButtonItem!
    
    var manager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        if NSUserDefaults.standardUserDefaults().boolForKey("CompletedTutorial") {
            // Terms have been accepted, proceed as normal
        } else {
            performSegueWithIdentifier("Tutorial", sender: self)
            // Terms have not been accepted. Show terms (perhaps using performSegueWithIdentifier)
        }
        uiBusy.color = self.view.tintColor
        let begin: () = api.beginApi()
        begin
        let longed = longitude
        let lated = latitude
        Open.image = UIImage(named: "Open")
        Open.title = ""
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        //uilpgr.minimumPressDuration = 1.0
        //mapView.addGestureRecognizer(uilpgr)
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        if places.count == 1 {
            places.removeAtIndex(0)
        }
        if latitude != 0.0 {
            if places.count == 0 {
                places.append(["name":"Nimble", "lat":String(latitude), "lon":String(longitude)])
            }
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            Map.delegate = self
            Map.showsUserLocation = true
            manager.requestAlwaysAuthorization()
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
            var counting = 0
            while counting < Map.annotations.count && Map.annotations.count != 1{
                if Map.annotations[counting].title! as String? == places[activePlace]["name"] {
                    Map.removeAnnotation(Map.annotations[counting])
                    break
                }
                counting += 1
            }
            
            if activePlace == -1 {
                manager.requestAlwaysAuthorization()
                manager.startUpdatingLocation()
            } else {
                //let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
                let latitude: CLLocationDegrees = lated
                let longitude: CLLocationDegrees = longed
                let latDelta: CLLocationDegrees = 0.01
                let lonDelta: CLLocationDegrees = 0.01
                let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                Map.setRegion(region, animated: true)
                for dog in dogs {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                Map.addAnnotation(annotation)
                annotation.title = dog.name
                annotation.subtitle = dog.breed
                mapView(Map, viewForAnnotation: annotation)
                NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.mapReload), userInfo: nil, repeats: true)
                }
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func unwindToMapList(sender: UIStoryboardSegue) {
        viewDidAppear(true)
    }
    /*func presentTurorial() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TutorialViews") as! AnnotationViewController
        viewController.alpha = 0.5
        //self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(viewController, animated: false, completion: nil)
    }*/

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Refreshing"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        var dogNumber: Int = 0
        for dog in dogs {
            if String?(annotation.title!!) == String!(dog.name) {
                break
            }
            dogNumber += 1
        }
        let AnnotationDog = UIImageView(image: dogs[dogNumber].photo)
        if annotation is MKUserLocation {
            return nil
        }
        else if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let pinImage = combineAnnotationPhotos(dogs[dogNumber])
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            view?.image = resizedImage
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            view?.leftCalloutAccessoryView = AnnotationDog
            //view?.animatesDrop = true
            AnnotationDog.frame = CGRectMake(0, 0, view!.bounds.height + 28, view!.bounds.height + 10)
            AnnotationDog.contentMode = .ScaleAspectFill
            //view?.sizeToFit()
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    func combineAnnotationPhotos(Dog: dog) -> UIImage {
        var bottomImage: UIImage
        var topImage = Dog.photo
        switch Dog.color {
        case "Light Red":
            bottomImage = UIImage(named: "Light Red Annotation")!
        case "Red":
            bottomImage = UIImage(named: "Red Annotation")!
        case "Purple":
            bottomImage = UIImage(named: "Purple Annotation")!
        case "Pink":
            bottomImage = UIImage(named: "Pink Annotation")!
        case "Orange":
            bottomImage = UIImage(named: "Orange Annotation")!
        case "Yellow":
            bottomImage = UIImage(named: "Yellow Annotation")!
        case "Light Green":
            bottomImage = UIImage(named: "Light Green Annotation")!
        case "Green":
            bottomImage = UIImage(named: "Green Annotation")!
        case "Light Blue":
            bottomImage = UIImage(named: "Light Blue Annotation")!
        case "Blue":
            bottomImage = UIImage(named: "Blue Annotation")!
        case "Dark Blue":
            bottomImage = UIImage(named: "Dark Blue Annotation")!
        case "Black":
            bottomImage = UIImage(named: "Black Annotation")!
        case "Grey": // or White
            bottomImage = UIImage(named: "Black Annotation")!
        default:
            bottomImage = UIImage(named: "Red Annotation")!
        }
        let size = CGSizeMake(50, 50)
        topImage = circle(topImage!, size: CGSize(width: 50.0, height: 50.0))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        [bottomImage.drawInRect(CGRectMake(0, 0, size.width, size.height))];
        [topImage!.drawInRect(CGRectMake(0.11 * (size.width), 0.06 * (size.height), 0.77 * (size.width), 0.77 * (size.height)))];
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func circle(image: UIImage, size: CGSize) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = image
        imageView.layer.cornerRadius = size.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    func findDog(annotation: MKAnnotationView) -> dog? {
        for dog in dogs {
            if dog.name == String(annotation.annotation?.title) && dog.photo == annotation.leftCalloutAccessoryView {
                return dog
            }
        }
        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            dogInfo = findDog(view)
            performSegueWithIdentifier("Dogs", sender: self)
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first {
            print("Found user's location: \(location)")
        }*/
    }
    override func viewDidAppear(animated: Bool) {
            // Terms have been accepted, proceed as normal
        
        let longed = longitude
        let lated = latitude
        dogs = []
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        if places.count == 1 {
            places.removeAtIndex(0)
        }
        if latitude != 0.0 {
            if places.count == 0 {
                places.append(["name":"Nimble", "lat":String(latitude), "lon":String(longitude)])
            }
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            Map.showsUserLocation = true
            print("In ViewDidAppear")
            manager.requestAlwaysAuthorization()
            print("In ViewDidAppear Next")
            manager.startUpdatingLocation()
            var counting = 0
            while counting < Map.annotations.count && Map.annotations.count != 1{
                if Map.annotations[counting].title! as String? == places[activePlace]["name"] {
                    Map.removeAnnotation(Map.annotations[counting])
                    break
                }
                counting += 1
            }
            
            if activePlace == -1 {
                manager.requestAlwaysAuthorization()
                manager.startUpdatingLocation()
            } else {
                //let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
                let latitude: CLLocationDegrees = lated
                let longitude: CLLocationDegrees = longed
                let latDelta: CLLocationDegrees = 0.01
                let lonDelta: CLLocationDegrees = 0.01
                let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                Map.setRegion(region, animated: true)
                for dog in dogs {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    Map.addAnnotation(annotation)
                    annotation.title = dog.name
                    annotation.subtitle = dog.breed
                    mapView(Map, viewForAnnotation: annotation)
                }
            }
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func MapType(sender: UISegmentedControl) {
        switch mapsType.selectedSegmentIndex
        {
        case 0:
        self.Map.mapType = MKMapType.Standard
        case 1:
        self.Map.mapType = MKMapType.SatelliteFlyover
        case 2:
        self.Map.mapType = MKMapType.HybridFlyover
        default:
            break
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController = segue.destinationViewController as? LostViewController
        DestViewController?.doggie = dogInfo
    }
    
    
    /*func longPress(gestureRecognizer: UIGestureRecognizer) {
     
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.Map)
            let newCoordinate = Map.convertPoint(touchPoint, toCoordinateFromView: self.Map)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            
                if error != nil {
                    print(error)
                }
                else {
                    let p = CLPlacemark(placemark: placemarks![0] as CLPlacemark)
                    var subThoroughfare: String
                    var thoroughfare: String
                    
                    if p.subThoroughfare != nil {
                        subThoroughfare = p.subThoroughfare!
                    }
                    else {
                        subThoroughfare = ""
                    }
                    if p.thoroughfare != nil {
                        thoroughfare = p.thoroughfare!
                    }
                    else {
                       thoroughfare = ""
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    
                    var title = "\(subThoroughfare) \(thoroughfare)"
                    
                    if title == " " {
                        let date = NSDate()
                        title = "Location added \(date)"
                    }
                    annotation.title = title
                    
                    self.Map.addAnnotation(annotation)
                    
                    self.places.append(["name":title, "lat":"\(newCoordinate.latitude)", "lon":"\(newCoordinate.longitude)"])
                }
            
            })
        }
    }*/
    var RefreshColor: UIColor?
    @IBAction func refreshData() {
            Refreshing(true)
            doneReloading = false
            let request = api.requestDatafromDog(true)
            let retrieve = api.mapReload()
            NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector:  #selector(LostViewController.EndedRefresh), userInfo: nil, repeats: !EndedRefresh())
            RefreshColor = self.view.tintColor
            Refresh.tintColor = UIColor.clearColor()
            Refresh.enabled = false
            self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: uiBusy), Refresh], animated: true)
            if !request || !retrieve {
                if !request {
                    NSTimer.scheduledTimerWithTimeInterval(5, target: Api(), selector: #selector(Api.requestDatafromDog), userInfo: nil, repeats: !request)
                }
                else if !retrieve {
                    NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.mapReload), userInfo: nil, repeats: !retrieve)
                }
                else {
                    Refreshing(false)
                    EndedRefresh()
                }
            }
            else {
                
            }
            
            retrieve
        }
        
        func Refreshing(on: Bool) {
            uiBusy.hidesWhenStopped = true
            if on {
                uiBusy.startAnimating()
            }
            else {
                uiBusy.stopAnimating()
                uiBusy.hidden = true
            }
        }
        func RefreshStop() {
            Refreshing(false)
        }
    func EndedRefresh() -> Bool {
        if !uiBusy.isAnimating() && !doneReloading {
            self.navigationItem.setRightBarButtonItem(Refresh, animated: true)
            Refresh.tintColor = RefreshColor
            Refresh.enabled = true
            viewDidLoad()
            doneReloading = true
            return true
        }
        return false
    }

    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }

}

