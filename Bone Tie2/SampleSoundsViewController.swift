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
    var AddDogSound: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.Next))
        navigationItem.setRightBarButton(nextButton, animated: false)
        pickerView.delegate = self
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 75, height: self.view.frame.width - 150)
        pickerView.center = self.view.center
        pickerView.tintColor = UIColor.orange
        self.view.backgroundColor = UIColor.blue
        play.setImage(self.imageFromSystemBarButton(.play), for: UIControlState())
        play.frame = CGRect(x: 0, y: pickerView.frame.maxY + 15, width: 40, height: 40)
        play.center = CGPoint(x: self.view.center.x, y: play.center.y)
        play.addTarget(self, action: #selector(self.playTapped), for: .touchUpInside)
        pickerView.tintColor = UIColor.orange
        self.view.addSubview(pickerView)
        self.view.addSubview(play)
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayback)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                DispatchQueue.main.async {
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
        self.performSegue(withIdentifier: "AddDogImage", sender: self)
    }
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        failLabel.text = "Recording failed: please ensure the app has access to your speakers."
        failLabel.numberOfLines = 0
        self.view.addSubview(failLabel)
    }
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    func imageFromSystemBarButton(_ systemItem: UIBarButtonSystemItem)-> UIImage {
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        for view in itemView.subviews {
            if view.isKind(of: UIButton.self){
                let button = view as! UIButton
                return button.imageView!.image!
            }
        }
        
        return UIImage()
    }
    func playTapped() {
        var audioURL: URL!
        if self.pickerData[pickerView.selectedRow(inComponent: 0)] != "Default" {
            audioURL = URL(fileURLWithPath: Bundle.main.path(forResource: pickerData[pickerView.selectedRow(inComponent: 0)] + ".mp3", ofType: nil)!)
            print("printing")
            do {
                voicePlayer = try AVAudioPlayer(contentsOf: audioURL!)
                voicePlayer.volume = 1
                print(voicePlayer.url!)
                voicePlayer.prepareToPlay()
                voicePlayer.play()
            } catch {
                let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }

        } else {
            let systemSound: SystemSoundID = 1315
            AudioServicesPlaySystemSound(systemSound)
        }
       // print(audioURL)
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddDogImage" {
            let destinationViewController = segue.destination as! AddDogImage
            let audioURL: String!
            destinationViewController.AddDogName = AddDogName
            destinationViewController.AddDogCity = AddDogCity
            destinationViewController.AddDogCode = AddDogCode
            destinationViewController.AddDogBreed = AddDogBreed
            destinationViewController.AddDogColor = AddDogColor
            audioURL = pickerData[pickerView.selectedRow(inComponent: 0)] + ".mp3"
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
