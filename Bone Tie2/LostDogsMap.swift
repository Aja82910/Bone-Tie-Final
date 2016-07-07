//
//  LostDogs.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/15/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit

class LostDogsMap: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var mapsType: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!

    var activePlace = 0
    var places = [Dictionary<String, String>()]
    var doneReloading = true
    var dogs = [lostDog]()
    var newLostAnnotations = [MKAnnotation]()
    
    @IBOutlet weak var Refresh: UIBarButtonItem!
    var uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var lostInfo: lostDog?
    
    var manager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        dogs = []
        self.navigationItem.title = "Lost Dogs"
        uiBusy.color = self.view.tintColor
        Open.image = UIImage(named: "Open")
        Open.title = ""
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        //uilpgr.minimumPressDuration = 1.0
        //mapViewView.addGestureRecognizer(uilpgr)
        dogs = FetchLost().loadAll(self).0!
        NSTimeZone.resetSystemTimeZone()
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
            mapView.showsUserLocation = true
            mapView.delegate = self
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
            var counting = 0
            while counting < mapView.annotations.count && mapView.annotations.count != 1{
                if mapView.annotations[counting].title! as String? == places[activePlace]["name"] {
                    mapView.removeAnnotation(mapView.annotations[counting])
                    break
                }
                counting += 1
            }
            
            if activePlace == -1 {
                manager.requestAlwaysAuthorization()
                manager.startUpdatingLocation()
            } else {
                //let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
                manager.requestAlwaysAuthorization()
                if let latitude: CLLocationDegrees = manager.location!.coordinate.latitude {
                    let longitude: CLLocationDegrees = manager.location!.coordinate.longitude
                    let latDelta: CLLocationDegrees = 0.01
                    let lonDelta: CLLocationDegrees = 0.01
                    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    mapView.setRegion(region, animated: true)
                }
                NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.updateLostDogAnnotations), userInfo: nil, repeats: true)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController = segue.destinationViewController as? LostInfoViewController
        print(lostInfo)
        DestViewController?.doggie = lostInfo
    }
    func updateLostDogAnnotations() -> Bool {
        dogs = FetchLost().loadAll(self).0!
        let error: NSError? = FetchLost().loadAll(self).1
        if error == nil {
            let annotations = NSArray(array: mapView.annotations)
            for dog in dogs {
                for annotation in mapView.annotations {
                    let subtitle: String!! = String!!(annotation.subtitle)
                    let lostDate = NSDateFormatter()
                    lostDate.dateStyle = .MediumStyle
                    lostDate.timeStyle = .MediumStyle
                    lostDate.timeZone = NSTimeZone.systemTimeZone()
                    if String(subtitle) == lostDate.stringFromDate(dog.lostDate!) {
                        print(mapView.annotations.count)
                        mapView.removeAnnotation(annotation)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = dog.location!.coordinate
                        annotation.title = dog.name
                        annotation.subtitle = lostDate.stringFromDate(dog.lostDate!)
                        self.mapView.addAnnotation(annotation)
                        self.mapView(self.mapView, viewForAnnotation: annotation)
                        break
                    } else if annotations.indexOfObject(annotation) == annotations.count - 1 && dogs.indexOf(dog) == dogs.count - 1 {
                        print(String(subtitle) == String(dog.lostDate!))
                        print(String!!(annotation.subtitle))
                        print(String(dog.lostDate!))
                        newLostAnnotations.append(annotation)
                        print(mapView.annotations.count)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = dog.location!.coordinate
                        annotation.title = dog.name
                        annotation.subtitle = lostDate.stringFromDate(dog.lostDate!)
                        self.mapView.addAnnotation(annotation)
                        self.mapView(self.mapView, viewForAnnotation: annotation)
                    }
                }
            }
            return true
        }
        return false
    }
    
    @IBAction func unwindTomapViewList(sender: UIStoryboardSegue) {
        //viewDidAppear(true)
    }
    /*func presentTurorial() {
     let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TutorialViews") as! AnnotationViewController
     viewController.alpha = 0.5
     //self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
     self.presentViewController(viewController, animated: false, completion: nil)
     }*/
    func findDog(annotation: MKAnnotation) -> lostDog? {
        let lostDate = NSDateFormatter()
        lostDate.dateStyle = .MediumStyle
        lostDate.timeStyle = .MediumStyle
        lostDate.timeZone = NSTimeZone.systemTimeZone()
        for dog in dogs {
            print(dog.photo)
            print(lostDate.stringFromDate(dog.lostDate!))
            print(String!!(annotation.subtitle))
            if lostDate.stringFromDate(dog.lostDate!) == String!!(annotation.subtitle) {
                return dog
            }
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Refreshing"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        var AnnotationDog: UIImageView?
        if let dog = findDog(annotation) {
            AnnotationDog = UIImageView.init(image: dog.photo)
            print(dog.photo)
            print(dog.name)
        } else {
            AnnotationDog = nil
        }
        if annotation is MKUserLocation {
            return nil
        }
        else if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            view?.leftCalloutAccessoryView = AnnotationDog
            if NSArray(array: newLostAnnotations).containsObject(annotation){
                view?.animatesDrop = true
            } else {
                view?.animatesDrop = false
            }
            if AnnotationDog != nil {
                AnnotationDog?.frame = CGRectMake(0, 0, view!.bounds.height + 28, view!.bounds.height + 10)
                AnnotationDog?.contentMode = .ScaleAspectFill
            }
            view?.sizeToFit()
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let dog = findDog(view.annotation!) {
                lostInfo = dog
            }
            performSegueWithIdentifier("LostDogsInfo", sender: self)
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first {
            print("Found user's location: \(location)")
        }*/
    }
    override func viewDidAppear(animated: Bool) {
        // Terms have been accepted, proceed as normal
        
        dogs = []
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
            mapView.showsUserLocation = true
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
            var counting = 0
            while counting < mapView.annotations.count && mapView.annotations.count != 1{
                if mapView.annotations[counting].title! as String? == places[activePlace]["name"] {
                    mapView.removeAnnotation(mapView.annotations[counting])
                    break
                }
                counting += 1
            }
            
            if activePlace == -1 {
                manager.requestAlwaysAuthorization()
                manager.startUpdatingLocation()
            } else {
                //let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
                for dog in dogs {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = dog.location!.coordinate
                    mapView.addAnnotation(annotation)
                    annotation.title = dog.name
                    annotation.subtitle = String(dog.lastUpdated)
                    mapView(mapView, viewForAnnotation: annotation)
                }
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func mapViewType(sender: UISegmentedControl) {
        switch mapsType.selectedSegmentIndex
        {
        case 0:
            self.mapView.mapType = MKMapType.Standard
        case 1:
            self.mapView.mapType = MKMapType.SatelliteFlyover
        case 2:
            self.mapView.mapType = MKMapType.HybridFlyover
        default:
            break
        }
    }
    
    
    /*func longPress(gestureRecognizer: UIGestureRecognizer) {
     
     if gestureRecognizer.state == UIGestureRecognizerState.Began {
     let touchPoint = gestureRecognizer.locationInView(self.mapView)
     let newCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
     let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
     
     CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
     
     if error != nil {
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
     
     self.mapView.addAnnotation(annotation)
     
     self.places.append(["name":title, "lat":"\(newCoordinate.latitude)", "lon":"\(newCoordinate.longitude)"])
     }
     
     })
     }
     }*/
    var RefreshColor: UIColor?
    @IBAction func refreshData() {
        Refreshing(true)
        doneReloading = false
        let request = updateLostDogAnnotations()
        RefreshColor = self.view.tintColor
        Refresh.tintColor = UIColor.clearColor()
        Refresh.enabled = false
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: uiBusy), Refresh], animated: true)
        if request != true {
                NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.updateLostDogAnnotations), userInfo: request == true, repeats: true)
             NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.EndedRefresh), userInfo: request == true, repeats: true)
        }
        else {
            Refreshing(false)
            EndedRefresh()
        }
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
            updateLostDogAnnotations()
            return true
        }
        return false
    }
}
