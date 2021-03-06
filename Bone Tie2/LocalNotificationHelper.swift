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

    func scheduleNotification(title: String, message: String, seconds: Double, userInfo: [NSObject: AnyObject]?, theDog: dog?, theRegion: CLCircularRegion?, soundName: String?, theCalenderInterval: NSCalendarUnit?, theDates: [NSDate]?, regionTriggersOnce: Bool) -> UILocalNotification {
        let date = NSDate(timeIntervalSinceNow: NSTimeInterval(seconds))
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
                UIApplication.sharedApplication().scheduleLocalNotification(NewNotification)
                if date == dates[dates.count - 1] {
                        return NewNotification
                }
            }
        }
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        return notification
    }
    
    func scheduleNotification(title: String, message: String, date: NSDate, soundName: String, userInfo: [NSObject: AnyObject]?){
        let notification = notificationWithTitle(title, message: message, date: date, userInfo: userInfo, soundName: soundName, hasAction: true)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    func scheduleNotification(title: String, message: String, seconds: Double, userInfo: [NSObject: AnyObject]?) {
        let date = NSDate(timeIntervalSinceNow: NSTimeInterval(seconds))
        let notification = notificationWithTitle(title, message: message, date: date, userInfo: userInfo, soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        notification.soundName = UILocalNotificationDefaultSoundName
         UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    // MARK: - Present Notification
    
    func presentNotification(title: String, message: String, soundName: String, userInfo: [NSObject: AnyObject]?) {
        let notification = notificationWithTitle(title, message: message, date: nil, userInfo: userInfo, soundName: nil, hasAction: true)
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    // MARK: - Create Notification
    
    func notificationWithTitle(title: String, message: String, date: NSDate?, userInfo: [NSObject: AnyObject]?, soundName: String?, hasAction: Bool) -> UILocalNotification {
        
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
        return UIApplication.sharedApplication().scheduledLocalNotifications
    }
    
    func cancelAllNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func registerUserNotificationWithActionButtons(actions actions : [UIUserNotificationAction]){
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = LOCAL_NOTIFICATION_CATEGORY
        
        category.setActions(actions, forContext: UIUserNotificationActionContext.Default)
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: NSSet(object: category) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func registerUserNotification(){
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func createUserNotificationActionButton(identifier identifier : String, title : String) -> UIUserNotificationAction{
        
        let actionButton = UIMutableUserNotificationAction()
        actionButton.identifier = identifier
        actionButton.title = title
        actionButton.activationMode = UIUserNotificationActivationMode.Background
        actionButton.authenticationRequired = true
        actionButton.destructive = false
        
        return actionButton
    }
    
}