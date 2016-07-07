//
//  DogLocationViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 6/5/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import MapKit

class DogLocationViewController: UIViewController {
    var directions = String()
    var directionsType = String()
    var dogs: dog? = nil
    var directionTime = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(directions)
        print(directionsType)
        print(dogs?.name)
        print(directionTime)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Nearby" {
            let DestinationViewController = segue.destinationViewController as! NearbyBuildingsViewController
            DestinationViewController.dogs = self.dogs
        } else if segue.identifier == "LocationInfo" {
            let DestinationViewController = segue.destinationViewController as! DogsLocationInfo
            DestinationViewController.dogs = self.dogs
            DestinationViewController.traveltimes = self.directionTime
            DestinationViewController.TypeofDirections = self.directionsType
        } else {
            let DestinationViewController = segue.destinationViewController as! DirectionsViewController
            DestinationViewController.directionsType = self.directionsType
            DestinationViewController.directions = self.directions
            DestinationViewController.directionsTime = self.directionTime
            DestinationViewController.dogs = self.dogs
        }
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
