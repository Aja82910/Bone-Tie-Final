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
    var uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
            places.remove(at: 0)
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
                Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateLostDogAnnotations), userInfo: nil, repeats: true)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as? LostInfoViewController
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
                    let subtitle: String?! = String!!(annotation.subtitle!)
                    let lostDate = DateFormatter()
                    lostDate.dateStyle = .medium
                    lostDate.timeStyle = .medium
                    lostDate.timeZone = TimeZone.current
                    if String(describing: subtitle) == lostDate.string(from: dog.lostDate!) {
                        print(mapView.annotations.count)
                        mapView.removeAnnotation(annotation)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = dog.location!.coordinate
                        annotation.title = dog.name
                        annotation.subtitle = lostDate.string(from: dog.lostDate!)
                        self.mapView.addAnnotation(annotation)
                        self.mapView(self.mapView, viewFor: annotation)
                        break
                    } else if annotations.index(of: annotation) == annotations.count - 1 && dogs.index(of: dog) == dogs.count - 1 {
                        print(String(describing: subtitle) == String(describing: dog.lostDate!))
                        print(String!!(annotation.subtitle!))
                        print(String(describing: dog.lostDate!))
                        newLostAnnotations.append(annotation)
                        print(mapView.annotations.count)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = dog.location!.coordinate
                        annotation.title = dog.name
                        annotation.subtitle = lostDate.string(from: dog.lostDate!)
                        self.mapView.addAnnotation(annotation)
                        self.mapView(self.mapView, viewFor: annotation)
                    }
                }
            }
            return true
        }
        return false
    }
    
    @IBAction func unwindTomapViewList(_ sender: UIStoryboardSegue) {
        //viewDidAppear(true)
    }
    /*func presentTurorial() {
     let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TutorialViews") as! AnnotationViewController
     viewController.alpha = 0.5
     //self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
     self.presentViewController(viewController, animated: false, completion: nil)
     }*/
    func findDog(_ annotation: MKAnnotation) -> lostDog? {
        let lostDate = DateFormatter()
        lostDate.dateStyle = .medium
        lostDate.timeStyle = .medium
        lostDate.timeZone = TimeZone.current
        for dog in dogs {
            print(dog.photo)
            print(lostDate.string(from: dog.lostDate!))
            print(String!!(annotation.subtitle!))
            if lostDate.string(from: dog.lostDate!) == String!!(annotation.subtitle!) {
                return dog
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Refreshing"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
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
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view?.leftCalloutAccessoryView = AnnotationDog
            if NSArray(array: newLostAnnotations).contains(annotation){
                view?.animatesDrop = true
            } else {
                view?.animatesDrop = false
            }
            if AnnotationDog != nil {
                AnnotationDog?.frame = CGRect(x: 0, y: 0, width: view!.bounds.height + 28, height: view!.bounds.height + 10)
                AnnotationDog?.contentMode = .scaleAspectFill
            }
            view?.sizeToFit()
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let dog = findDog(view.annotation!) {
                lostInfo = dog
            }
            performSegue(withIdentifier: "LostDogsInfo", sender: self)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first {
            print("Found user's location: \(location)")
        }*/
    }
    override func viewDidAppear(_ animated: Bool) {
        // Terms have been accepted, proceed as normal
        
        dogs = []
        if places.count == 1 {
            places.remove(at: 0)
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
                    annotation.subtitle = String(describing: dog.lastUpdated)
                    mapView(mapView, viewFor: annotation)
                }
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func mapViewType(_ sender: UISegmentedControl) {
        switch mapsType.selectedSegmentIndex
        {
        case 0:
            self.mapView.mapType = MKMapType.standard
        case 1:
            self.mapView.mapType = MKMapType.satelliteFlyover
        case 2:
            self.mapView.mapType = MKMapType.hybridFlyover
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
        Refresh.tintColor = UIColor.clear
        Refresh.isEnabled = false
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: uiBusy), Refresh], animated: true)
        if request != true {
                Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateLostDogAnnotations), userInfo: request == true, repeats: true)
             Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.EndedRefresh), userInfo: request == true, repeats: true)
        }
        else {
            Refreshing(false)
            EndedRefresh()
        }
    }
    
    func Refreshing(_ on: Bool) {
        uiBusy.hidesWhenStopped = true
        if on {
            uiBusy.startAnimating()
        }
        else {
            uiBusy.stopAnimating()
            uiBusy.isHidden = true
        }
    }
    func RefreshStop() {
        Refreshing(false)
    }
    func EndedRefresh() -> Bool {
        if !uiBusy.isAnimating && !doneReloading {
            self.navigationItem.setRightBarButton(Refresh, animated: true)
            Refresh.tintColor = RefreshColor
            Refresh.isEnabled = true
            viewDidLoad()
            doneReloading = true
            updateLostDogAnnotations()
            return true
        }
        return false
    }
}
