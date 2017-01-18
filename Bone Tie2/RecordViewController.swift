//
//  RecordViewController.swift
//  
//
//  Created by Alex Arovas on 6/8/16.
//
//Not used but can be used for recording messages

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var stackView: UIStackView!
    var recordButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var voiceRecorder: AVAudioRecorder!
    
    var playButton: UIButton!
    var prerecordedButton: UIButton!
    var voicePlayer: AVAudioPlayer!
    
    var AddDogName = String()
    var AddDogCode = String()
    var AddDogBreed = String()
    var AddDogCity = String()
    var AddDogColor = String()
    var AddDogSound: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Record Voice"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        navigationItem.setRightBarButton(cancelButton, animated: false)
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }
    
    func loadRecordingUI() {
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Tap to Record", for: UIControlState())
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        recordButton.addTarget(self, action: #selector(RecordViewController.recordTapped), for: .touchUpInside)
        stackView.addArrangedSubview(recordButton)
        prerecordedButton = UIButton()
        prerecordedButton.translatesAutoresizingMaskIntoConstraints = false
        prerecordedButton.setTitle("Or Choose a Sample Sound", for: UIControlState())
        prerecordedButton.isHidden = false
        prerecordedButton.alpha = 1
        prerecordedButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        prerecordedButton.addTarget(self, action: #selector(RecordViewController.sampleSounds), for: .touchUpInside)
        stackView.addArrangedSubview(prerecordedButton)
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", for: UIControlState())
        playButton.isHidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        playButton.addTarget(self, action: #selector(RecordViewController.playTapped), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)

    }
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        failLabel.text = "Recording failed: please ensure the app has access to your microphone."
        failLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(failLabel)
    }
    func recordTapped() {
        if voiceRecorder == nil {
            startRecording()
            UIView.animate(withDuration: 0.35, animations: { [unowned self] in
                self.prerecordedButton.isHidden = true
                self.prerecordedButton.alpha = 0
            }) 
            if !playButton.isHidden {
                UIView.animate(withDuration: 0.35, animations: { [unowned self] in
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                }) 
            }
        } else {
            finishRecording(success: true)
        }
    }
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    class func getWhistleURL() -> URL {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("whistle.m4a")
        let audioURL = URL(fileURLWithPath: audioFilename)
        
        return audioURL
    }
    func startRecording() {
        // 1
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        
        // 2
        recordButton.setTitle("Tap to Stop", for: UIControlState())
        
        // 3
        let audioURL = RecordViewController.getWhistleURL()
        print(audioURL.absoluteString)
        
        // 4
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
        
        do {
            // 5
            voiceRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            voiceRecorder.delegate = self
            voiceRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool) {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        voiceRecorder.stop()
        voiceRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: UIControlState())
            stackView.removeArrangedSubview(prerecordedButton)
            stackView.removeArrangedSubview(playButton)
            stackView.addArrangedSubview(playButton)
            stackView.addArrangedSubview(prerecordedButton)
            //stackView.insertArrangedSubview(prerecordedButton, atIndex: stackView.arrangedSubviews.count)
            if playButton.isHidden {
                UIView.animate(withDuration: 0.35, animations: { [unowned self] in
                    self.playButton.isHidden = false
                    self.playButton.alpha = 1
                    self.prerecordedButton.isHidden = false
                    self.prerecordedButton.alpha = 1
                }) 
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(RecordViewController.nextTapped))
        } else {
            recordButton.setTitle("Tap to Record", for: UIControlState())
            
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    func sampleSounds() {
        //Present a viewcontroller with all sample sounds
        self.performSegue(withIdentifier: "AddDogSampleSound", sender: self)
    }
    func nextTapped() {
        self.performSegue(withIdentifier: "AddDogImage", sender: self)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.gray
        
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.alignment = UIStackViewAlignment.center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        //VFL Visual Formatting Language
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant:0))
    }
    func playTapped() {
        let audioURL = RecordViewController.getWhistleURL()
        
        do {
            voicePlayer = try AVAudioPlayer(contentsOf: audioURL)
            voicePlayer.play()
        } catch {
            let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddDogImage" {
            let destinationViewController = segue.destinationViewController as! AddDogImage
            destinationViewController.AddDogName = AddDogName
            destinationViewController.AddDogCity = AddDogCity
            destinationViewController.AddDogCode = AddDogCode
            destinationViewController.AddDogBreed = AddDogBreed
            destinationViewController.AddDogColor = AddDogColor
            destinationViewController.AddDogSound = RecordViewController.getWhistleURL()
        } else if segue.identifier == "AddDogSampleSound" {
            let destinationViewController = segue.destinationViewController as! SampleSoundsViewController
            destinationViewController.AddDogName = AddDogName
            destinationViewController.AddDogCity = AddDogCity
            destinationViewController.AddDogCode = AddDogCode
            destinationViewController.AddDogBreed = AddDogBreed
            destinationViewController.AddDogColor = AddDogColor
        }
    }*/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
