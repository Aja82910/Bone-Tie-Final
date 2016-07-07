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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if let savedReminders = loadReminders() {
            theReminders += savedReminders
        }*/
        tableView.backgroundView = UIImageView(image: theDog?.photo)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let infoView = UIView(frame: CGRect(x: 10, y: 55, width: self.view.frame.width - 20, height: cell.frame.height - 50))
        roundCorner(UIRectCorner.BottomLeft, radius: 10.0, object: infoView)
        roundCorner(UIRectCorner.BottomRight, radius: 10.0, object: infoView)
        infoView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        let titleView = UIView(frame: CGRect(x: 10, y: 5, width: self.view.frame.width - 20, height: 50))
        roundCorner(UIRectCorner.TopLeft, radius: 10, object: titleView)
        roundCorner(UIRectCorner.TopRight, radius: 10, object: titleView)
        titleView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        let title = UILabel(frame: CGRect(x: 50, y: 20, width: self.view.frame.width - 70, height: 30))
        title.text = String(theReminders[0].reminderDog!.name)
        //title.textColor = PixelColor(
        let photo = UIImageView(image: theReminders[0].reminderDog!.photo)
        photo.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        photo.layer.cornerRadius = 4
        photo.layer.masksToBounds = true
        return cell
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
    func loadReminders() -> [reminders]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(reminders.archiveURL!.path!) as? [reminders]
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
