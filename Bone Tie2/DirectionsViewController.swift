//
//  DirectionsViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 6/5/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {
    var directionsType: String?
    var directions:  String?
    var directionsTime: String?
    var theDirections = UITextView()
    var theDirectionsType = UILabel()
    var dogs: dog?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = dogs?.name
        theDirectionsType.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width - 10, height: 200))
        theDirectionsType.center = CGPoint(x: self.view.center.x, y: 100)
        theDirectionsType.font = UIFont(name: "Chalkduster", size: 16)
        theDirectionsType.text = "Directions Type: " + directionsType!
        theDirectionsType.numberOfLines = 2
        theDirectionsType.textAlignment = .Center
        if directionsType != String?("None") {
            theDirectionsType.text = "Directions Type: " + directionsType! + " \n" + "Directions Time: " + directionsTime!
            print(directionsTime)
            theDirections.textAlignment = .Center
            theDirections.frame = CGRect(origin: CGPoint(x: 5, y: 110), size: CGSize(width: self.view.frame.width - 10, height: self.view.frame.height - 160))
            theDirections.center = CGPoint(x: self.view.center.x, y: self.theDirections.center.y)
            theDirections.font = UIFont(name: "Chalkduster", size: 11)
            theDirections.text = "Directions \n" + directions!
            theDirections.userInteractionEnabled = true
            theDirections.editable = false
            print(theDirections)
            print(theDirectionsType)
            self.view.addSubview(theDirections)
        }
        print(theDirectionsType)
        self.view.addSubview(theDirectionsType)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
