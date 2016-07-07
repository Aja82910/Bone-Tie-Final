//
//  LostViewController.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 12/14/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics
import CoreLocation

public let uiBusy = UIActivityIndicatorView()
let config: AnyClass = BTConfiguration.self


class LostViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate  {
    
    var DirectionTime = String()
    var DirectionType: String = "None"
    var activePlace = 0
    var places = [Dictionary<String, String>()]
    let api = Api()
    
    @IBOutlet weak var Refresh: UIBarButtonItem!
    @IBOutlet weak var More: UIBarButtonItem!

    let ber = UIBarButtonSystemItem.Add
    var manager: CLLocationManager!
    var mapsType = UISegmentedControl()
    var directionsType = UISegmentedControl()
    var doggie: dog?
    let coolColor  = UILabel()
    //var DogNameLost = UILabel()
    var DogImageLost = UIImageView()
    //var shareButton = UIButton(type: .System)
    var mapView = MKMapView()
    var scrollView = UIScrollView()
    //var image: UIImageView!
    //var dropdown = UITableView()
    
    var Information = UIView()
    var Open: UIBarButtonItem!
    //var DogName = UILabel()
    //var TrackerNumberLabel = UILabel()
    //var TrackerNumber = UILabel()
    //var TrackerNumberImage = UIImageView()
    var Displaying = UILabel()
    var Display = UITextField()
    //var DisplayMilesWalkedLabel = UILabel()
    //var DisplayMilesWalked = UISwitch()
    var down = UIButton()
    var up = UIButton()
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
    var downBlur = UIVisualEffectView()
    var blurView = UIVisualEffectView()
    var backgroundImage = UIImageView()
    var circleButton = UIImageView()
    var callButton = UILabel()
    var dropdownItems = []
    var menuView: BTNavigationDropdownMenu!
    var font = UIFont(name: "Chalkduster", size: 20.5)
    var downArrowImage = UIImageView()
    var arrowImage = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        BTConfiguration().defaultValue()
        let arrow = arrowImagePaths
        print(arrow)
        downArrowImage.image = UIImage(contentsOfFile: arrow!)!
        downArrowImage.image = downArrowImage.image!.imageWithRenderingMode(.AlwaysTemplate)
        down.frame = CGRect(x: 0, y: self.view.frame.height - 113, width: self.view.frame.width, height: 50)
        down.backgroundColor = UIColor.orangeColor()
        down.alpha = 1.0
        down.addTarget(self, action: #selector(self.goDown), forControlEvents: .TouchUpInside)
        downBlur.effect = blurBackGround
        downBlur.frame = down.frame
        downArrowImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        downArrowImage.center = CGPoint(x: self.down.frame.width / 2, y: self.down.frame.height / 2)
        var downArrow = UIImage(named: "Down")
        downArrow = downArrow!.imageWithRenderingMode(.AlwaysTemplate)
        arrowImage.setImage(downArrow, forState: .Selected)
        arrowImage.setImage(downArrow, forState: .Normal)
        arrowImage.frame = CGRect(x: self.navigationController!.navigationBar.frame.width - 40, y: 0, width: 30, height: 30)
        arrowImage.center = CGPoint(x: self.arrowImage.center.x, y: self.navigationController!.navigationBar.frame.minY)
        arrowImage.tintColor = self.view.tintColor
        self.navigationItem.backBarButtonItem?.target = self
        self.navigationItem.backBarButtonItem?.action = #selector(self.backToLostViewController)
        self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, CGFloat(M_PI))
        //arrowImage.sizeToFit()
        print(More.accessibilityFrame)
        //self.navigationItem.
        //arrowImage.backgroundColor = UIColor.redColor()
        arrowImage.addTarget(self, action: #selector(self.ShowDropMenu(_:)), forControlEvents: .TouchUpInside)
        self.navigationController?.navigationBar.addSubview(arrowImage)
        //dropdown.backgroundColor = UIColor.blueColor()
        //self.dropdown.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //dropdown.frame = CGRect(x: 25, y: -316, width: self.view.frame.width - 25, height: 250)
        Open.image = UIImage(named: "Open")
        Open.title = ""
        blurView.effect = blurBackGround
        tint = self.view.tintColor
        DogImageLost.image = (self.doggie?.photo)
        //DogNameLost.text = (self.doggie?.name)
        //DogName.text = "Dog Name"
        //TrackerNumberLabel.text = "Tracker Number"
        //TrackerNumber.text = forecastAPIKeys
        Displaying.text = "Displaying"
        Display.text = LedDatas
        //DisplayMilesWalkedLabel.text = "Display Miles Walked"
        Open.tintColor = tint
        coolColor.frame = CGRectMake(0, 0, self.view.frame.width, 50)
        coolColor.backgroundColor = UIColor.blueColor()
        self.view.addSubview(coolColor)
        self.view.sendSubviewToBack(coolColor)
        DogImageLost = UIImageView(frame: CGRect(x: 0, y: 450, width: self.view.bounds.width, height: self.view.bounds.width))
        self.view.translatesAutoresizingMaskIntoConstraints = true
        Information = UIView(frame: CGRect(x: 0, y: 450 + self.view.bounds.width, width: self.view.bounds.width, height: 150))
        //DogName = UILabel(frame: CGRect(x: 63, y: 13, width: 116, height: 28))
        //TrackerNumberLabel = UILabel(frame: CGRect(x: 8, y: 42, width: 171, height: 28))
        Displaying = UILabel(frame: CGRect(x: 65, y: 70, width: 114, height: 28))
        //DisplayMilesWalkedLabel = UILabel(frame: CGRect(x: 75, y: 108, width: 160, height: 26))
        //DisplayMilesWalked = UISwitch(frame: CGRect(x: 327, y: 105, width: 51, height: 31))
        //DisplayMilesWalked.addTarget(self, action: #selector(self.DisplayMilesWalked(_:)), forControlEvents: .ValueChanged)
        Display = UITextField(frame: CGRect(x: 155, y: 68, width: 221, height: 30))
        Display.delegate = self
        //TrackerNumber = UILabel(frame: CGRect(x: 155, y: 40, width: 236, height: 28))
        //TrackerNumberImage = UIImageView(frame: CGRect(x: 300, y: 40, width: 22, height: 22))
        //TrackerNumberImage.image = image
        //DogNameLost = UILabel(frame: CGRect(x: 205, y: 13, width: 101, height: 28))
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 113))
        mapView.delegate = self
        mapsType = UISegmentedControl(items: ["Map", "Satilite", "Hybrid"])
        mapsType.selectedSegmentIndex = 0
        mapsType.frame = CGRect(x: self.mapView.frame.width/2 - self.mapsType.frame.width/2, y: 319.0, width: 244.0, height: 29.0)
        mapsType.center = CGPoint(x: self.view.center.x - 50, y: 10.5)
        mapsType.layer.cornerRadius = 5.0  // Don't let background bleed
        mapsType.tintColor = tint
        mapsType.backgroundColor = UIColor.clearColor()
        mapsType.addTarget(self, action: #selector(LostViewController.MapType(_:)), forControlEvents: .ValueChanged)
        DirectionLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 0, height: 0))
        DirectionLabel.text = "Directions"
        DirectionLabel.textColor = UIColor.orangeColor()
        DirectionLabel.sizeToFit()
        directionsType = UISegmentedControl(items: ["Drive", "Walk", "Transit", "None"])
        directionsType.selectedSegmentIndex = 3
        print("Done" + String(DirectionLabel.frame.height))
        directionsType.frame = CGRect(x: self.mapView.frame.width/2 - self.directionsType.frame.width/2, y: self.DirectionLabel.frame.maxY + 10, width: 325.3, height: 29.0)
        directionsType.center = CGPoint(x: self.view.center.x /*- (1/2 * DisplayMinutes.frame.width)*/, y: self.directionsType.center.y)
        DisplayMinutes = UILabel(frame: CGRect(x: 20, y: self.directionsType.frame.maxY + 10, width: 0, height: 0))
        DisplayMinutes.center = CGPoint(x: self.view.center.x, y: self.DisplayMinutes.center.y)
        DisplayMinutes.textColor = UIColor.orangeColor()
        directionsType.layer.cornerRadius = 5.0  // Don't let background bleed
        directionsType.tintColor = tint
        directionsType.backgroundColor = UIColor.clearColor()
        directionsType.addTarget(self, action: #selector(LostViewController.DirectionType(_:)), forControlEvents: .ValueChanged)
        //DogNameLost.frame = CGRectMake(200, 200, 200, 200)
        DogImageLost.setupForImageViewer()
        /*shareButton.frame = CGRectMake(13, 75, self.view.frame.width - 26 , 50)
        shareButton.tintColor = UIColor.cyanColor()
        shareButton.setTitle("Share", forState: UIControlState.Normal)
        shareButton.backgroundColor = UIColor.blueColor()
        shareButton.addTarget(self, action: #selector(LostViewController.shareButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.layer.cornerRadius = 20
        shareButton.layer.masksToBounds = true*/ // Old Share button
        //DirectionLabel.center = CGPoint(x: self.view.center.x, y: (directionsType.frame.minY - 66) / 2 + 66)
        DirectionLabel.sizeToFit()
        circleButton.frame = CGRect(x: self.view.center.x - (1/2 * circleButton.frame.width), y: self.view.frame.height - (3/2 * circleButton.frame.height), width: 40, height: 40)
        circleButton.center = CGPoint(x: 10, y: 5)
        //circleButton.layer.masksToBounds = true
        //circleButton.layer.cornerRadius = 25
        //let button = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: #selector(self.addReminder(_:)))
        //button.enabled = false
        //let buttons = button as NSObject
        //let image = UIImage(data: buttons as! NSData)
        //circleButton.setImage(image, forState: .Normal)
        //circleButton.setImage(image, forState: .Selected)
        circleButton.image = UIImage(named: "Expand")
        //circleButton.setImage(UIImage(named: "Expand"), forState: .Selected)
        circleButton.backgroundColor = UIColor.clearColor()
        //circleButton.addTarget(self, action: #selector(self.addReminder(_:)), forControlEvents: .TouchUpInside)
        callButton.frame = CGRect(x: self.view.center.x - (1/2 * circleButton.frame.width), y: self.view.frame.height - (3/2 * circleButton.frame.height), width: 40, height: 40)
        callButton.center = CGPoint(x: 10, y: 5)
        //callButton.layer.masksToBounds = true
        //callButton.layer.cornerRadius = 16.5
        callButton.text = "📞"
        //callButton.backgroundColor = UIColor.clearColor()
        //callButton.addTarget(self, action: #selector(self.call(_:)), forControlEvents: .TouchUpInside)

        //let fullRotation = CGFloat(M_PI * 2)
        //circleButton.transform = CGAffineTransformMakeRotation(1/8 * fullRotation)
        //callButton.transform = CGAffineTransformMakeRotation(-1/4 * fullRotation)
        //old buttons needed the rotation
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height * 2 - 176)
        scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        scrollView.delegate = self
        scrollView.scrollEnabled = true
        backgroundImage.image = doggie?.photo
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //setZoomScale()
        self.view.addSubview(backgroundImage)
        self.view.addSubview(blurView)
        //self.view.addSubview(dropdown)
        //self.view.addSubview(circleButton)
        //self.view.addSubview(callButton)
        self.view.addSubview(scrollView)
        //scrollView.addSubview(image)
        scrollView.addSubview(DogImageLost)
        scrollView.addSubview(mapView)
        //scrollView.addSubview(mapsType)
        scrollView.addSubview(Information)
        scrollView.addSubview(directionsType)
        scrollView.addSubview(DisplayMinutes)
        scrollView.addSubview(DirectionLabel)
        scrollView.addSubview(down)
        //scrollView.addSubview(downBlur)
        down.addSubview(downArrowImage)
        navigationItem.title = doggie?.name
        //scrollViewDidZoom(scrollView)
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //Information.addSubview(DogNameLost)
        //Information.addSubview(DogName)
        //Information.addSubview(TrackerNumber)
        //Information.addSubview(TrackerNumberLabel)
        Information.addSubview(Display)
        Information.addSubview(Displaying)
        //Information.addSubview(DisplayMilesWalked)
        //Information.addSubview(DisplayMilesWalkedLabel)
        //Information.addSubview(TrackerNumberImage)
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(LostViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(LostViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        //scrollView.addSubview(DogNameLost)
        //self.view.addSubview(DogImageLost)
        //TrackerNumberImage.hidden = true
        //TrackerNumberImage.userInteractionEnabled = true
        //let tapImage = UITapGestureRecognizer(target: self, action: #selector(LostViewController.enlargeTrackerNumber(_:)))
        //TrackerNumberImage.addGestureRecognizer(tapImage)
        //self.view.addSubview(shareButton)
        //self.view.addSubview(circleButton)
        loadMap()
        dropdownItems = ["Map Type", "Settings", "Share", "Add A Reminder", "Call", "Directions to \(doggie!.name)"]
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: doggie!.name, items: dropdownItems as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.cyanColor()
        let colors = CGColorGetComponents(UIColor.cyanColor().CGColor)
        print(colors[2])
        menuView.cellSelectionColor = UIColor(red: colors[0] - 0.1, green: colors[1] - 0.1, blue: colors[2] - 0.1, alpha: 1.0)
        menuView.checkMarkImage = nil
        menuView.keepSelectedCellColor = false
        menuView.cellTextLabelColor = UIColor.orangeColor()
        menuView.cellTextLabelFont = font
        menuView.cellTextLabelAlignment = .Center
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.mapsType = mapsType
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if indexPath == 1 {
                self.arrowImage.hidden = true
                self.performSegueWithIdentifier("Setting", sender: self)
            } else if indexPath == 2 {
                self.shareButtonTapped(self)
            } else if indexPath == 3 {
                self.arrowImage.hidden = true
                self.addReminder(self)
            } else if indexPath == 4 {
                self.call(self)
            } else if indexPath == 5 {
                self.loadDirections(self)
            }
            self.ShowDropMenu(self)
        }
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                //NSTimer.scheduledTimerWithTimeInterval(5, target: Api(), selector: #selector(Api.lostReload), userInfo: nil, repeats: true)
                UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
            })
           NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.lostReload), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
        self.scrollView.bringSubviewToFront(down)
        self.down.bringSubviewToFront(downArrowImage)
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
    var doneScrolling = false
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if doneScrolling == true {
            print("Done here")
        }
        doneScrolling = false
        self.faceDircetion()
       // NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: #selector(self.faceDircetion), userInfo:!doneScrolling, repeats: true)
        print(doneScrolling)
        print("done")
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        doneScrolling = true
    }
    func faceDircetion() {
       // UIView.animateWithDuration(0.2) {
            self.downArrowImage.transform = CGAffineTransformMakeRotation(-1 * (self.scrollView.bounds.minY / (self.view.frame.height - 113)) * CGFloat(M_PI))
       // }
    }
    func goDown() {
        if scrollView.bounds.minY <= scrollView.frame.height / 2 - 25 {
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: self.view.frame.height), animated: true)
            faceDircetion()
        } else {
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
            faceDircetion()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first {
            print("Found user's location: \(location)")
        }*/
        self.scrollView.bringSubviewToFront(down)
        self.down.bringSubviewToFront(downArrowImage)
        let userLocation:CLLocation = locations[0]
        Userlong = userLocation.coordinate.longitude
        Userlat = userLocation.coordinate.latitude
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addReminder(sender: AnyObject) {
        self.performSegueWithIdentifier("AddReminder", sender: self)
    }
    func backToLostViewController() {
        self.arrowImage.hidden = false
    }
    func call(sender: AnyObject) {
        let busPhone  = "914-359-1066"
        if let url = NSURL(string: "tel://\(busPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
        /*func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("in")
        let cell = dropdown.dequeueReusableCellWithIdentifier("cell")!
        if indexPath.row == 0 {
            print(cell)
            cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 25, height: 50)
            let image = UILabel()
            print(cell.frame)
            image.text = "🗺 Maps Type"
            image.frame = CGRect(x: 25, y: 0, width: 50, height: 50)
            image.adjustsFontSizeToFitWidth = true
            /*let label = UILabel(frame: CGRect(x: 1.5 * self.dropdown.center.x, y: self.dropdown.center.y, width: 0.49 * self.dropdown.center.x, height: self.dropdown.center.y))
            label.text = "Map Type"*/    //might add label for this
            mapsType.center = CGPoint(x: cell.center.x + 25, y: cell.center.y)
            cell.addSubview(image)
            cell.addSubview(mapsType)
            return cell
        } else if indexPath.row == 1 {
            print(cell.frame)
            cell.frame = CGRect(x: 0, y: 50, width: self.view.frame.width - 25, height: 50)
            let image = UILabel()
            image.text = "⚙"
            image.adjustsFontSizeToFitWidth = true
            image.frame = CGRect(x: 25, y: 0, width: 50, height: 50)
            let label = UILabel(frame: CGRect(x: cell.center.x + 25, y: 50, width: 0, height: 0))
            label.center = CGPoint(x: cell.center.x, y: 14.25)
            label.text = "Settings"
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .Center
            label.textColor = UIColor.blueColor()
            label.sizeToFit()
            cell.addSubview(image)
            cell.addSubview(label)
            cell.bringSubviewToFront(label)
            return cell
        } else if indexPath.row == 2 {
            cell.frame = CGRect(x: 0, y: 100, width: self.view.frame.width - 25, height: 50)
            let button = UIBarButtonItem(barButtonSystemItem: .Action, target: nil, action: #selector(self.addReminder(_:)))
            button.enabled = false
           // let buttons = button as NSObject
            //let image = UIImageView(image: UIImage(data: buttons as! NSData))
            let label = UILabel(frame: CGRect(x: cell.center.x, y: 50, width: 0, height: 0))
            label.center = CGPoint(x: cell.center.x, y: 14.25)
            label.text = "Share"
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .Center
            label.textColor = UIColor.blueColor()
            label.sizeToFit()
            //cell.addSubview(image)
            cell.addSubview(label)
            cell.bringSubviewToFront(label)
            return cell
        } else if indexPath.row == 3 {
            cell.frame = CGRect(x: 0, y: 150, width: self.view.frame.width - 25, height: 50)
            let image = circleButton
            let label = UILabel(frame: CGRect(x: 1.5 * self.dropdown.center.x, y: self.dropdown.center.y, width: 0.49 * self.dropdown.center.x, height: self.dropdown.center.y))
            label.text = "Add a Reminder"
            cell.addSubview(image)
            cell.addSubview(label)
            return cell
        } else {
            cell.frame = CGRect(x: 0, y: 200, width: self.view.frame.width - 25, height: 50)
            let image = callButton
            let label = UILabel(frame: CGRect(x: 1.5 * self.dropdown.center.x, y: self.dropdown.center.y, width: 0.49 * self.dropdown.center.x, height: self.dropdown.center.y))
            label.text = "Directions to \(doggie!.name)"
            cell.addSubview(image)
            cell.addSubview(label)
            return cell
        }
    }*/
    override func viewWillAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(self.backInParent), userInfo: nil, repeats: false)
    }
    func backInParent() {
        self.arrowImage.hidden = false
    }
    func ShowDropMenu(sender: AnyObject) {
        print(menuView.isShown!)
        if !menuView.isShown! {
            menuView.showMenu()
            UIView.animateWithDuration(0.4, animations: {
                self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, 3.14159265358979)
            })
        } else {
            menuView.hideMenu()
            UIView.animateWithDuration(0.4, animations: {
                self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform , -3.14159265358979)
            })
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
            mapView.showsTraffic = true
        case 1:
            DirectionType = "Walking"
            mapView.showsTraffic = true
        case 2:
            DirectionType = "Transit"
            mapView.showsTraffic = true
        case 3:
            DirectionType = "None"
            mapView.showsTraffic = false
        default:
            break
        }
        mapView.removeOverlays(self.mapView.overlays)
        mapView(mapView, viewForAnnotation: mapView.annotations[mapView.annotations.count - 1])
    }
    func loadDirections(sender: AnyObject) {
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

    func loadMap() {
        let begin: () = api.beginApi()
        begin
        let longed = longitude
        let lated = latitude
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
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
                annotation.coordinate = location
                annotation.title = places[activePlace]["name"]
                mapView.addAnnotation(annotation)
                
                
            }
    }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "loadMap"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        let AnnotationDog = UIImageView.init(image: self.doggie?.photo)
        if annotation is MKUserLocation {
            return nil
        }
        else if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            let pinImage = combineAnnotationPhotos(doggie!)
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            view?.image = resizedImage
            view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            view?.leftCalloutAccessoryView = AnnotationDog
            //view?.animatesDrop = true
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
            self.arrowImage.hidden = true
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
    var directions = String()
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
        directions = steped
        Steps.font = UIFont(name: "Chalkduster", size: 20.5)
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
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.scrollView.contentSize.height + Steps.frame.height)
    }
    /*func DisplayMilesWalked(sender: UISwitch) {
        if DisplayMilesWalked.on {
            Display.enabled = false
            Display.placeholder = ""
        }
        else {
            Display.enabled = true
            Display.placeholder = "Only 4 symbols"
        }
        
    }*/
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
        Refreshing(true)
        doneReloading = false
        let request = api.requestDatafromDog(true)
        let retrieve = api.lostReload()
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector:  #selector(LostViewController.EndedRefresh), userInfo: nil, repeats: !EndedRefresh())
        RefreshColor = tint
        Refresh.tintColor = UIColor.clearColor()
        Refresh.enabled = false
        self.navigationItem.setRightBarButtonItems([More, UIBarButtonItem(customView: uiBusy), Refresh], animated: true)
        if !request || !retrieve {
            if !request {
            NSTimer.scheduledTimerWithTimeInterval(5, target: Api(), selector: #selector(Api.requestDatafromDog), userInfo: nil, repeats: !request)
            }
            else if !retrieve {
                 NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.lostReload), userInfo: nil, repeats: !retrieve)
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
        let shareName: String = doggie!.name
        let shareBreed: String = doggie!.breed
        let shareCity: String = doggie!.city
        let shareLocation: CLLocation = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let shareImg: UIImage = self.DogImageLost.image!
        let shareItems: Array = [shareName, shareImg, shareBreed, shareCity, shareLocation]
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
        self.arrowImage.hidden = false
        var doggies = [dog]()
        if let savedDogs = loadDogs() {
            doggies += savedDogs
        }
        doggie = doggies[0]
        DogImageLost.image = (self.doggie?.photo)
        //DogNameLost.text = (self.doggie?.name)
        backgroundImage.image = doggie?.photo
        Display.borderStyle = UITextBorderStyle.RoundedRect
        Display.returnKeyType = UIReturnKeyType.Done
        Display.allowsEditingTextAttributes = true
        DogImageLost.image = (self.doggie?.photo)
        //DogNameLost.text = (self.doggie?.name)
        //DogName.text = "Dog Name"
//        TrackerNumberLabel.text = "Tracker Number"
//        TrackerNumber.text = key
        Displaying.text = "Displaying"
        Display.text = LedDatas
        //DisplayMilesWalkedLabel.text = "Display Miles Walked"
        DogImageLost.frame = CGRectMake(0, self.view.frame.height - 63, self.view.bounds.width, self.view.bounds.width)
        Information.frame = CGRectMake(0, self.view.frame.height + self.view.bounds.width - 63, self.view.bounds.width, 150)
        //DogName.frame = CGRectMake(63, 13, 116, 28)
       // TrackerNumberLabel.frame = CGRectMake(8, 42, 171, 28)
        Displaying.frame = CGRectMake(65, 70, 114, 28)
        //DisplayMilesWalkedLabel.frame = CGRectMake(105, 108, 170, 26)
        //DisplayMilesWalked.frame = CGRectMake(305, 105, 51, 31)
        Display.frame = CGRectMake(205, 68, 150, 30)
        //TrackerNumber.frame = CGRectMake(205, 40, 150, 28)
        //TrackerNumber.adjustsFontSizeToFitWidth = true
        //DogNameLost.frame = CGRectMake(205, 13, 101, 28)
        scrollView = UIScrollView(frame: CGRectMake(0, 64, self.view.bounds.width, self.view.bounds.height - 64))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.view.frame.height * 2 - 176)
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
        //scrollView.addSubview(mapsType)
        scrollView.addSubview(directionsType)
        scrollView.addSubview(DisplayMinutes)
        scrollView.addSubview(DirectionLabel)
        scrollView.addSubview(Information)
        scrollView.addSubview(down)
        navigationItem.title = doggie?.name
       // Information.addSubview(DogNameLost)
        //Information.addSubview(DogName)
        //Information.addSubview(TrackerNumber)
        //Information.addSubview(TrackerNumberLabel)
        Information.addSubview(textBoxBlur)
        Information.addSubview(Display)
        Display.backgroundColor = UIColor.clearColor()
        Information.addSubview(Displaying)
        self.scrollView.bringSubviewToFront(down)
        self.down.bringSubviewToFront(downArrowImage)
        //Information.addSubview(DisplayMilesWalked)
        //Information.addSubview(DisplayMilesWalkedLabel)
        //Information.bringSubviewToFront(self.TrackerNumberImage)
        //self.view.addSubview(DogImageLost)
        //self.view.addSubview(shareButton)
        //self.view.addSubview(circleButton)
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
        //self.view.addSubview(blurries)
        //self.view.addSubview(blurry)
        //for old blur behind old call and add reminder buttons
        //self.view.addSubview(callButton)
        self.view.bringSubviewToFront(circleButton)
        Display.placeholder = "Only 4 symbols"
        DirectionLabel.center = CGPoint(x: self.view.center.x, y: self.DirectionLabel.center.y)
        scrollView.bringSubviewToFront(directionsType)
        if Display.frame.width + Display.frame.minX > self.view.frame.width {
            Display.frame =  CGRectMake(self.view.frame.width - self.Display.frame.width - 10, self.Display.frame.minY, self.Display.frame.width, self.Display.frame.height)
            textBoxBlur.frame = Display.frame
            //TrackerNumber.frame =  CGRectMake(self.view.frame.width - self.TrackerNumber.frame.width - 10, self.TrackerNumber.frame.minY, self.TrackerNumber.frame.width, self.TrackerNumber.frame.height)
             //DogNameLost.frame =  CGRectMake(self.Display.frame.minX, self.DogNameLost.frame.minY, self.DogNameLost.frame.width, self.DogNameLost.frame.height)
             //DisplayMilesWalked.frame =  CGRectMake(self.view.frame.width - self.DisplayMilesWalked.frame.width - 10, self.DisplayMilesWalked.frame.minY, self.DisplayMilesWalked.frame.width, self.DisplayMilesWalked.frame.height)
            // DisplayMilesWalkedLabel.frame =  CGRectMake(self.DisplayMilesWalked.frame.minX - self.DisplayMilesWalkedLabel.frame.width - 10, self.DisplayMilesWalkedLabel.frame.minY, self.DisplayMilesWalkedLabel.frame.width, self.DisplayMilesWalkedLabel.frame.height)
        }
        //self.view.bringSubviewToFront(dropdown)
    }
    
    /*func enlargeTrackerNumber(sender: UITapGestureRecognizer) {
        if y == 1 {
        Information.bringSubviewToFront(self.TrackerNumber)
        //Information.bringSubviewToFront(self.TrackerNumberImage)
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
                    //self.TrackerNumberImage.transform = CGAffineTransformMakeRotation(1/8 * fullRotation)
                    
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
            //Information.bringSubviewToFront(self.TrackerNumberImage)
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
                    //self.TrackerNumberImage.transform = CGAffineTransformMakeRotation(0 * fullRotation)
                    
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
    }*/
    //Old function for enlarging the tracker number
    func EndedRefresh() -> Bool {
        if !uiBusy.isAnimating() && !doneReloading {
            self.navigationItem.setRightBarButtonItems([More, Refresh], animated: true)
            Refresh.tintColor = RefreshColor
            Refresh.enabled = true
            loadMap()
            doneReloading = true
            return true
        }
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if x == 1 {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: scrollView.contentSize.height + keyboardHeight + self.Display.frame.height)
        self.scrollView.bringSubviewToFront(self.Display)
        self.scrollView.bringSubviewToFront(self.Display)
        self.scrollView.bringSubviewToFront(self.Display)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: Information.frame.minY - 246), animated: true)

            x = 0
             //self.scrollView.scrollRectToVisible(CGRectMake(0.0, self.scrollView.contentSize.height, self.view.frame.width, self.view.frame.height), animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if x == 0 {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: scrollView.contentSize.height - (keyboardHeight + self.Display.frame.height))
            self.scrollView.bringSubviewToFront(self.Display)
            self.scrollView.scrollEnabled = true
            LedDatas = self.Display.text!
            let request = self.api.requestDatafromDog(false)
            if !request {
                NSTimer.scheduledTimerWithTimeInterval(3, target: Api(), selector: #selector(Api.requestDatafromDog(_:)), userInfo: nil, repeats: !request)
                    }
            
            x = 1;
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
        print(segue.identifier)
        if segue.identifier == "Setting" {
            let DestViewController = segue.destinationViewController as! Setings
            DestViewController.deletedDog = self.doggie
        }
        if segue.identifier == "DogsInfoLocation" {
            let DestViewController = segue.destinationViewController as! DogLocationViewController
            DestViewController.dogs = self.doggie
            DestViewController.directionsType = self.directionsType.titleForSegmentAtIndex(self.directionsType.selectedSegmentIndex)!
            DestViewController.directions = self.directions
            if self.DisplayMinutes.text != "" {
                let traveltimed = self.DisplayMinutes.text?.startIndex.advancedBy(13)
                DestViewController.directionTime = DisplayMinutes.text!.substringFromIndex(traveltimed!)
            }
        }
        if segue.identifier == "AddReminder" {
            let DestViewController = segue.destinationViewController as! AddReminders
            DestViewController.dogs = self.doggie!
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


