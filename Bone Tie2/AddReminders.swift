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
    let path = Bundle.main.path(forResource: "Dog Bark.mp3", ofType: nil)
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.snoozeButton), name: NSNotification.Name(rawValue: "ACTION_ONE_IDENTIFIER"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneButton), name: NSNotification.Name(rawValue: "ACTION_TWO_IDENTIFIER"), object: nil)
        done.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 19)
        done.text = "Reminder Set"
        done.font = UIFont(name: "Noteworthy-Light", size: 15)
        done.textAlignment = NSTextAlignment.center
        done.textColor = UIColor.orange
        done.backgroundColor = UIColor.blue
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
        medName.frame = CGRect(x: 57, y: 300, width: 300, height: 30)
        medName.center = CGPoint(x: self.view.center.x, y: medName.center.y)
        medName.alpha = 0.0
        medName.delegate = self
        medName.borderStyle = UITextBorderStyle.roundedRect
        medName.returnKeyType = UIReturnKeyType.done
        medName.backgroundColor = UIColor.clear
        medName.placeholder = "Medicine Name"
        colorView.frame = medName.frame
        colorView.center = medName.center
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 5
        colorView.backgroundColor = UIColor.orange
        colorView.alpha = 0.0
        medName.allowsEditingTextAttributes = true
        ReminderType.frame = CGRect(x: 0, y: 55, width: self.view.frame.width, height: 100)
        ReminderType.delegate = self
        ReminderType.dataSource = self
        self.view.addSubview(ReminderType)
        view.bringSubview(toFront: ReminderType)
        
        datePicker.setValue(UIColor.blue, forKeyPath: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        self.datePicker.frame = CGRect(x: 0, y: 225, width: self.view.frame.width, height: 150)
        //datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(self.remindMe) , for: UIControlEvents.valueChanged)
        self.view.addSubview(datePicker)
        
        button.frame = CGRect(x: 0, y: self.view.frame.height - 30, width: self.view.frame.width, height: 50)
        button.center = CGPoint(x: self.view.center.x, y: self.button.center.y)
        button.setTitle("Add Reminder", for: UIControlState())
        button.setTitle("Add Reminder", for: .selected)
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.isUserInteractionEnabled = true
        //button.sizeToFit()
        button.addTarget(self, action: #selector(self.addReminder), for: UIControlEvents.touchUpInside)
        
        repeatTime.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: 100, height: 70)
        repeatTime.center = CGPoint(x: self.view.center.x, y: repeatTime.center.y)
        repeatTime.setTitle("Repeat At A time", for: UIControlState())
        repeatTime.setTitleColor(UIColor.blue, for: UIControlState())
        repeatTime.isUserInteractionEnabled = true
        repeatTime.layer.borderWidth = 1.0
        repeatTime.layer.borderColor = UIColor.blue.cgColor
        
        repeatLocation.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: 200, height: 70)
        repeatLocation.center = CGPoint(x: self.view.center.x, y: repeatTime.center.y)
        repeatLocation.setTitle("Repeat At A time", for: UIControlState())
        repeatLocation.setTitleColor(UIColor.blue, for: UIControlState())
        repeatLocation.isUserInteractionEnabled = true
        repeatLocation.layer.borderWidth = 1.0
        repeatLocation.layer.borderColor = UIColor.blue.cgColor
        
        repeatSlider.frame = CGRect(x: 10, y: 365, width: self.view.frame.width - 100, height: 31)
        repeatSlider.isContinuous = true
        repeatSlider.maximumValue = 10000
        repeatSlider.minimumValue = 100
        repeatSlider.value = 1000
        repeatSlider.isHidden = true
        repeatSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
        
        repeatRange.frame = CGRect(x: self.view.frame.width - 85, y: 365, width: 75, height: 31)
        repeatRange.text = "1 KM"
        repeatRange.textColor = self.view.tintColor
        repeatRange.textAlignment = .center
        repeatRange.isHidden = true
        
        repeatMap.frame = CGRect(x: 10, y: 210, width: self.view.frame.width - 50, height: 200)
        repeatMap.setRegion(MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000), animated: true)
        repeatMap.isHidden = true
        repeatMap.delegate = self
        repeatMap.showsUserLocation = true
        centerAnnotation.coordinate = repeatMap.centerCoordinate
        repeatMap.addAnnotation(centerAnnotation)
        repeatMap.addSubview(self.centerAnnotationView)
        
        noneMap.frame = CGRect(x: 0, y: 215, width: 50, height: 30)
        noneMap.setTitle("None", for: UIControlState())
        noneMap.center = CGPoint(x: self.view.center.x, y: noneMap.center.y)
        noneMap.addTarget(self, action: #selector(self.noneForMap), for: .touchUpInside)
        noneMap.isHidden = true
        
        noneTime.frame = CGRect(x: 0, y: 390, width: 50, height: 30)
        noneTime.setTitle("None", for: UIControlState())
        noneTime.center = CGPoint(x: self.view.center.x, y: noneTime.center.y)
        
        mapOrTime.frame = CGRect(x: 10, y: 200, width: self.view.frame.width - 100, height: 29)
        mapOrTime.addTarget(self, action: #selector(self.changeAlertType), for: .valueChanged)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.moveMapAnnotationToCoordinate(self.repeatMap.centerCoordinate)
        self.initToolbarAndAdd()
    }
    let PIN_WIDTH_OFFSET: CGFloat = 7.75
    let PIN_HEIGHT_OFFSET: CGFloat = 5
    
    func initToolbarAndAdd() {
        self.toolbar.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44)
        self.repeatMap.addSubview(self.toolbar)
    }
    // These are the constants need to offset distance between the lower left corner of
    // the annotaion view and the head of the pin
    
    func moveMapAnnotationToCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let mapViewPoint: CGPoint = self.repeatMap.convert(coordinate, toPointTo: self.repeatMap)
        // Offset the view from to account for distance from the lower left corner to the pin head
        let xoffset: CGFloat = self.centerAnnotationView.bounds.midX - PIN_WIDTH_OFFSET
        let yoffset: CGFloat = -self.centerAnnotationView.bounds.midY + PIN_HEIGHT_OFFSET
        self.centerAnnotationView.center = CGPoint(x: mapViewPoint.x + xoffset, y: mapViewPoint.y + yoffset)
    }
    
    func changeRegionToCoordinate(_ coordinate: CLLocationCoordinate2D, withSize size: Int) {
        let newRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, Double(size), Double(size))
        self.repeatMap.setRegion(newRegion, animated: true)
    }
    
    func metersPerViewPoint() -> CLLocationDistance {
        let comparisonRect: CGRect = CGRect(x: self.repeatMap.center.x, y: self.repeatMap.center.y, width: 1, height: 1)
        let comparisonRegion: MKCoordinateRegion = self.repeatMap.convert(comparisonRect, toRegionFrom: self.repeatMap)
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
                    self.repeatMap.layer.borderColor = UIColor.green.cgColor
                    self.repeatMap.layer.borderWidth = INDICATOR_BORDER_WIDTH
                }
                else {
                    self.repeatMap.layer.borderColor = UIColor.red.cgColor
                    self.repeatMap.layer.borderWidth = INDICATOR_BORDER_WIDTH
                }
            }
            else {
                self.repeatMap.layer.borderWidth = 0
            }
        }
        
        func locationForCoordinate(_ coordinate: CLLocationCoordinate2D) -> CLLocation {
            let location: CLLocation = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
            return location
        }
        
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first {
         print("Found user's location: \(location)")
         }*/
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        repeatMap.removeAnnotation(centerAnnotation)
        centerAnnotation.coordinate = repeatMap.centerCoordinate
        //repeatMap.addAnnotation(centerAnnotation)
        print("the")
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
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
                datePicker.isHidden = false
                noneTime.isHidden = false
                repeatMap.isHidden = true
                repeatRange.isHidden = true
                repeatSlider.isHidden = true
                noneMap.isHidden = true
            default:
                datePicker.isHidden = true
                noneTime.isHidden = true
                repeatMap.isHidden = false
                repeatRange.isHidden = false
                repeatSlider.isHidden = false
                noneMap.isHidden = false
        }
    }
    func noneForMap() {
        if !timeNone {
            repeatSlider.frame = CGRect(x: 10, y: 365, width: self.view.frame.width - 100, height: 31)
            repeatSlider.isContinuous = true
            repeatSlider.maximumValue = 10000
            repeatSlider.minimumValue = 100
            repeatSlider.value = 100
    
            repeatRange.frame = CGRect(x: self.view.frame.width - 85, y: 365, width: 75, height: 31)
            repeatRange.text = "1 KM"
            repeatRange.textColor = self.view.tintColor
            repeatRange.textAlignment = .center
    
            repeatMap.frame = CGRect(x: 10, y: 200, width: self.view.frame.width - 50, height: 200)
            repeatMap.setRegion(MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000), animated: true)
            mapNone = true
        } else {
            let alert = UIAlertController(title: "Cannot set map location to none", message: "When there is no given notification time, the location cannot be none", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
    }
    func noneForTime() {
        if !mapNone {
            datePicker.date = Date()
            timeNone = true
        } else {
            let alert = UIAlertController(title: "Cannot set time to none", message: "When there is no given notification location, the time cannot be none", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == 0 {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.blue])
        }
        else {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.orange])
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Food" {
            let duration = 2.0
            let delay = 0.0
            let options = UIViewKeyframeAnimationOptions()
            //foodColor?.animate(duration: 2.0)
            UIView.transition(with: self.button, duration: 2.0, options: .allowAnimatedContent, animations: {
                self.button.setTitleColor(UIColor.blue, for: UIControlState())
                self.datePicker.setValue(UIColor.blue, forKeyPath: "textColor")
                }, completion: nil)
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: options,  animations: { () -> Void in
                // each keyframe needs to be added here
                // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: { () -> Void in
                    self.imageView.alpha = 1.0
                    self.imageViews.alpha = 0.0
                    self.datePicker.frame = CGRect(x: 0, y: 275, width: self.view.frame.width, height: 150)
                    //self.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                    //self.button.setTitleColor(UIColor.blueColor(), forState: .Selected)
                    self.button.tintColor = UIColor.orange
                    self.medName.alpha = 0.0
                    self.colorView.alpha = 0.0
                    print("in")
                    
                    
                })
                }, completion: { finshed in
                    self.datePicker.datePickerMode = .countDownTimer
                    self.datePicker.datePickerMode = .dateAndTime
            })
            type = "Food"
            view.bringSubview(toFront: ReminderType)
            view.bringSubview(toFront: datePicker)
            view.bringSubview(toFront: button)
        }
        else {
            let duration = 2.0
            let delay = 0.0
            let options = UIViewKeyframeAnimationOptions()
            self.datePicker.setValue(UIColor.orange, forKeyPath: "textColor")
            self.datePicker.datePickerMode = .countDownTimer
            self.datePicker.datePickerMode = .dateAndTime
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: options,  animations: { () -> Void in
                // each keyframe needs to be added here
                // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2, animations: { () -> Void in
                    self.imageView.alpha = 0.0
                    self.imageViews.alpha = 1.0
                    self.medName.alpha = 1.0
                    self.colorView.alpha = 0.3
                    self.datePicker.frame = CGRect(x: 0, y: 350, width: self.view.frame.width, height: 150)
                    self.button.setTitleColor(UIColor.orange, for: UIControlState())
                    self.button.setTitleColor(UIColor.orange, for: .selected)
                    self.datePicker.tintColor = UIColor.blue
                    self.view.bringSubview(toFront: self.button)
                    self.view.bringSubview(toFront: self.datePicker)
                    self.view.addSubview(self.datePicker)
                    self.view.addSubview(self.ReminderType)
                    self.view.addSubview(self.medName)
                })
                }, completion: { finshed in
            })

            view.bringSubview(toFront: ReminderType)
            view.bringSubview(toFront: datePicker)
            view.bringSubview(toFront: button)
            type = "Medicine"
        }
    }
    func remindMe () {
        let (hour, minute) = components(self.datePicker.date)
        self.alarm.hour = hour
        self.alarm.minute = minute
    }
    func components (_ date: Date) -> (Int, Int) {
        let flags = NSCalendar.Unit.hour.union(NSCalendar.Unit.minute)
        let comps = (Calendar.current as NSCalendar).components(flags, from: date)
        return (comps.hour!, comps.minute!)
    }
    func snoozeButton() {
        
    }
    func doneButton() {
    }
    func notification(_ message: String) {
        let ac = UIAlertController(title: "What's that Breed?", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    func addReminder() {
        self.alarm.turnOn()
        let now = Date()
        let alarmTime = datePicker.date
        let calendar = Calendar.current
        let dayCalendarUnit: NSCalendar.Unit = [.day, .hour, .minute, .second]
        let alarmTimeDifference = (calendar as NSCalendar).components(
            dayCalendarUnit,
            from: now,
            to:  alarmTime,
            options:  [])
        var secondsFromNow: TimeInterval = (Double(alarmTimeDifference.second!)+Double(alarmTimeDifference.minute!*60))
        secondsFromNow += (Double(alarmTimeDifference.hour!*3600)+Double(alarmTimeDifference.day!*86400))
        if self.alarm.isOn  {
            let id = getID()
            let userInfo = ["dogID": String(dogs!.id), "ID": id] as [String : Any]
            if ReminderType.selectedRow(inComponent: 0) == 0 {
                let message = "Don't forget to feed \(dogs?.name)"
                //let center = repeatMap.centerCoordinate
                //let distance: CLLocationDistance = CLLocationDistance(Double(repeatSlider.value))
                let region: CLCircularRegion? = nil//CLCircularRegion(center: center, radius: distance, identifier: "Notification Region")
                theReminders.append(reminders(reminderDogId: dogs?.id, name: nil, photo: dogs?.photo, repeatType: nil, repeatTime: nil, created: Date(), firstLaunchTime: datePicker.date, location: nil, range: nil, type: "Food", stillRepeating: false, notification: LocalNotificationHelper.sharedInstance().scheduleNotification("Food", message: message, seconds: secondsFromNow, userInfo: userInfo as [AnyHashable: Any], theDog: dogs, theRegion: region, soundName: nil, theCalenderInterval: nil, theDates: nil, regionTriggersOnce: false), id: id)!)
                print(UIApplication.shared.scheduledLocalNotifications)
                saveReminders()
                let url = URL(fileURLWithPath: path!)
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    soundEffect = sound
                    sound.play()
                } catch {
                    //no file found
                }
                let duration = 10.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions()
                done.backgroundColor = UIColor.blue
                done.textColor = UIColor.orange
                UIView.animateKeyframes(withDuration: duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 1.0
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 0.0
                    })
                    }, completion: { finshed in
                        
                })
            }
            if ReminderType.selectedRow(inComponent: 0) == 1 {
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
                LocalNotificationHelper.sharedInstance().scheduleNotification("Medicine", message: message, seconds: secondsFromNow, userInfo: userInfo as [AnyHashable: Any], theDog: dogs, theRegion: region, soundName: nil, theCalenderInterval: nil, theDates: nil, regionTriggersOnce: false)
                let url = URL(fileURLWithPath: path!)
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
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
                let options = UIViewKeyframeAnimationOptions()
                done.backgroundColor = UIColor.orange
                done.textColor = UIColor.blue
                UIView.animateKeyframes(withDuration: duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 1.0
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: { () -> Void in
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
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(theReminders, toFile: reminders.archiveURL!.path)
        if !isSuccessfulSave {
        }
    }
    func loadReminders() -> [reminders]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: reminders.archiveURL!.path) as? [reminders]
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
