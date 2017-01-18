//
//  AppDelegate.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 11/13/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var allTheReminders = [EveryReminder]()

    var window: UIWindow?
	let ACTION_ONE_IDENTIFIER : String = "ACTION_ONE_IDENTIFIER"
	let ACTION_TWO_IDENTIFIER : String = "ACTION_TWO_IDENTIFIER"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		let actionOne = LocalNotificationHelper.sharedInstance().createUserNotificationActionButton(identifier: ACTION_ONE_IDENTIFIER, title: "Done")
		let actionTwo = LocalNotificationHelper.sharedInstance().createUserNotificationActionButton(identifier: ACTION_TWO_IDENTIFIER, title: "Snooze")
		
		let actions = [actionOne,actionTwo]
		
		LocalNotificationHelper.sharedInstance().registerUserNotificationWithActionButtons(actions: actions)
		/*let application = UIApplication.sharedApplication()
		application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))*/
        // Override point for customization after application launch.
		//let container = CKContainer.defaultContainer()
		
		//let publicDatabase = container.publicCloudDatabase
		//let privateDatabase = container.privateCloudDatabase
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		print(notification.userInfo!["dogID"] as! Int)
		//allTheReminders.append(EveryReminder(reminderDogID: notification.userInfo!["dogID"] as! Int, name: notification.userInfo!["type"] as! String, photo: nil, launchDate: NSDate(), location: nil, range: nil, reminderID: notification.userInfo!["ID"] as! Int, snoozed: false)!)
		//Mixpanel.sharedInstance().track("User Tapped Notification", properties:["":""])
		print("notification - tapped")
		
	}
	func applicationDidFinishLaunching(_ application: UIApplication) {
		if !UserDefaults.standard.bool(forKey: "CompletedTutorial") {
			UserDefaults.standard.set(false, forKey: "CompletedTutorial")
		}
	}
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		if let pushInfo = userInfo as? [String: NSObject] {
			let notification = CKNotification(fromRemoteNotificationDictionary: pushInfo)
			
			let ac = UIAlertController(title: "What's that Breed?", message: notification.alertBody, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			
			if let nc = window?.rootViewController as? UINavigationController {
				if let vc = nc.visibleViewController {
					vc.present(ac, animated: true, completion: nil)
				}
			}
		}
	}
	
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
		
		if identifier == ACTION_ONE_IDENTIFIER {
			
			NotificationCenter.default.post(name: Notification.Name(rawValue: ACTION_ONE_IDENTIFIER), object: nil)
			
		}else if identifier == ACTION_TWO_IDENTIFIER {
			self.alarm = Alarm(hour: 23, minute: 39, {
				debugPrint("Alarm Triggered!")
			})
			let dog = findDogWithID(notification.userInfo!["dogID"] as! NSNumber as Int)
			addReminder(dog!, type: (notification.userInfo!["type"]) as! String)
			NotificationCenter.default.post(name: Notification.Name(rawValue: ACTION_TWO_IDENTIFIER), object: nil)
		}
		
		completionHandler()
	}
	var alarm: Alarm!
	func addReminder(_ theDog: dog, type: String) {
		self.alarm.turnOn()
		let secondsFromNow: TimeInterval = (Double(600))
		if self.alarm.isOn  {
			let userInfo = ["url": "www.mobiwise.co"]
			if type == "Food" {
				LocalNotificationHelper.sharedInstance().scheduleNotification( "Food", message: "Don't forget to feed \(theDog.name)", seconds: secondsFromNow, userInfo: userInfo)
			} else {
				LocalNotificationHelper.sharedInstance().scheduleNotification("Medicine", message: "Don't forget to give \(Medicine) to \(theDog.name)", seconds: secondsFromNow, userInfo: userInfo)
			}
		}
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
	func saveEveryReminder() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allTheReminders, toFile: EveryReminder.archiveURL!.path)
		if !isSuccessfulSave {
		}
	}
	func loadDogs() -> [dog]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
	}
	func loadEveryReminder() -> [dog]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: dog.archiveURL!.path) as? [dog]
	}


}

