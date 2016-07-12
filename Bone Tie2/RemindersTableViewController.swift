//
//  RemindersTableViewController.swift
//  
//
//  Created by Alex Arovas on 7/6/16.
//
//

import UIKit

class RemindersTableViewController: UITableViewController {
    var theDog = dog?()
    var theReminders = [reminders]()
    var allTheReminders = [EveryReminder]()
    
    var sundayReminders = [reminders]()
    var mondayReminders = [reminders]()
    var tuesdayReminders = [reminders]()
    var wednesdayReminders = [reminders]()
    var thursdayReminders = [reminders]()
    var fridayReminders = [reminders]()
    var saturdayReminders = [reminders]()
    
    var sundayAllReminders = [EveryReminder]()
    var mondayAllReminders = [EveryReminder]()
    var tuesdayAllReminders = [EveryReminder]()
    var wednesdayAllReminders = [EveryReminder]()
    var thursdayAllReminders = [EveryReminder]()
    var fridayAllReminders = [EveryReminder]()
    var saturdayAllReminders = [EveryReminder]()
    
    var dismissedViewcontroller: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedReminders = loadReminders() {
            theReminders += savedReminders
        }
        if let savedReminders = loadEveryReminder() {
            allTheReminders += savedReminders
        }
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(tableView.reloadData), userInfo: !dismissedViewcontroller, repeats: true)
        tableView.backgroundView = UIImageView(image: theDog?.photo)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func remindersIntoDayReminders() {
        for reminder in theReminders {
            let weekday = NSCalendar.currentCalendar().component(.Weekday, fromDate: reminder.created)
            switch weekday {
            case 1:
                sundayReminders.append(reminder)
            case 2:
                mondayReminders.append(reminder)
            case 3:
                tuesdayReminders.append(reminder)
            case 4:
                wednesdayReminders.append(reminder)
            case 5:
                thursdayReminders.append(reminder)
            case 6:
                fridayReminders.append(reminder)
            default:
                saturdayReminders.append(reminder)
            }
        }
    }
    func everyReminderIntoDayReminders() {
        for reminder in allTheReminders {
            let weekday = NSCalendar.currentCalendar().component(.Weekday, fromDate: reminder.launchDate!)
            switch weekday {
            case 1:
                sundayAllReminders.append(reminder)
            case 2:
                mondayAllReminders.append(reminder)
            case 3:
                tuesdayAllReminders.append(reminder)
            case 4:
                wednesdayAllReminders.append(reminder)
            case 5:
                thursdayAllReminders.append(reminder)
            case 6:
                fridayAllReminders.append(reminder)
            default:
                saturdayAllReminders.append(reminder)
            }
        }
    }
    func sortReminders(weekday: Int, descending: Bool, all: Bool) {
        var allDays = weekday
        var weekdays = weekday
        if all {
            weekdays = 1
            allDays = 7
        }
        for weekday in weekdays...allDays {
            switch weekday {
                case 1:
                    if descending {
                        sundayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        sundayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                        }
                    }
                case 2:
                    if descending {
                        mondayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        mondayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                        }
                }

                case 3:
                    if descending {
                        tuesdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        tuesdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                        }
                }

                case 4:
                    if descending {
                        wednesdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        wednesdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                        }
                }

                case 5:
                    if descending {
                        thursdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        thursdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                        }
                    }

                case 6:
                    if descending {
                        fridayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        fridayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                        }
                    }

                default:
                    if descending {
                        saturdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        saturdayReminders.sortInPlace {
                            return $0.created.compare($1.created) == NSComparisonResult.OrderedAscending
                    }
                }
            }
        }
    }
    func sortAllReminders(weekday: Int, descending: Bool, all: Bool) {
        var allDays = weekday
        var weekdays = weekday
        if all {
            weekdays = 1
            allDays = 7
        }
        for weekday in weekdays...allDays {
            switch weekday {
                case 1:
                    if descending {
                        sundayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        sundayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                        }
                    }
                case 2:
                    if descending {
                        mondayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        mondayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                        }
                    }
                
                case 3:
                    if descending {
                        tuesdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        tuesdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                        }
                    }
                
                case 4:
                    if descending {
                        wednesdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        wednesdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                        }
                    }
                
                case 5:
                    if descending {
                        thursdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        thursdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                        }
                    }
                
                case 6:
                    if descending {
                        fridayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        fridayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                        }
                    }
                
                default:
                    if descending {
                        saturdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedDescending
                        }
                    } else {
                        saturdayAllReminders.sortInPlace {
                            return $0.launchDate!.compare($1.launchDate!) == NSComparisonResult.OrderedAscending
                    }
                }
            }
        }
    }

    override func viewDidDisappear(animated: Bool) {
        dismissedViewcontroller = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    func roundCorner(corners: UIRectCorner, radius: CGFloat, object: UIView) {
        let maskPath = UIBezierPath(roundedRect: object.frame, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = object.frame;
        maskLayer.path = maskPath.CGPath;
        object.layer.mask = maskLayer;
    }
    func findDogWithID(id: Int) -> dog? {
        var dogs = [dog]()
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        for dog in dogs {
            if dog.id == id {
                return dog
            }
        }
        return nil
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let infoView = UIView(frame: CGRect(x: 10, y: 55, width: self.view.frame.width - 20, height: cell.frame.height - 50))
        roundCorner(UIRectCorner.BottomLeft, radius: 10.0, object: infoView)
        roundCorner(UIRectCorner.BottomRight, radius: 10.0, object: infoView)
        infoView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        let titleView = UIView(frame: CGRect(x: 10, y: 5, width: self.view.frame.width - 20, height: 50))
        roundCorner(UIRectCorner.TopLeft, radius: 10, object: titleView)
        roundCorner(UIRectCorner.TopRight, radius: 10, object: titleView)
        titleView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        let title = UILabel(frame: CGRect(x: 50, y: 20, width: self.view.frame.width - 125, height: 30))
        title.text = String(findDogWithID(theReminders[indexPath.row].reminderDogId!)!.name)
        title.textColor = PixelColor(theDog!.photo!, x: (title.center.x)/(self.view.frame.width/theDog!.photo!.size.width), y: (title.center.y + cell.frame.minY)/(self.view.frame.width/theDog!.photo!.size.width))
        let photo = UIImageView(image: findDogWithID(theReminders[indexPath.row].reminderDogId!)!.photo)
        photo.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        photo.layer.cornerRadius = 4
        photo.layer.masksToBounds = true
        let timeOff = UILabel(frame: CGRect(x: self.view.frame.width - 120, y: 20, width: 110, height: 30))
        let calendar = NSCalendar.currentCalendar().components([.Day, .Hour, .Minute], fromDate: NSDate(), toDate: theReminders[indexPath.row].firstLaunchTime, options: [])
        let weekday = NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())
        let timeSet = NSDateFormatter()
        timeSet.calendar = NSCalendar.currentCalendar()
        timeSet.dateStyle = .ShortStyle
        timeSet.timeZone = NSTimeZone.defaultTimeZone()
        timeSet.timeStyle = .ShortStyle
        let newStringDate: NSString = getDate(NSDate())
        var stringDate: NSString = getDate(theReminders[indexPath.row].firstLaunchTime)
        var stringHour: NSString = getTime(theReminders[indexPath.row].firstLaunchTime)
        let month = Int(String(newStringDate.characterAtIndex(0)) + String(newStringDate.characterAtIndex(1)))
        let today = String(newStringDate.characterAtIndex(3)) + String(newStringDate.characterAtIndex(4))
        let reminderDay = String(stringDate.characterAtIndex(3)) + String(stringDate.characterAtIndex(4))
        var reminderHour = Int(String(stringHour.characterAtIndex(0)) + String(stringHour.characterAtIndex(1)))
        var am = true
        
        if calendar.minute == 0 && calendar.hour == 0 {
            timeOff.text = "Now"
        } else if calendar.hour == 0 {
            timeOff.text = String(calendar.minute) + " m ago"
        } else if calendar.hour <= 3 {
            timeOff.text = String(calendar.hour) + " h ago"
        } else if Int(today) == Int(reminderDay) {
            if reminderHour > 12 {
                reminderHour = reminderHour! - 12
                am = false
            }
            if reminderHour >= 10 {
                replacingACharacterAtIndex(0, range: 2, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.removeAtIndex(replaceStringHour.startIndex)
                stringHour = String(replaceStringHour)
                replacingACharacterAtIndex(0, range: 1, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            }
            timeOff.text = stringHour as String
            
        } else if Int(today)! - 1 == Int(reminderDay) || Int(today) == 1 && calendar.day <= 1 {
            if reminderHour > 12 {
                reminderHour = reminderHour! - 12
                am = false
            }
            if reminderHour >= 10 {
                replacingACharacterAtIndex(0, range: 2, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.removeAtIndex(replaceStringHour.startIndex)
                stringHour = replaceStringHour
                replacingACharacterAtIndex(0, range: 1, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            }
            let newString =  "Yesterday \(stringHour)"
            timeOff.text = newString
        }  else if Int(today)! - Int(reminderDay)! <= 6 || Int(today) <= 7 && calendar.day <= 6 {
            if reminderHour > 12 {
                reminderHour = reminderHour! - 12
                am = false
            }
            if reminderHour >= 10 {
                replacingACharacterAtIndex(0, range: 2, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.removeAtIndex(replaceStringHour.startIndex)
                stringHour = replaceStringHour
                replacingACharacterAtIndex(0, range: 1, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            }
            let newString =  Weekday(weekday) + (stringHour as String)
            timeOff.text = newString
        } else {
            if reminderHour > 12 {
                reminderHour = reminderHour! - 12
                am = false
            }
            if reminderHour >= 10 {
                replacingACharacterAtIndex(0, range: 2, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.removeAtIndex(replaceStringHour.startIndex)
                stringHour = replaceStringHour
                replacingACharacterAtIndex(0, range: 1, pString: String(reminderHour), string: stringHour)
                if am {
                    stringHour.stringByAppendingString(" AM")
                } else {
                    stringHour.stringByAppendingString(" PM")
                }
            }
            if month < 10 {
                var replaceStringMonth: String = stringDate as String
                replaceStringMonth.removeAtIndex(replaceStringMonth.startIndex)
                stringDate = replaceStringMonth
            }
            if Int(today) < 10 {
                var replaceStringDay: String = stringDate as String
                replaceStringDay.removeAtIndex(replaceStringDay.startIndex.advancedBy(3))
                stringDate = replaceStringDay
            }
            let newString =  Weekday(weekday) + (stringHour as String)
            timeOff.text = newString
        }
        return cell
    }
    func Weekday(weekDayInt: Int) -> String{
        switch weekDayInt {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
        }
    }
    func replacingACharacterAtIndex(pIndex : Int, range: Int, pString : String, string: NSString) -> NSString{
        
        return string.stringByReplacingCharactersInRange(NSRange(location: pIndex, length: range), withString: String(pString))
    }
    
    func getTime(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    func getDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.stringFromDate(date)
    }
    func PixelColor (image: UIImage, x: CGFloat, y: CGFloat) -> UIColor {
    
        let pixelData: CFDataRef = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))!
        let data = CFDataGetBytePtr(pixelData)
    
        let pixelInfo = ((image.size.width  * y) + x ) * 4 // The image is png
    
        let red = data[Int(pixelInfo)]         // If you need this info, enable it
        let green = data[(Int(pixelInfo) + 1)] // If you need this info, enable it
        let blue = data[Int(pixelInfo) + 2]    // If you need this info, enable it
        let alpha = data[Int(pixelInfo) + 3]   // I need only this info for my maze game
    
        let color = UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha)) // The pixel color info
        return color
    
    }
    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(theReminders, toFile: reminders.archiveURL!.path!)
        if !isSuccessfulSave {
        }
    }
    func saveEveryReminder() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allTheReminders, toFile: EveryReminder.archiveURL!.path!)
        if !isSuccessfulSave {
        }
    }
    func loadReminders() -> [reminders]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(reminders.archiveURL!.path!) as? [reminders]
    }
    func loadEveryReminder() -> [EveryReminder]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(EveryReminder.archiveURL!.path!) as? [EveryReminder]
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dog.archiveURL!.path!) as? [dog]
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
