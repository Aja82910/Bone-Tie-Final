/*
The MIT License (MIT)

Copyright (c) 2015 AhmetKeskin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import AVKit
import MapKit
import CoreLocation

class LocalNotificationHelper: NSObject {
    
    let LOCAL_NOTIFICATION_CATEGORY : String = "LocalNotificationCategory"
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> LocalNotificationHelper {
        struct Singleton {
            static var sharedInstance = LocalNotificationHelper()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - Schedule Notification

    func scheduleNotification(_ title: String, message: String, seconds: Double, userInfo: [AnyHashable: Any]?, theDog: dog?, theRegion: CLCircularRegion?, soundName: String?, theCalenderInterval: NSCalendar.Unit?, theDates: [Date]?, regionTriggersOnce: Bool) -> UILocalNotification {
        let date = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let notification = notificationWithTitle(title, message: message, date: date, userInfo: userInfo, soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        if let Dog = theDog {
            if Dog.sound != "Default" {
                notification.soundName = Dog.sound
            } else {
                notification.soundName = UILocalNotificationDefaultSoundName
            }
        } else if let sound = soundName {
            notification.soundName = sound
        } else {
            notification.soundName = UILocalNotificationDefaultSoundName
        }
        if let region = theRegion {
            notification.region = region
            notification.regionTriggersOnce = regionTriggersOnce
        }
        if let calendarInterval = theCalenderInterval {
            notification.repeatInterval = calendarInterval
        }
        if let dates = theDates {
            for date in dates {
                let NotficationDate = date
                let NewNotification = notificationWithTitle(title, message: message, date: NotficationDate, userInfo: userInfo, soundName: nil, hasAction: true)
                if date == dates[dates.count - 1] {
                    if let region = theRegion {
                        NewNotification.region = region
                        NewNotification.regionTriggersOnce = regionTriggersOnce
                    }
                }
                NewNotification.category = LOCAL_NOTIFICATION_CATEGORY
                if let Dog = theDog {
                    if Dog.sound != "Default" {
                        NewNotification.soundName = Dog.sound
                    } else {
                        NewNotification.soundName = UILocalNotificationDefaultSoundName
                    }
                } else if let sound = soundName {
                    NewNotification.soundName = sound
                } else {
                    NewNotification.soundName = UILocalNotificationDefaultSoundName
                }
                UIApplication.shared.scheduleLocalNotification(NewNotification)
                if date == dates[dates.count - 1] {
                        return NewNotification
                }
            }
        }
        UIApplication.shared.scheduleLocalNotification(notification)
        return notification
    }
    
    func scheduleNotification(_ title: String, message: String, date: Date, soundName: String, userInfo: [AnyHashable: Any]?){
        let notification = notificationWithTitle(title, message: message, date: date, userInfo: userInfo, soundName: soundName, hasAction: true)
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    func scheduleNotification(_ title: String, message: String, seconds: Double, userInfo: [AnyHashable: Any]?) {
        let date = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let notification = notificationWithTitle(title, message: message, date: date, userInfo: userInfo, soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        notification.soundName = UILocalNotificationDefaultSoundName
         UIApplication.shared.scheduleLocalNotification(notification)
    }
    // MARK: - Present Notification
    
    func presentNotification(_ title: String, message: String, soundName: String, userInfo: [AnyHashable: Any]?) {
        let notification = notificationWithTitle(title, message: message, date: nil, userInfo: userInfo, soundName: nil, hasAction: true)
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    // MARK: - Create Notification
    
    func notificationWithTitle(_ title: String, message: String, date: Date?, userInfo: [AnyHashable: Any]?, soundName: String?, hasAction: Bool) -> UILocalNotification {
        
        let dct : Dictionary<String,AnyObject> = userInfo as! Dictionary<String,AnyObject>
       // dct["key"] = NSString(string: key) as String
        
        let notification = UILocalNotification()
        notification.alertAction = title
        notification.alertBody = message
        notification.userInfo = dct
        notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
        notification.fireDate = date
        notification.hasAction = hasAction
        return notification
    }
    
    /*func getNotificationwithKey(key : String) -> UILocalNotification {
        
        var notif : UILocalNotification?
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! where notification.userInfo!["key"] as! String == key{
            notif = notification
            break
        }
        
        return notif!
    }
    
    func cancelNotificationWithKey(key : String){
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! where notification.userInfo!["key"] as! String == key{
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            break
        }
    }*/
    
    func getAllNotifications() -> [UILocalNotification]? {
        return UIApplication.shared.scheduledLocalNotifications
    }
    
    func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func registerUserNotificationWithActionButtons(actions : [UIUserNotificationAction]){
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = LOCAL_NOTIFICATION_CATEGORY
        
        category.setActions(actions, for: UIUserNotificationActionContext.default)
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: NSSet(object: category) as? Set<UIUserNotificationCategory>)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func registerUserNotification(){
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func createUserNotificationActionButton(identifier : String, title : String) -> UIUserNotificationAction{
        
        let actionButton = UIMutableUserNotificationAction()
        actionButton.identifier = identifier
        actionButton.title = title
        actionButton.activationMode = UIUserNotificationActivationMode.background
        actionButton.isAuthenticationRequired = true
        actionButton.isDestructive = false
        
        return actionButton
    }
    
}
