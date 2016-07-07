//
//  TurorialViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 5/1/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import QuartzCore

class TurorialViewController: UIViewController {
    var SetupImage = UIImageView(image: UIImage(named: "Nimble"))
    let blur = UIBlurEffect(style: .Light)
    var blurView = UIVisualEffectView()
    var Yes = UIButton()
    var No = UIButton()
    var colorView = UIView()
    var Inviting = UILabel()
    var Start = UILabel()
    var Next = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(SetupImage)
        colorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        colorView.backgroundColor = UIColor.orangeColor()
        colorView.alpha = 0.2
        self.view.addSubview(colorView)
        blurView.effect = blur
        blurView.alpha = 0.8
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(blurView)
        Yes.backgroundColor = UIColor.clearColor()
        Yes.frame = CGRect(x: (self.view.frame.width - 300) / 3, y: 1.5 * (self.view.center.y) - 20, width: 150, height: 40)
        Yes.layer.borderWidth = 1.0
        Yes.layer.borderColor = self.view.tintColor.CGColor
        Yes.setTitle("Yes", forState: .Normal)
        Yes.setTitle("Yes", forState: .Selected)
        Yes.setTitleColor(self.view.tintColor, forState: .Normal)
        Yes.setTitleColor(self.view.tintColor, forState: .Selected)
        Yes.addTarget(self, action: #selector(self.Tutorial), forControlEvents: .TouchUpInside)
        No.backgroundColor = UIColor.clearColor()
        No.frame = CGRect(x: (((self.view.frame.width - 300) / 3) * 2) + 150, y: 1.5 * (self.view.center.y) - 20, width: 150, height: 40)
        No.layer.borderWidth = 1.0
        No.layer.borderColor = self.view.tintColor.CGColor
        No.setTitle("No", forState: .Normal)
        No.setTitle("No", forState: .Selected)
        No.setTitleColor(self.view.tintColor, forState: .Normal)
        No.setTitleColor(self.view.tintColor, forState: .Selected)
        No.addTarget(self, action: #selector(self.NoTutorial), forControlEvents: .TouchUpInside)
        Next.backgroundColor = UIColor.clearColor()
        Next.frame = CGRect(x: self.view.frame.width, y: self.view.center.y + 100, width: 150, height: 40)
        Next.center = CGPoint(x: self.view.center.x, y: Next.center.y)
        Next.layer.borderWidth = 1.0
        Next.layer.borderColor = self.view.tintColor.CGColor
        Next.setTitle("Next", forState: .Normal)
        Next.setTitle("Next", forState: .Selected)
        Next.setTitleColor(self.view.tintColor, forState: .Normal)
        Next.setTitleColor(self.view.tintColor, forState: .Selected)
        Next.addTarget(self, action: #selector(self.startTutorial), forControlEvents: .TouchUpInside)
        Next.alpha = 0.0
        Inviting.textColor = self.view.tintColor
        Inviting.text = "Would you like a short description on this app?"
        Inviting.font = UIFont(name: "Noteworthy-Light", size: 40)
        Inviting.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        Inviting.numberOfLines = 0
        Inviting.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
        Inviting.textAlignment = NSTextAlignment.Center
        Start.text = "This App is called Bone Tie. With this app you can control your Bone Tie device. Map, Lost Mode, Add a Dog, and your dog are the 4 main pages. Each one does exactly as it says. Map shows all your dogs on a map. Lost mode allows you to put your dogs in lost mode. Add a dog allows you to add a dog. Finnally, Your Dog provides information on your dog. Touch next to get satrted with Bone Tie."
        Start.numberOfLines = 0
        Start.textColor = self.view.tintColor
        Start.font = UIFont(name: "Noteworthy-Light", size: 24)
        Start.center = CGPoint(x: self.view.center.x, y: self.view.frame.height)
        Start.textAlignment = NSTextAlignment.Center
        Start.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        Start.alpha = 0.0
        self.view.addSubview(SetupImage)
        self.view.addSubview(colorView)
        self.view.addSubview(blurView)
        self.view.addSubview(Yes)
        self.view.addSubview(No)
        self.view.addSubview(Inviting)
        self.view.addSubview(Start)
        self.view.addSubview(Next)
        self.view.bringSubviewToFront(Inviting)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func NoTutorial() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CompletedTutorial")
        dismissViewControllerAnimated(true, completion: nil)
    }
    func Tutorial() {
        let duration = 1.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
            // each keyframe needs to be added here
            // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                self.Next.alpha = 1
                self.Start.alpha = 1
                self.Yes.alpha = 0
                self.No.alpha = 0
                self.Inviting.alpha = 0
            })
            }, completion: { finshed in
                
        })

    }
    func startTutorial() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CompletedTutorial")
        performSegueWithIdentifier("Started", sender: self)
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
