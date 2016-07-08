//
//  AddReminders.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 4/30/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import AVFoundation
import Interpolate
import MapKit
import CoreLocation

var type = "Food"
var Medicine = ""

class AddReminders: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate/*, AVAudioPlayerDelegate*/ {
    var theReminders = [reminders]()
    var toolbar = UIToolbar()
    var lastValidZoomState = Bool()
    var geocoder = CLGeocoder()
    var selectedCoordinate: CLLocationCoordinate2D!
    var manager = CLLocationManager()
    var dogs: dog?
    var alarm: Alarm!
    var soundEffect: AVAudioPlayer!
    let path = NSBundle.mainBundle().pathForResource("Dog Bark.mp3", ofType: nil)
    let button = UIButton()
    var datePicker = UIDatePicker()
    var ReminderType = UIPickerView()
    let pickerData = ["Food", "Medicine"]
    let image = UIImage(named: "Food")
    let images = UIImage(named: "Medicine")
    var imageView = UIImageView()
    var imageViews = UIImageView()
    var medName = UITextField()
    var done = UILabel()
    var colorView = UIView()
    var foodColor: Interpolate?
    var repeatTime = UIButton()
    var repeatLocation = UIButton()
    var repeatMap = MKMapView()
    var repeatSlider = UISlider()
    var repeatRange = UILabel()
    var mapNone = true
    var timeNone = false
    var repeatMapReminder = false
    var noneMap = UIButton()
    var noneTime = UIButton()
    var mapOrTime = UISegmentedControl(items: ["Date", "Location"])
    var centerAnnotation = MKPointAnnotation()
    var centerAnnotationView = MKPinAnnotationView()
    var zoomToUser = Bool()
    var showUserTrackingButton = Bool()
    var doesDisplayPointAccuracyIndicators = Bool()
    var requiredPointAccuracy: CLLocationDistance = 0.0
    var selectedPlacemark: CLPlacemark?
    var zoomMapSize: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedReminders = loadReminders() {
            theReminders += savedReminders
        }
        centerAnnotationView = MKPinAnnotationView(annotation: centerAnnotation, reuseIdentifier: "centerAnnotationView")
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()

