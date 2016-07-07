//
//  SampleSoundsViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 6/9/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import AVFoundation

class SampleSoundsViewController: UIViewController, UIPickerViewDelegate {
    let pickerData = ["Dog Bark", "Dog Bark 2", "Default", "Dog Whistle"] // Add More
    var pickerView = UIPickerView()
    var play = UIButton()
    var recordingSession: AVAudioSession!
    var voicePlayer: AVAudioPlayer!
    var AddDogName: String!
    var AddDogCode: String!
    var AddDogBreed: String!
    var AddDogCity: String!
    var AddDogColor: String!
    var AddDogSound: NSURL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(self.Next))
        navigationItem.setRightBarButtonItem(nextButton, animated: false)
        pickerView.delegate = self
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 75, height: self.view.frame.width - 150)
        pickerView.center = self.view.center
        pickerView.tintColor = UIColor.orangeColor()
        self.view.backgroundColor = UIColor.blueColor()
        play.setImage(self.imageFromSystemBarButton(.Play), forState: .Normal)
        play.frame = CGRect(x: 0, y: pickerView.frame.maxY + 15, width: 40, height: 40)
        play.center = CGPoint(x: self.view.center.x, y: play.center.y)
        play.addTarget(self, action: #selector(self.playTapped), forControlEvents: .TouchUpInside)
        pickerView.tintColor = UIColor.orangeColor()
        self.view.addSubview(pickerView)
        self.view.addSubview(play)
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayback)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if !allowed {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }


        // Do any additional setup after loading the view.
    }
    func Next() {
        self.performSegueWithIdentifier("AddDogImage", sender: self)
    }
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        failLabel.text = "Recording failed: please ensure the app has access to your speakers."
        failLabel.numberOfLines = 0
        self.view.addSubview(failLabel)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func imageFromSystemBarButton(systemItem: UIBarButtonSystemItem)-> UIImage {
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.valueForKey("view") as! UIView
        for view in itemView.subviews {
            if view.isKindOfClass(UIButton){
                let button = view as! UIButton
                return button.imageView!.image!
            }
        }
        
        return UIImage()
    }
    func playTapped() {
        var audioURL: NSURL!
        if self.pickerData[pickerView.selectedRowInComponent(0)] != "Default" {
            audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(pickerData[pickerView.selectedRowInComponent(0)] + ".mp3", ofType: nil)!)
            print("printing")
            do {
                voicePlayer = try AVAudioPlayer(contentsOfURL: audioURL!)
                voicePlayer.volume = 1
                print(voicePlayer.url!)
                voicePlayer.prepareToPlay()
                voicePlayer.play()
            } catch {
                let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(ac, animated: true, completion: nil)
            }

        } else {
            let systemSound: SystemSoundID = 1315
            AudioServicesPlaySystemSound(systemSound)
        }
       // print(audioURL)
    }

    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddDogImage" {
            let destinationViewController = segue.destinationViewController as! AddDogImage
            let audioURL: String!
            destinationViewController.AddDogName = AddDogName
            destinationViewController.AddDogCity = AddDogCity
            destinationViewController.AddDogCode = AddDogCode
            destinationViewController.AddDogBreed = AddDogBreed
            destinationViewController.AddDogColor = AddDogColor
            audioURL = pickerData[pickerView.selectedRowInComponent(0)] + ".mp3"
            destinationViewController.AddDogSound = audioURL
            print(audioURL)
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
