//
//  LostInfoViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/23/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics
import CoreLocation

class LostInfoViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
        let uiBusy = UIActivityIndicatorView()
        var DirectionTime = String()
        var DirectionType: String = "None"
        var activePlace = 0
        var places = [Dictionary<String, String>()]
        
        @IBOutlet weak var Refresh: UIBarButtonItem!
        @IBOutlet weak var Directions: UIBarButtonItem!
        
        
        var manager: CLLocationManager!
        var mapsType = UISegmentedControl()
        var directionsType = UISegmentedControl()
        var doggie: lostDog?
        let coolColor  = UILabel()
        var DogNameLost = UILabel()
        var DogImageLost = UIImageView()
        var shareButton = UIButton(type: .System)
        var mapView = MKMapView()
        var scrollView = UIScrollView()
        //var image: UIImageView!
        
        var Information = UIView()
        var DogName = UILabel()
        var TrackerNumberLabel = UILabel()
        var TrackerNumber = UILabel()
        var TrackerNumberImage = UIImageView()
        var Displaying = UILabel()
        var Display = UILabel()
        var DisplayMilesWalkedLabel = UILabel()
        var DisplayMilesWalked = UILabel()
        var x = 1
        var y = 1
        var image = UIImage(named: "Expand")
        var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
        var doneReloading = true
        var steped: String = ""
        var Userlat = CLLocationDegrees()
        var Userlong = CLLocationDegrees()
        var DisplayMinutes = UILabel()
        var tint = UIColor()
        var DirectionLabel = UILabel()
        var blurBackGround  = UIBlurEffect(style: .Light)
        var blurView = UIVisualEffectView()
        var backgroundImage = UIImageView()
        var circleButton = UIButton()
        var callButton = UIButton()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            blurView.effect = blurBackGround
            tint = self.view.tintColor
            DogImageLost.image = (self.doggie?.photo)
            DogNameLost.text = (self.doggie?.name)
            DogName.text = "Dog Name"
            TrackerNumberLabel.text = "Lost Date"
            TrackerNumber.text = forecastAPIKeys
            Displaying.text = "Displaying"
            Display.text = LedDatas
            DisplayMilesWalkedLabel.text = "Display Miles Walked"
            coolColor.frame = CGRectMake(0, 0, self.view.frame.width, 50)
            coolColor.backgroundColor = UIColor.blueColor()
            self.view.addSubview(coolColor)
            self.view.sendSubviewToBack(coolColor)
            DogImageLost = UIImageView(frame: CGRect(x: 0, y: 450, width: self.view.bounds.width, height: self.view.bounds.width))
            self.view.translatesAutoresizingMaskIntoConstraints = true
            Information = UIView(frame: CGRect(x: 0, y: 450 + self.view.bounds.width, width: self.view.bounds.width, height: 150))
            DogName = UILabel(frame: CGRect(x: 63, y: 13, width: 116, height: 28))
            TrackerNumberLabel = UILabel(frame: CGRect(x: 8, y: 42, width: 171, height: 28))
            Displaying = UILabel(frame: CGRect(x: 65, y: 70, width: 114, height: 28))
            DisplayMilesWalkedLabel = UILabel(frame: CGRect(x: 75, y: 108, width: 160, height: 26))
            DisplayMilesWalked = UILabel(frame: CGRect(x: 327, y: 105, width: 114, height: 31))
            DisplayMilesWalked.text = doggie?.breed
            Display = UILabel(frame: CGRect(x: 155, y: 68, width: 114, height: 30))
            TrackerNumber = UILabel(frame: CGRect(x: 155, y: 40, width: 236, height: 28))
            TrackerNumberImage = UIImageView(frame: CGRect(x: 300, y: 40, width: 22, height: 22))
            TrackerNumberImage.image = image
            DogNameLost = UILabel(frame: CGRect(x: 205, y: 13, width: 101, height: 28))
            mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 600, height: 387))
            mapView.delegate = self
            mapsType = UISegmentedControl(items: ["Map", "Satilite", "Hybrid"])
            mapsType.selectedSegmentIndex = 0
            mapsType.frame = CGRect(x: self.mapView.frame.width/2 - self.mapsType.frame.width/2, y: 319.0, width: 244.0, height: 29.0)
            mapsType.center = CGPoint(x: self.view.center.x, y: 333.5)
            mapsType.layer.cornerRadius = 5.0  // Don't let background bleed
            mapsType.tintColor = tint
            mapsType.backgroundColor = UIColor.clearColor()
            mapsType.addTarget(self, action: #selector(LostViewController.MapType(_:)), forControlEvents: .ValueChanged)
            DirectionLabel = UILabel(frame: CGRect(x: 10, y: 30, width: 0, height: 0))
            DirectionLabel.text = "Directions"
            DirectionLabel.textColor = UIColor.orangeColor()
            directionsType = UISegmentedControl(items: ["Drive", "Walk", "Transit", "None"])
            directionsType.selectedSegmentIndex = 3
            directionsType.frame = CGRect(x: self.mapView.frame.width/2 - self.directionsType.frame.width/2, y: 175.0, width: 325.3, height: 29.0)
            directionsType.center = CGPoint(x: self.view.center.x - (1/2 * DisplayMinutes.frame.width), y: 109.5)
            DisplayMinutes = UILabel(frame: CGRect(x: 20, y: self.directionsType.frame.maxY + 10, width: 0, height: 0))
            DisplayMinutes.center = CGPoint(x: self.view.center.x, y: self.DisplayMinutes.center.y)
            DisplayMinutes.textColor = UIColor.orangeColor()
            directionsType.layer.cornerRadius = 5.0  // Don't let background bleed
            directionsType.tintColor = tint
            directionsType.backgroundColor = UIColor.clearColor()
            directionsType.addTarget(self, action: #selector(LostViewController.DirectionType(_:)), forControlEvents: .ValueChanged)
            //DogNameLost.frame = CGRectMake(200, 200, 200, 200)
            DogImageLost.setupForImageViewer()
            shareButton.frame = CGRectMake(13, 75, self.view.frame.width - 26 , 50)
            shareButton.tintColor = UIColor.cyanColor()
            shareButton.setTitle("Share", forState: UIControlState.Normal)
            shareButton.backgroundColor = UIColor.blueColor()
            shareButton.addTarget(self, action: #selector(LostViewController.shareButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            shareButton.layer.cornerRadius = 20
            shareButton.layer.masksToBounds = true
            DirectionLabel.center = CGPoint(x: self.view.center.x, y: (directionsType.frame.minY - shareButton.frame.maxY) / 2 + shareButton.frame.maxY)
            DirectionLabel.sizeToFit()
            circleButton.frame = CGRect(x: self.view.center.x - (1/2 * circleButton.frame.width), y: self.view.frame.height - (3/2 * circleButton.frame.height), width: 50, height: 50)
            circleButton.center = CGPoint(x: self.view.center.x / 2, y: self.view.frame.height - 100)
            circleButton.layer.masksToBounds = true
            circleButton.layer.cornerRadius = 25
            circleButton.setImage(UIImage(named: "Close"), forState: .Normal)
            circleButton.setImage(UIImage(named: "Expand"), forState: .Selected)
            circleButton.backgroundColor = UIColor.clearColor()
            circleButton.addTarget(self, action: #selector(self.addReminder(_:)), forControlEvents: .TouchUpInside)
            callButton.frame = CGRect(x: self.view.center.x - (1/2 * circleButton.frame.width), y: self.view.frame.height - (3/2 * circleButton.frame.height), width: 33, height: 33)
            callButton.center = CGPoint(x: 1.5 * (self.view.center.x), y: self.view.frame.height - 100)
            callButton.layer.masksToBounds = true
            callButton.layer.cornerRadius = 16.5
            callButton.setImage(UIImage(named: "Call"), forState: .Normal)
            callButton.setImage(UIImage(named: "Call"), forState: .Selected)
            callButton.backgroundColor = UIColor.clearColor()
            callButton.addTarget(self, action: #selector(self.call(_:)), forControlEvents: .TouchUpInside)
            
            let fullRotation = CGFloat(M_PI * 2)
            circleButton.transform = CGAffineTransformMakeRotation(1/8 * fullRotation)
            callButton.transform = CGAffineTransformMakeRotation(-1/4 * fullRotation)
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height))
            scrollView.backgroundColor = UIColor.whiteColor()
            scrollView.contentSize = CGSizeMake(self.view.frame.width, mapView.frame.height + DogImageLost.frame.height + Information.frame.height)
            scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            scrollView.delegate = self
            scrollView.scrollEnabled = true
            backgroundImage.image = doggie?.photo
            backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //setZoomScale()
            self.view.addSubview(backgroundImage)
            self.view.addSubview(blurView)
            self.view.addSubview(circleButton)
            self.view.addSubview(callButton)
            self.view.addSubview(scrollView)
            //scrollView.addSubview(image)
            scrollView.addSubview(DogImageLost)
            scrollView.addSubview(mapView)
            scrollView.addSubview(mapsType)
            scrollView.addSubview(Information)
            scrollView.addSubview(directionsType)
            scrollView.addSubview(DisplayMinutes)
            scrollView.addSubview(DirectionLabel)
            navigationItem.title = DogNameLost.text
            //scrollViewDidZoom(scrollView)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            Information.addSubview(DogNameLost)
            Information.addSubview(DogName)
            Information.addSubview(TrackerNumber)
            Information.addSubview(TrackerNumberLabel)
            Information.addSubview(Display)
            Information.addSubview(Displaying)
            Information.addSubview(DisplayMilesWalked)
            Information.addSubview(DisplayMilesWalkedLabel)
            Information.addSubview(TrackerNumberImage)
            //scrollView.addSubview(DogNameLost)
            //self.view.addSubview(DogImageLost)
            TrackerNumberImage.hidden = true
            //TrackerNumberImage.userInteractionEnabled = true
            //let tapImage = UITapGestureRecognizer(target: self, action: #selector(LostViewController.enlargeTrackerNumber(_:)))
            //TrackerNumberImage.addGestureRecognizer(tapImage)
            self.view.addSubview(shareButton)
            self.view.addSubview(circleButton)
            loadMap()
            backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                //NSTimer.scheduledTimerWithTimeInterval(5, target: Api(), selector: #selector(Api.lostReload), userInfo: nil, repeats: true)
                UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
            })
            
            // Do any additional setup after loading the view.
        }
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            /*if let location = locations.first {
             print("Found user's location: \(location)")
             }*/
            let userLocation:CLLocation = locations[0]
            Userlong = userLocation.coordinate.longitude
            Userlat = userLocation.coordinate.latitude
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func addReminder(sender: UIButton) {
            self.performSegueWithIdentifier("AddReminder", sender: self)
        }
        func call(sender: UIButton) {
            let busPhone  = "914-359-1066"
            if let url = NSURL(string: "tel://\(busPhone)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        func MapType(sender: UISegmentedControl) {
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
        func DirectionType(sender: UISegmentedControl) {
            switch directionsType.selectedSegmentIndex
            {
            case 0:
                DirectionType = "Automobile"
                Directions.enabled = true
                mapView.showsTraffic = true
            case 1:
                DirectionType = "Walking"
                Directions.enabled = true
                mapView.showsTraffic = true
            case 2:
                DirectionType = "Transit"
                Directions.enabled = true
                mapView.showsTraffic = true
            case 3:
                DirectionType = "None"
                Directions.enabled = false
                mapView.showsTraffic = false
            default:
                break
            }
            mapView.removeOverlays(self.mapView.overlays)
            mapView(mapView, viewForAnnotation: mapView.annotations[mapView.annotations.count - 1])
        }
        @IBAction func loadDirections(sender: AnyObject) {
            var appleMapsType = ""
            if DirectionType == "Automobile" {
                appleMapsType = "d"
            }
            else if DirectionType == "Walking" {
                appleMapsType = "w"
            }
            else {
                appleMapsType = "r"
            }
            let targetURL = NSURL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=\(appleMapsType)")!
            UIApplication.sharedApplication().openURL(targetURL)
        }
    func findDog(lostDate: NSDate) -> lostDog? {
        for dog in LostDogs {
            if dog.lostDate == lostDate {
                return dog
            }
        }
        return nil
    }
        
        func loadMap() {
            let longed = longitude
            let lated = latitude
            self.view.addGestureRecognizer(self.revealViewController()!.panGestureRecognizer()!)
            //let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
            //uilpgr.minimumPressDuration = 1.0
            //mapView.addGestureRecognizer(uilpgr)
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
                    let latitude: CLLocationDegrees = lated
                    let longitude: CLLocationDegrees = longed
                    let latDelta: CLLocationDegrees = 0.01
                    let lonDelta: CLLocationDegrees = 0.01
                    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    mapView.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    print(doggie)
                    annotation.coordinate = doggie!.location!.coordinate
                    annotation.title = places[activePlace]["name"]
                    mapView.addAnnotation(annotation)
                    
                    
                }
            }
        }
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "loadMap"
            var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            let AnnotationDog = UIImageView.init(image: self.doggie?.photo)
            if annotation is MKUserLocation {
                return nil
            }
            else if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                view?.leftCalloutAccessoryView = AnnotationDog
                view?.animatesDrop = true
                AnnotationDog.frame = CGRectMake(0, 0, view!.bounds.height + 28, view!.bounds.height + 10)
                AnnotationDog.contentMode = .ScaleAspectFill
                //view?.sizeToFit()
            } else {
                view?.annotation = annotation
            }
            let destination = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
            let request = MKDirectionsRequest()
            //let UserLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Userlat, longitude: Userlong), addressDictionary: nil)
            let UserLocation = MKMapItem.mapItemForCurrentLocation()
            //request.source = MKMapItem(placemark: UserLocation)
            request.source = UserLocation
            request.destination = MKMapItem(placemark: destination)
            request.requestsAlternateRoutes = false
            switch DirectionType{
            case "Automobile":
                request.transportType = MKDirectionsTransportType.Automobile
            case "Walking":
                request.transportType = MKDirectionsTransportType.Walking
            case "Transit":
                request.transportType = MKDirectionsTransportType.Transit
            case "None":
                DisplayMinutes.text = ""
                return view
            default:
                request.transportType = MKDirectionsTransportType.Automobile
            }
            
            let directions = MKDirections(request: request)
            directions.calculateDirectionsWithCompletionHandler ({ (response, error) in
                if error != nil {
                    // Handle error
                    if self.DirectionType != "Automobile" {
                        var realError = ""
                        switch Int(error!.code) {
                        case 1:
                            realError = "Unknown Error"
                            self.notifyUser("Directions Error", message: realError + "\n Switching to Automobile directions")
                        case 2:
                            realError = "Server Failure"
                            self.notifyUser("Directions Error", message: realError + "\n Switching to Automobile directions")
                        case 3:
                            self.reloadDirections()
                        case 4:
                            self.reloadDirections()
                        case 5:
                            realError = "Could not calculate Directions"
                            self.notifyUser("Directions Error", message: realError + "\n Switching to Automobile directions")
                        default:
                            self.notifyUser("Directions Error", message: String(error) + "\n Switching to Automobile directions")
                        }
                        self.DirectionType = "Automobile"
                        self.directionsType.selectedSegmentIndex = 0
                        self.reloadDirections()
                    }
                    else {
                        self.notifyUser("Directions Error", message: String(error))
                    }
                } else {
                    self.showRoute(response!)
                    self.getTravelTime(annotation)
                }
                
            })
            return view
        }
        func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                performSegueWithIdentifier("DogsInfoLocation", sender: self)
            }
        }
        func mapView(mapView: MKMapView, rendererForOverlay
            overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = tint
            renderer.lineWidth = 4.0
            return renderer
        }
        func showRoute(response: MKDirectionsResponse) {
            for route in response.routes {
                mapView.addOverlay(route.polyline,
                                   level: MKOverlayLevel.AboveRoads)
                for step in route.steps {
                    steped += "\n" + step.instructions
                    
                }
            }
            let Steps = UILabel(frame: CGRect(x: 0, y: self.view.frame.width + 525, width: self.view.frame.width, height: 0))
            if Steps.text == nil {
                Steps.text = " "
            }
            
            Steps.font = UIFont(name: "Chalkduster", size: 12.5)
            Steps.adjustsFontSizeToFitWidth = true
            Steps.textAlignment = NSTextAlignment.Center
            Steps.highlightedTextColor = UIColor.orangeColor()
            Steps.highlighted = true
            Steps.textColor = tint
            Steps.lineBreakMode = .ByWordWrapping
            Steps.numberOfLines = 0
            Steps.text = steped
            Steps.sizeToFit()
            scrollView.addSubview(Steps)
            scrollView.contentSize = CGSizeMake(self.view.frame.width, mapView.frame.height + DogImageLost.frame.height + Information.frame.height + Steps.frame.height)
        }
        func reloadDirections () {
            mapView(mapView, viewForAnnotation: mapView.annotations[mapView.annotations.count - 2])
        }
        /*func longPress(gestureRecognizer: UIGestureRecognizer) {
         
         if gestureRecognizer.state == UIGestureRecognizerState.Began {
         let touchPoint = gestureRecognizer.locationInView(self.mapView)
         let newCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
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
         
         self.mapView.addAnnotation(annotation)
         
         self.places.append(["name":title, "lat":"\(newCoordinate.latitude)", "lon":"\(newCoordinate.longitude)"])
         }
         
         })
         }
         }*/
        var RefreshColor: UIColor?
        
        @IBAction func refreshData() {
            if let dog = findDog(doggie!.lostDate!) {
                doggie = dog
            }
    }
        
        func getTravelTime(annotation: MKAnnotation) {
            let destination = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
            let request = MKDirectionsRequest()
            //let UserLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Userlat, longitude: Userlong), addressDictionary: nil)
            let UserLocation = MKMapItem.mapItemForCurrentLocation()
            //request.source = MKMapItem(placemark: UserLocation)
            request.source = UserLocation
            request.destination = MKMapItem(placemark: destination)
            request.requestsAlternateRoutes = false
            switch DirectionType{
            case "Automobile":
                request.transportType = MKDirectionsTransportType.Automobile
            case "Walking":
                request.transportType = MKDirectionsTransportType.Walking
            case "Transit":
                request.transportType = MKDirectionsTransportType.Transit
            default:
                request.transportType = MKDirectionsTransportType.Automobile
            }
            
            
            let directions = MKDirections(request: request)
            directions.calculateETAWithCompletionHandler ({ (response: MKETAResponse?, error: NSError?) in
                if error == nil {
                    var TravelTime: UInt = UInt(response!.expectedTravelTime)
                    TravelTime = TravelTime/60
                    let TravelTimeH: UInt = TravelTime/60
                    TravelTime = TravelTime - (TravelTimeH * 60)
                    if TravelTimeH != 0 {
                        self.DirectionTime = "Travel Time: " + String(TravelTimeH) + " Hours " + String(TravelTime) + " Minutes"
                        self.DisplayMinutes.text = self.DirectionTime
                        self.DisplayMinutes.center = CGPoint(x: self.view.center.x, y: self.DisplayMinutes.center.y)
                    }
                    else {
                        self.DirectionTime = "Travel Time: " + String(TravelTime) + " Minutes"
                        self.DisplayMinutes.text = self.DirectionTime
                        self.DisplayMinutes.center = CGPoint(x: self.view.center.x, y: self.DisplayMinutes.center.y)
                    }
                    self.DisplayMinutes.sizeToFit()
                    self.DisplayMinutes.center = CGPoint(x: self.view.center.x, y: self.DisplayMinutes.center.y)
                }
                else {
                    self.notifyUser("Error Estimating Travel Time", message: String(error))
                    self.DirectionTime = ""
                    self.DisplayMinutes.text = ""
                }
            })
            
        }
        func shareButtonTapped(sender: AnyObject) {
            let shareName: String = self.DogNameLost.text!
            let shareImg: UIImage = self.DogImageLost.image!
            let shareItems: Array = [shareName, shareImg]
            let shareSheet = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            self.presentViewController(shareSheet, animated: true, completion: nil)
        }
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        override func viewDidAppear(animated: Bool) {
            //UIView.animateWithDuration(1.0) { () -> Void in
            //self.DogImageLost.center.y = self.view.center.y
            //self.DogNameLost.center.y = self.view.center.y
            //}
            DogImageLost.image = (self.doggie?.photo)
            DogNameLost.text = (self.doggie?.name)
            backgroundImage.image = doggie?.photo
            DogImageLost.image = (self.doggie?.photo)
            DogNameLost.text = (self.doggie?.name)
            DogName.text = "Dog Name"
            TrackerNumberLabel.text = "Lost Date"
            TrackerNumber.text = key
            Displaying.text = "Displaying"
            Display.text = LedDatas
            DisplayMilesWalkedLabel.text = "Display Miles Walked"
            DogImageLost.frame = CGRectMake(0, 387, self.view.bounds.width, self.view.bounds.width)
            Information.frame = CGRectMake(0, 387 + self.view.bounds.width, self.view.bounds.width, 150)
            DogName.frame = CGRectMake(63, 13, 116, 28)
            TrackerNumberLabel.frame = CGRectMake(8, 42, 171, 28)
            Displaying.frame = CGRectMake(65, 70, 114, 28)
            DisplayMilesWalkedLabel.frame = CGRectMake(105, 108, 170, 26)
            DisplayMilesWalked.frame = CGRectMake(305, 105, 51, 31)
            Display.frame = CGRectMake(205, 68, 150, 30)
            TrackerNumber.frame = CGRectMake(205, 40, 150, 28)
            TrackerNumber.adjustsFontSizeToFitWidth = true
            DogNameLost.frame = CGRectMake(205, 13, 101, 28)
            scrollView = UIScrollView(frame: CGRectMake(0, 64, self.view.bounds.width, self.view.bounds.height - 64))
            scrollView.backgroundColor = UIColor.whiteColor()
            scrollView.contentSize = CGSizeMake(self.view.bounds.width, mapView.frame.height + DogImageLost.frame.height + Information.frame.height + 23)
            //scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            scrollView.delegate = self
            scrollView.scrollEnabled = true
            //setZoomScale()
            let blurEffects = UIBlurEffect(style: .Light)
            let textBoxBlur = UIVisualEffectView(effect: blurEffects)
            textBoxBlur.layer.cornerRadius = 5
            textBoxBlur.layer.masksToBounds = true
            textBoxBlur.frame = Display.frame
            self.view.addSubview(backgroundImage)
            self.view.addSubview(blurView)
            view.addSubview(scrollView)
            scrollView.backgroundColor = UIColor.clearColor()
            //scrollView.addSubview(image)
            scrollView.addSubview(DogImageLost)
            scrollView.addSubview(mapView)
            scrollView.addSubview(mapsType)
            scrollView.addSubview(directionsType)
            scrollView.addSubview(DisplayMinutes)
            scrollView.addSubview(DirectionLabel)
            scrollView.addSubview(Information)
            navigationItem.title = DogNameLost.text
            Information.addSubview(DogNameLost)
            Information.addSubview(DogName)
            Information.addSubview(TrackerNumber)
            Information.addSubview(TrackerNumberLabel)
            Information.addSubview(textBoxBlur)
            Information.addSubview(Display)
            Display.backgroundColor = UIColor.clearColor()
            Information.addSubview(Displaying)
            Information.addSubview(DisplayMilesWalked)
            Information.addSubview(DisplayMilesWalkedLabel)
            Information.bringSubviewToFront(self.TrackerNumberImage)
            //self.view.addSubview(DogImageLost)
            self.view.addSubview(shareButton)
            self.view.addSubview(circleButton)
            circleButton.backgroundColor = UIColor.clearColor()
            let blurry = UIVisualEffectView(effect: blurEffects)
            blurry.frame = CGRectMake(circleButton.frame.minX + 16.5, circleButton.frame.minY + 16.5, 33, 33)
            blurry.center = circleButton.center
            blurry.layer.masksToBounds = true
            blurry.layer.cornerRadius = 16.5
            let blurries = UIVisualEffectView(effect: blurEffects)
            blurries.frame = CGRectMake(circleButton.frame.minX + 16.5, circleButton.frame.minY + 16.5, 33, 33)
            blurries.center = callButton.center
            blurries.layer.masksToBounds = true
            blurries.layer.cornerRadius = 16.5
            self.view.addSubview(blurries)
            self.view.addSubview(blurry)
            self.view.addSubview(callButton)
            self.view.bringSubviewToFront(circleButton)
            DirectionLabel.center = CGPoint(x: self.view.center.x, y: self.shareButton.frame.minY + 4)
            scrollView.bringSubviewToFront(directionsType)
            if Display.frame.width + Display.frame.minX > self.view.frame.width {
                Display.frame =  CGRectMake(self.view.frame.width - self.Display.frame.width - 10, self.Display.frame.minY, self.Display.frame.width, self.Display.frame.height)
                textBoxBlur.frame = Display.frame
                TrackerNumber.frame =  CGRectMake(self.view.frame.width - self.TrackerNumber.frame.width - 10, self.TrackerNumber.frame.minY, self.TrackerNumber.frame.width, self.TrackerNumber.frame.height)
                DogNameLost.frame =  CGRectMake(self.Display.frame.minX, self.DogNameLost.frame.minY, self.DogNameLost.frame.width, self.DogNameLost.frame.height)
                DisplayMilesWalked.frame =  CGRectMake(self.view.frame.width - self.DisplayMilesWalked.frame.width - 10, self.DisplayMilesWalked.frame.minY, self.DisplayMilesWalked.frame.width, self.DisplayMilesWalked.frame.height)
                DisplayMilesWalkedLabel.frame =  CGRectMake(self.DisplayMilesWalked.frame.minX - self.DisplayMilesWalkedLabel.frame.width - 10, self.DisplayMilesWalkedLabel.frame.minY, self.DisplayMilesWalkedLabel.frame.width, self.DisplayMilesWalkedLabel.frame.height)
            }
        }
        
        func enlargeTrackerNumber(sender: UITapGestureRecognizer) {
            if y == 1 {
                Information.bringSubviewToFront(self.TrackerNumber)
                Information.bringSubviewToFront(self.TrackerNumberImage)
                let duration = 2.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
                let fullRotation = CGFloat(M_PI * 2)
                TrackerNumberLabel.alpha = 1.0
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                    
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                        
                        self.TrackerNumber.adjustsFontSizeToFitWidth = true
                        // start at 0.00s (5s × 0)
                        // duration 1.67s (5s × 1/3)
                        // end at   1.67s (0.00s + 1.67s)
                        self.TrackerNumberImage.transform = CGAffineTransformMakeRotation(1/8 * fullRotation)
                        
                        self.TrackerNumber.frame = CGRectMake(0, self.TrackerNumber.frame.origin.y , self.view.bounds.width, self.TrackerNumberLabel.frame.height + 10)
                        
                        
                        
                        
                        //let images = UIImage(named: "Close")
                        //TrackerNumberImage.image = images
                    })
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                        self.TrackerNumberLabel.alpha = 0.0
                    })
                    }, completion: {finshed in
                        
                })
                y = 0
            }
            else if y == 0 {
                Information.bringSubviewToFront(self.TrackerNumber)
                Information.bringSubviewToFront(self.TrackerNumberImage)
                let duration = 2.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
                let fullRotation = CGFloat(M_PI * 2)
                TrackerNumberLabel.alpha = 0.0
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                    
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                        
                        
                        // start at 0.00s (5s × 0)
                        // duration 1.67s (5s × 1/3)
                        // end at   1.67s (0.00s + 1.67s)
                        self.TrackerNumberImage.transform = CGAffineTransformMakeRotation(0 * fullRotation)
                        
                        if self.view.frame.width == 320.0 {
                            self.TrackerNumber.frame =  CGRectMake(self.view.frame.width - 150 - 10, self.TrackerNumber.frame.minY, 150, self.TrackerNumber.frame.height)
                        }
                        else {
                            self.TrackerNumber.frame = CGRect(x: 205, y: 40, width: 150, height: 28)
                        }
                        self.TrackerNumber.adjustsFontSizeToFitWidth = true
                        
                        
                        
                        
                        //let images = UIImage(named: "Close")
                        //TrackerNumberImage.image = images
                    })
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                        self.TrackerNumberLabel.alpha = 1.0
                    })
                    }, completion: {finshed in
                        
                })
                
                y = 1
                
            }
        }
        func EndedRefresh() -> Bool {
            if !uiBusy.isAnimating() && !doneReloading {
                self.navigationItem.setRightBarButtonItem(Refresh, animated: true)
                Refresh.tintColor = RefreshColor
                Refresh.enabled = true
                loadMap()
                doneReloading = true
                return true
            }
            return false
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
        
        /*func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
         return image
         }
         func setZoomScale() {
         let imageViewSize = image.bounds.size
         let scrollViewSize = scrollView.bounds.size
         let widthScale = scrollViewSize.width / imageViewSize.width
         let heightScale = scrollViewSize.height / imageViewSize.height
         
         scrollView.minimumZoomScale = min(widthScale, heightScale)
         scrollView.zoomScale = 1.0
         }
         override func viewWillLayoutSubviews() {
         setZoomScale()
         }
         func scrollViewDidZoom(scrollView: UIScrollView) {
         let imageViewSize = image.frame.size
         let scrollViewSize = scrollView.bounds.size
         
         let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
         let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
         
         scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
         }*/
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "DogsLocation" {
                let DestViewController = segue.destinationViewController as! LostDogInformationViewController
                DestViewController.dogs = self.doggie
                DestViewController.TypeofDirections = self.directionsType.titleForSegmentAtIndex(self.directionsType.selectedSegmentIndex)!
                if self.DisplayMinutes.text != "" {
                    let traveltimed = self.DisplayMinutes.text?.startIndex.advancedBy(13)
                    DestViewController.traveltimes = DisplayMinutes.text?.substringFromIndex(traveltimed!)
                }
            }
        }
        func loadDogs() -> [dog]? {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
        }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    