        /*foodColor  = Interpolate(from: UIColor.orangeColor(),
                          to: UIColor.blueColor(),
                          apply: { (color) in
                     self.button.titleLabel?.textColor = color
            })*/
        self.alarm = Alarm(hour: 23, minute: 39, {
            debugPrint("Alarm Triggered!")
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.snoozeButton), name: "ACTION_ONE_IDENTIFIER", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doneButton), name: "ACTION_TWO_IDENTIFIER", object: nil)
        done.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 19)
        done.text = "Reminder Set"
        done.font = UIFont(name: "Noteworthy-Light", size: 15)
        done.textAlignment = NSTextAlignment.Center
        done.textColor = UIColor.orangeColor()
        done.backgroundColor = UIColor.blueColor()
        done.alpha = 0.0
        self.view.addSubview(done)
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.alpha = 1.0
        imageViews = UIImageView(image: images)
        imageViews.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageViews.alpha = 0.0
        self.view.addSubview(imageView)
        self.view.addSubview(imageViews)
        medName.frame = CGRectMake(57, 300, 300, 30)
        medName.center = CGPoint(x: self.view.center.x, y: medName.center.y)
        medName.alpha = 0.0
        medName.delegate = self
        medName.borderStyle = UITextBorderStyle.RoundedRect
        medName.returnKeyType = UIReturnKeyType.Done
        medName.backgroundColor = UIColor.clearColor()
        medName.placeholder = "Medicine Name"
        colorView.frame = medName.frame
        colorView.center = medName.center
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 5
        colorView.backgroundColor = UIColor.orangeColor()
        colorView.alpha = 0.0
        medName.allowsEditingTextAttributes = true
        ReminderType.frame = CGRectMake(0, 55, self.view.frame.width, 100)
        ReminderType.delegate = self
        ReminderType.dataSource = self
        self.view.addSubview(ReminderType)
        view.bringSubviewToFront(ReminderType)
        
        datePicker.setValue(UIColor.blueColor(), forKeyPath: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePicker.frame = CGRectMake(0, 225, self.view.frame.width, 150)
        //datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(self.remindMe) , forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(datePicker)
        
        button.frame = CGRectMake(0, self.view.frame.height - 30, self.view.frame.width, 50)
        button.center = CGPoint(x: self.view.center.x, y: self.button.center.y)
        button.setTitle("Add Reminder", forState: .Normal)
        button.setTitle("Add Reminder", forState: .Selected)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.userInteractionEnabled = true
        //button.sizeToFit()
        button.addTarget(self, action: #selector(self.addReminder), forControlEvents: UIControlEvents.TouchUpInside)
        
        repeatTime.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: 100, height: 70)
        repeatTime.center = CGPoint(x: self.view.center.x, y: repeatTime.center.y)
        repeatTime.setTitle("Repeat At A time", forState: .Normal)
        repeatTime.setTitleColor(UIColor.blueColor(), forState: .Normal)
        repeatTime.userInteractionEnabled = true
        repeatTime.layer.borderWidth = 1.0
        repeatTime.layer.borderColor = UIColor.blueColor().CGColor
        
        repeatLocation.frame = CGRectMake(0, self.view.frame.height - 100, 200, 70)
        repeatLocation.center = CGPoint(x: self.view.center.x, y: repeatTime.center.y)
        repeatLocation.setTitle("Repeat At A time", forState: .Normal)
        repeatLocation.setTitleColor(UIColor.blueColor(), forState: .Normal)
        repeatLocation.userInteractionEnabled = true
        repeatLocation.layer.borderWidth = 1.0
        repeatLocation.layer.borderColor = UIColor.blueColor().CGColor
        
        repeatSlider.frame = CGRectMake(10, 365, self.view.frame.width - 100, 31)
        repeatSlider.continuous = true
        repeatSlider.maximumValue = 10000
        repeatSlider.minimumValue = 100
        repeatSlider.value = 1000
        repeatSlider.hidden = true
        repeatSlider.addTarget(self, action: #selector(self.sliderChanged), forControlEvents: .ValueChanged)
        
        repeatRange.frame = CGRectMake(self.view.frame.width - 85, 365, 75, 31)
        repeatRange.text = "1 KM"
        repeatRange.textColor = self.view.tintColor
        repeatRange.textAlignment = .Center
        repeatRange.hidden = true
        
        repeatMap.frame = CGRectMake(10, 210, self.view.frame.width - 50, 200)
        repeatMap.setRegion(MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000), animated: true)
        repeatMap.hidden = true
        repeatMap.delegate = self
        repeatMap.showsUserLocation = true
        centerAnnotation.coordinate = repeatMap.centerCoordinate
        repeatMap.addAnnotation(centerAnnotation)
        repeatMap.addSubview(self.centerAnnotationView)
        
        noneMap.frame = CGRectMake(0, 215, 50, 30)
        noneMap.setTitle("None", forState: .Normal)
        noneMap.center = CGPoint(x: self.view.center.x, y: noneMap.center.y)
        noneMap.addTarget(self, action: #selector(self.noneForMap), forControlEvents: .TouchUpInside)
        noneMap.hidden = true
        
        noneTime.frame = CGRectMake(0, 390, 50, 30)
        noneTime.setTitle("None", forState: .Normal)
        noneTime.center = CGPoint(x: self.view.center.x, y: noneTime.center.y)
        
        mapOrTime.frame = CGRectMake(10, 200, self.view.frame.width - 100, 29)
        mapOrTime.addTarget(self, action: #selector(self.changeAlertType), forControlEvents: .ValueChanged)
        
        self.view.addSubview(button)
        self.view.addSubview(datePicker)
        self.view.addSubview(ReminderType)
        self.view.addSubview(done)
        self.view.addSubview(colorView)
        self.view.addSubview(medName)
        self.view.addSubview(repeatLocation)
        self.view.addSubview(repeatTime)
        self.view.addSubview(repeatMap)
        self.view.addSubview(repeatRange)
        self.view.addSubview(repeatSlider)
        self.view.addSubview(mapOrTime)
        self.view.addSubview(noneMap)
        self.view.addSubview(noneTime)
    }

    
    
    func userCoordinate() -> CLLocationCoordinate2D {
        return self.repeatMap.userLocation.coordinate
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.moveMapAnnotationToCoordinate(self.repeatMap.centerCoordinate)
        self.initToolbarAndAdd()
    }
    let PIN_WIDTH_OFFSET: CGFloat = 7.75
    let PIN_HEIGHT_OFFSET: CGFloat = 5
    
    func initToolbarAndAdd() {
        self.toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)
        self.repeatMap.addSubview(self.toolbar)
    }
    // These are the constants need to offset distance between the lower left corner of
    // the annotaion view and the head of the pin
    
    func moveMapAnnotationToCoordinate(coordinate: CLLocationCoordinate2D) {
        let mapViewPoint: CGPoint = self.repeatMap.convertCoordinate(coordinate, toPointToView: self.repeatMap)
        // Offset the view from to account for distance from the lower left corner to the pin head
        let xoffset: CGFloat = CGRectGetMidX(self.centerAnnotationView.bounds) - PIN_WIDTH_OFFSET
        let yoffset: CGFloat = -CGRectGetMidY(self.centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET
        self.centerAnnotationView.center = CGPointMake(mapViewPoint.x + xoffset, mapViewPoint.y + yoffset)
    }
    
    func changeRegionToCoordinate(coordinate: CLLocationCoordinate2D, withSize size: Int) {
        let newRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, Double(size), Double(size))
        self.repeatMap.setRegion(newRegion, animated: true)
    }
    
    func metersPerViewPoint() -> CLLocationDistance {
        let comparisonRect: CGRect = CGRectMake(self.repeatMap.center.x, self.repeatMap.center.y, 1, 1)
        let comparisonRegion: MKCoordinateRegion = self.repeatMap.convertRect(comparisonRect, toRegionFromView: self.repeatMap)
        // The output below is limited by 4 KB.
        // Upgrade your plan to remove this limitation.
        
        let comparisonCoordinate1: CLLocationCoordinate2D = CLLocationCoordinate2DMake(comparisonRegion.center.latitude - comparisonRegion.span.latitudeDelta, comparisonRegion.center.longitude - comparisonRegion.span.longitudeDelta)
        let comparisonCoordinate2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(comparisonRegion.center.latitude + comparisonRegion.span.latitudeDelta, comparisonRegion.center.longitude + comparisonRegion.span.longitudeDelta)
        let sizeInMeters: CLLocationDistance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(comparisonCoordinate1), MKMapPointForCoordinate(comparisonCoordinate2))
        return sizeInMeters
    }
        func mapIsAtValidZoomScale() -> Bool {
                return self.metersPerViewPoint() <= self.requiredPointAccuracy
        }
        let INDICATOR_BORDER_WIDTH: CGFloat = 5
        func updatePointAccuracyIndicators() {
            if self.doesDisplayPointAccuracyIndicators && self.requiredPointAccuracy > 0 {
                if self.mapIsAtValidZoomScale() {
                    self.repeatMap.layer.borderColor = UIColor.greenColor().CGColor
                    self.repeatMap.layer.borderWidth = INDICATOR_BORDER_WIDTH
                }
                else {
                    self.repeatMap.layer.borderColor = UIColor.redColor().CGColor
                    self.repeatMap.layer.borderWidth = INDICATOR_BORDER_WIDTH
                }
            }
            else {
                self.repeatMap.layer.borderWidth = 0
            }
        }
        
        func locationForCoordinate(coordinate: CLLocationCoordinate2D) -> CLLocation {
            let location: CLLocation = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: NSDate())
            return location
        }
        
        
        func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
            self.changeRegionToCoordinate(userLocation.coordinate, withSize: self.zoomMapSize)
            self.zoomToUser = false;
        }
    func sliderChanged() {
        if repeatSlider.value <= 1000 {
            repeatRange.text = String(Int(repeatSlider.value)) + " M"
            repeatSlider.value = Float(Int(repeatSlider.value))
        } else {
            repeatRange.text = String(Double(round(repeatSlider.value / 100)) / 10) + " KM"
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first {
         print("Found user's location: \(location)")
         }*/
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        repeatMap.removeAnnotation(centerAnnotation)
        centerAnnotation.coordinate = repeatMap.centerCoordinate
        //repeatMap.addAnnotation(centerAnnotation)
        print("the")
    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerAnnotation.coordinate = repeatMap.centerCoordinate
        repeatMap.addAnnotation(centerAnnotation)
        let currentZoomStateValid: Bool = self.mapIsAtValidZoomScale()
        if self.lastValidZoomState != currentZoomStateValid {
            self.lastValidZoomState = currentZoomStateValid
            if self.doesDisplayPointAccuracyIndicators && self.requiredPointAccuracy > 0 {
                self.updatePointAccuracyIndicators()
            }
        }
        // If the center coordinate has changed, update values
        if (self.centerAnnotation.coordinate.latitude) != (self.repeatMap.centerCoordinate.latitude) || (self.centerAnnotation.coordinate.longitude != (self.repeatMap.centerCoordinate.longitude)) {
            
            
            centerAnnotation.coordinate = mapView.centerCoordinate
            self.selectedPlacemark = nil;
            
            self.moveMapAnnotationToCoordinate(mapView.centerCoordinate)
            
            // If the current zoom state is valid update selected values
        }

        print("in")
    }
    func changeAlertType() {
        switch mapOrTime.selectedSegmentIndex {
            case 0:
                datePicker.hidden = false
                noneTime.hidden = false
                repeatMap.hidden = true
                repeatRange.hidden = true
                repeatSlider.hidden = true
                noneMap.hidden = true
            default:
                datePicker.hidden = true
                noneTime.hidden = true
                repeatMap.hidden = false
                repeatRange.hidden = false
                repeatSlider.hidden = false
                noneMap.hidden = false
        }
    }
    func noneForMap() {
        if !timeNone {
            repeatSlider.frame = CGRectMake(10, 365, self.view.frame.width - 100, 31)
            repeatSlider.continuous = true
            repeatSlider.maximumValue = 10000
            repeatSlider.minimumValue = 100
            repeatSlider.value = 100
    
            repeatRange.frame = CGRectMake(self.view.frame.width - 85, 365, 75, 31)
            repeatRange.text = "1 KM"
            repeatRange.textColor = self.view.tintColor
            repeatRange.textAlignment = .Center
    
            repeatMap.frame = CGRectMake(10, 200, self.view.frame.width - 50, 200)
            repeatMap.setRegion(MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000), animated: true)
            mapNone = true
        } else {
            let alert = UIAlertController(title: "Cannot set map location to none", message: "When there is no given notification time, the location cannot be none", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
        }
    }
    func noneForTime() {
        if !mapNone {
            datePicker.date = NSDate()
            timeNone = true
        } else {
            let alert = UIAlertController(title: "Cannot set time to none", message: "When there is no given notification location, the time cannot be none", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == 0 {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.blueColor()])
        }
        else {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.orangeColor()])
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Food" {
            let duration = 2.0
            let delay = 0.0
            let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
            //foodColor?.animate(duration: 2.0)
            UIView.transitionWithView(self.button, duration: 2.0, options: .AllowAnimatedContent, animations: {
                self.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                self.datePicker.setValue(UIColor.blueColor(), forKeyPath: "textColor")
                }, completion: nil)
            UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                // each keyframe needs to be added here
                // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                    self.imageView.alpha = 1.0
                    self.imageViews.alpha = 0.0
                    self.datePicker.frame = CGRectMake(0, 275, self.view.frame.width, 150)
                    //self.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                    //self.button.setTitleColor(UIColor.blueColor(), forState: .Selected)
                    self.button.tintColor = UIColor.orangeColor()
                    self.medName.alpha = 0.0
                    self.colorView.alpha = 0.0
                    print("in")
                    
                    
                })
                }, completion: { finshed in
                    self.datePicker.datePickerMode = .CountDownTimer
                    self.datePicker.datePickerMode = .DateAndTime
            })
            type = "Food"
            view.bringSubviewToFront(ReminderType)
            view.bringSubviewToFront(datePicker)
            view.bringSubviewToFront(button)
        }
        else {
            let duration = 2.0
            let delay = 0.0
            let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
            self.datePicker.setValue(UIColor.orangeColor(), forKeyPath: "textColor")
            self.datePicker.datePickerMode = .CountDownTimer
            self.datePicker.datePickerMode = .DateAndTime
            UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                // each keyframe needs to be added here
                // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 2, animations: { () -> Void in
                    self.imageView.alpha = 0.0
                    self.imageViews.alpha = 1.0
                    self.medName.alpha = 1.0
                    self.colorView.alpha = 0.3
                    self.datePicker.frame = CGRectMake(0, 350, self.view.frame.width, 150)
                    self.button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
                    self.button.setTitleColor(UIColor.orangeColor(), forState: .Selected)
                    self.datePicker.tintColor = UIColor.blueColor()
                    self.view.bringSubviewToFront(self.button)
                    self.view.bringSubviewToFront(self.datePicker)
                    self.view.addSubview(self.datePicker)
                    self.view.addSubview(self.ReminderType)
                    self.view.addSubview(self.medName)
                })
                }, completion: { finshed in
            })

            view.bringSubviewToFront(ReminderType)
            view.bringSubviewToFront(datePicker)
            view.bringSubviewToFront(button)
            type = "Medicine"
        }
    }
    func remindMe () {
        let (hour, minute) = components(self.datePicker.date)
        self.alarm.hour = hour
        self.alarm.minute = minute
    }
    func components (date: NSDate) -> (Int, Int) {
        let flags = NSCalendarUnit.Hour.union(NSCalendarUnit.Minute)
        let comps = NSCalendar.currentCalendar().components(flags, fromDate: date)
        return (comps.hour, comps.minute)
    }
    func snoozeButton() {
        
    }
    func doneButton() {
    }
    func notification(message: String) {
        let ac = UIAlertController(title: "What's that Breed?", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    func addReminder() {
        self.alarm.turnOn()
        let now = NSDate()
        let alarmTime = datePicker.date
        let calendar = NSCalendar.currentCalendar()
        let dayCalendarUnit: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
        let alarmTimeDifference = calendar.components(
            dayCalendarUnit,
            fromDate: now,
            toDate:  alarmTime,
            options:  [])
        let secondsFromNow: NSTimeInterval = (Double(alarmTimeDifference.second)+Double(alarmTimeDifference.minute*60)+Double(alarmTimeDifference.hour*3600)+Double(alarmTimeDifference.day*86400))
        if self.alarm.isOn  {
            let userInfo = ["url": "www.mobiwise.co"]
            if ReminderType.selectedRowInComponent(0) == 0 {
                let message = "Don't forget to feed \(dogs?.name)"
                //let center = repeatMap.centerCoordinate
                //let distance: CLLocationDistance = CLLocationDistance(Double(repeatSlider.value))
                let region: CLCircularRegion? = nil//CLCircularRegion(center: center, radius: distance, identifier: "Notification Region")
                theReminders.append(reminders(reminderDog: dogs, name: nil, photo: dogs?.photo, repeatType: nil, repeatTime: nil, created: NSDate(), firstLaunchTime: datePicker.date, location: nil, range: nil, type: "Food", stillRepeating: false, notification: LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey("mobiwise", title: "Food", message: message, seconds: secondsFromNow, userInfo: userInfo, theDog: dogs, theRegion: region, soundName: nil, theCalenderInterval: nil, theDates: nil, regionTriggersOnce: false), id: getID())!)
                print(UIApplication.sharedApplication().scheduledLocalNotifications)
                saveReminders()
                let url = NSURL(fileURLWithPath: path!)
                do {
                    let sound = try AVAudioPlayer(contentsOfURL: url)
                    soundEffect = sound
                    sound.play()
                } catch {
                    //no file found
                }
                let duration = 10.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
                done.backgroundColor = UIColor.blueColor()
                done.textColor = UIColor.orangeColor()
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 1.0
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 0.0
                    })
                    }, completion: { finshed in
                        
                })
            }
            if ReminderType.selectedRowInComponent(0) == 1 {
                if medName.text! == "" {
                    Medicine = "medicine"
                }
                else {
                    Medicine = medName.text!
                }
                let message = "Don't forget to give \(Medicine) to \(dogs?.name)"
                let center = repeatMap.centerCoordinate
                let distance: CLLocationDistance = CLLocationDistance(Double(repeatSlider.value))
                let region = CLCircularRegion(center: center, radius: distance, identifier: "Notification Region")
                LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey("mobiwise", title: "Medicine", message: message, seconds: secondsFromNow, userInfo: userInfo, theDog: dogs, theRegion: region, soundName: nil, theCalenderInterval: nil, theDates: nil, regionTriggersOnce: false)
                let url = NSURL(fileURLWithPath: path!)
                do {
                    let sound = try AVAudioPlayer(contentsOfURL: url)
                    soundEffect = sound
                    sound.play()
                } catch {
                    //no file found
                }
                /*if soundEffect != nil {
                    soundEffect.stop()
                    soundEffect = nil
                }*/
                let duration = 10.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
                done.backgroundColor = UIColor.orangeColor()
                done.textColor = UIColor.blueColor()
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 1.0
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 0.0
                    })
                    }, completion: { finshed in
                        
                })


            }
        }
        
    }
    func getID() -> Int {
        var theseReminders = [reminders]()
        if let savedReminders = loadReminders() {
            theseReminders += savedReminders
        }
        var id = 0
        if theseReminders.count != 0 {
            id = theseReminders[theseReminders.count - 1].id + 1
        }
        return id
    }

    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(theReminders, toFile: reminders.archiveURL!.path!)
        if !isSuccessfulSave {
        }
    }
    func loadReminders() -> [reminders]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(reminders.archiveURL!.path!) as? [reminders]
    }
 /*func notifyUser(title: String, message: String) -> Void {
    let alert = UIAlertController(title: title,
    message: message,
    preferredStyle: UIAlertControllerStyle.Alert)
 
    let cancelAction = UIAlertAction(title: "OK",
    style: .Cancel, handler: nil)
 
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true,
    completion: nil)
}
 func notifyUserSound(title: String, message: String) -> Void {
    let alert = UIAlertController(title: title,
    message: message,
    preferredStyle: UIAlertControllerStyle.Alert)
    let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Dog Bark", ofType: "mp3")!)
    do {
        audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    } catch {
    notifyUser("Could not Play Audio", message: "There was a problem playing the audio")
    }
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (UIAlertAction) in
    self.audioPlayer.stop()
    }
 
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true,
    completion: nil)
 }*/
}
