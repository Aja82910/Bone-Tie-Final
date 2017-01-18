//
//  RemindersTableViewController.swift
//  
//
//  Created by Alex Arovas on 7/6/16.
//
//

import UIKit
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class RemindersTableViewController: UITableViewController {
    var theDog: dog?
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
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    var dismissedViewcontroller: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.image = UIImage(named: "Open")
        Open.title = ""
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        print(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        if let savedReminders = loadReminders() {
            theReminders += savedReminders
        }
        if let savedReminders = loadEveryReminder() {
            allTheReminders += savedReminders
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(tableView.reloadData), userInfo: !dismissedViewcontroller, repeats: true)
        tableView.backgroundView = UIImageView(image: theDog?.photo)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func remindersIntoDayReminders() {
        for reminder in theReminders {
            let weekday = (Calendar.current as NSCalendar).component(.weekday, from: reminder.created)
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
            let weekday = (Calendar.current as NSCalendar).component(.weekday, from: reminder.launchDate!)
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
    func sortReminders(_ weekday: Int, descending: Bool, all: Bool) {
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
                        sundayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        sundayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                        }
                    }
                case 2:
                    if descending {
                        mondayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        mondayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                        }
                }

                case 3:
                    if descending {
                        tuesdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        tuesdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                        }
                }

                case 4:
                    if descending {
                        wednesdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        wednesdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                        }
                }

                case 5:
                    if descending {
                        thursdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        thursdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                        }
                    }

                case 6:
                    if descending {
                        fridayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        fridayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                        }
                    }

                default:
                    if descending {
                        saturdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedDescending
                        }
                    } else {
                        saturdayReminders.sort {
                            return $0.created.compare($1.created) == ComparisonResult.orderedAscending
                    }
                }
            }
        }
    }
    func sortAllReminders(_ weekday: Int, descending: Bool, all: Bool) {
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
                        sundayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        sundayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                        }
                    }
                case 2:
                    if descending {
                        mondayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        mondayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                        }
                    }
                
                case 3:
                    if descending {
                        tuesdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        tuesdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                        }
                    }
                
                case 4:
                    if descending {
                        wednesdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        wednesdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                        }
                    }
                
                case 5:
                    if descending {
                        thursdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        thursdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                        }
                    }
                
                case 6:
                    if descending {
                        fridayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        fridayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                        }
                    }
                
                default:
                    if descending {
                        saturdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedDescending
                        }
                    } else {
                        saturdayAllReminders.sort {
                            return $0.launchDate!.compare($1.launchDate!) == ComparisonResult.orderedAscending
                    }
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        dismissedViewcontroller = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    func roundCorner(_ corners: UIRectCorner, radius: CGFloat, object: UIView) {
        let maskPath = UIBezierPath(roundedRect: object.frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = object.frame;
        maskLayer.path = maskPath.cgPath;
        object.layer.mask = maskLayer;
    }
    func findDogWithID(_ id: Int) -> dog? {
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let infoView = UIView(frame: CGRect(x: 10, y: 55, width: self.view.frame.width - 20, height: cell.frame.height - 50))
        roundCorner(UIRectCorner.bottomLeft, radius: 10.0, object: infoView)
        roundCorner(UIRectCorner.bottomRight, radius: 10.0, object: infoView)
        infoView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        let titleView = UIView(frame: CGRect(x: 10, y: 5, width: self.view.frame.width - 20, height: 50))
        roundCorner(UIRectCorner.topLeft, radius: 10, object: titleView)
        roundCorner(UIRectCorner.topRight, radius: 10, object: titleView)
        titleView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        let title = UILabel(frame: CGRect(x: 50, y: 20, width: self.view.frame.width - 125, height: 30))
        title.text = String(findDogWithID(theReminders[indexPath.row].reminderDogId!)!.name)
        title.textColor = PixelColor(theDog!.photo!, x: (title.center.x)/(self.view.frame.width/theDog!.photo!.size.width), y: (title.center.y + cell.frame.minY)/(self.view.frame.width/theDog!.photo!.size.width))
        let photo = UIImageView(image: findDogWithID(theReminders[indexPath.row].reminderDogId!)!.photo)
        photo.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        photo.layer.cornerRadius = 4
        photo.layer.masksToBounds = true
        let timeOff = UILabel(frame: CGRect(x: self.view.frame.width - 120, y: 20, width: 110, height: 30))
        let calendar = (Calendar.current as NSCalendar).components([.day, .hour, .minute], from: Date(), to: theReminders[indexPath.row].firstLaunchTime, options: [])
        let weekday = (Calendar.current as NSCalendar).component(.weekday, from: Date())
        let timeSet = DateFormatter()
        timeSet.calendar = Calendar.current
        timeSet.dateStyle = .short
        timeSet.timeZone = TimeZone.current
        timeSet.timeStyle = .short
        let newStringDate: NSString = getDate(Date()) as NSString
        var stringDate: NSString = getDate(theReminders[indexPath.row].firstLaunchTime) as NSString
        var stringHour: NSString = getTime(theReminders[indexPath.row].firstLaunchTime) as NSString
        let month = Int(String(newStringDate.character(at: 0)) + String(newStringDate.character(at: 1)))
        let today = String(newStringDate.character(at: 3)) + String(newStringDate.character(at: 4))
        let reminderDay = String(stringDate.character(at: 3)) + String(stringDate.character(at: 4))
        var reminderHour = Int(String(stringHour.character(at: 0)) + String(stringHour.character(at: 1)))
        var am = true
        
        if calendar.minute == 0 && calendar.hour == 0 {
            timeOff.text = "Now"
        } else if calendar.hour == 0 {
            timeOff.text = String(describing: calendar.minute) + " m ago"
        } else if calendar.hour <= 3 {
            timeOff.text = String(describing: calendar.hour) + " h ago"
        } else if Int(today) == Int(reminderDay) {
            if reminderHour > 12 {
                reminderHour = reminderHour! - 12
                am = false
            }
            if reminderHour >= 10 {
                replacingACharacterAtIndex(0, range: 2, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.remove(at: replaceStringHour.startIndex)
                stringHour = replaceStringHour as NSString
                replacingACharacterAtIndex(0, range: 1, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
                }
            }
            timeOff.text = stringHour as String
            
        } else if Int(today)! - 1 == Int(reminderDay) || Int(today) == 1 && calendar.day <= 1 {
            if reminderHour > 12 {
                reminderHour = reminderHour! - 12
                am = false
            }
            if reminderHour >= 10 {
                replacingACharacterAtIndex(0, range: 2, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.remove(at: replaceStringHour.startIndex)
                stringHour = replaceStringHour as NSString
                replacingACharacterAtIndex(0, range: 1, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
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
                replacingACharacterAtIndex(0, range: 2, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.remove(at: replaceStringHour.startIndex)
                stringHour = replaceStringHour as NSString
                replacingACharacterAtIndex(0, range: 1, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
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
                replacingACharacterAtIndex(0, range: 2, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
                }
            } else {
                var replaceStringHour: String = stringHour as String
                replaceStringHour.remove(at: replaceStringHour.startIndex)
                stringHour = replaceStringHour as NSString
                replacingACharacterAtIndex(0, range: 1, pString: String(describing: reminderHour), string: stringHour)
                if am {
                    stringHour.appending(" AM")
                } else {
                    stringHour.appending(" PM")
                }
            }
            if month < 10 {
                var replaceStringMonth: String = stringDate as String
                replaceStringMonth.remove(at: replaceStringMonth.startIndex)
                stringDate = replaceStringMonth as NSString
            }
            if Int(today) < 10 {
                var replaceStringDay: String = stringDate as String
                replaceStringDay.remove(at: replaceStringDay.characters.index(replaceStringDay.startIndex, offsetBy: 3))
                stringDate = replaceStringDay as NSString
            }
            let newString =  Weekday(weekday) + (stringHour as String)
            timeOff.text = newString
        }
        cell.addSubview(infoView)
        cell.addSubview(titleView)
        cell.addSubview(title)
        cell.addSubview(photo)
        cell.addSubview(timeOff)
        return cell
    }
    func Weekday(_ weekDayInt: Int) -> String{
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
    func replacingACharacterAtIndex(_ pIndex : Int, range: Int, pString : String, string: NSString) -> NSString{
        
        return string.replacingCharacters(in: NSRange(location: pIndex, length: range), with: String(pString)) as NSString
    }
    
    func getTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: date)
    }
    func PixelColor (_ image: UIImage, x: CGFloat, y: CGFloat) -> UIColor {
    
        let pixelData: CFData = image.cgImage!.dataProvider!.data!
        let data = CFDataGetBytePtr(pixelData)
    
        let pixelInfo = ((image.size.width  * y) + x ) * 4 // The image is png
    
        let red = data?[Int(pixelInfo)]         // If you need this info, enable it
        let green = data?[(Int(pixelInfo) + 1)] // If you need this info, enable it
        let blue = data?[Int(pixelInfo) + 2]    // If you need this info, enable it
        let alpha = data?[Int(pixelInfo) + 3]   // I need only this info for my maze game
    
        let color = UIColor(colorLiteralRed: Float(red!), green: Float(green!), blue: Float(blue!), alpha: Float(alpha!)) // The pixel color info
        return color
    
    }
    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(theReminders, toFile: reminders.archiveURL!.path)
        if !isSuccessfulSave {
        }
    }
    func saveEveryReminder() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allTheReminders, toFile: EveryReminder.archiveURL!.path)
        if !isSuccessfulSave {
        }
    }
    func loadReminders() -> [reminders]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: reminders.archiveURL!.path) as? [reminders]
    }
    func loadEveryReminder() -> [EveryReminder]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: EveryReminder.archiveURL!.path) as? [EveryReminder]
    }
    func loadDogs() -> [dog]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
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
