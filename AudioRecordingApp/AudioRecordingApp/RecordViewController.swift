//
//  RecordViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/15/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase

var list = [String]()
//var soundType = Array(repeating: "Sound", count: 100)
var numberOfRecords: Int = 0

class RecordViewController: UIViewController, AVAudioRecorderDelegate{
    var ref:  DatabaseReference?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
//    let defaults = UserDefaults.standard
    
    var audioReference: StorageReference {
        return Storage.storage().reference().child("Audio")
    }
    @IBOutlet weak var buttonLabel: UIButton!
    //    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func record(_ sender: Any) {
        //Checking if we have an active recorder
        if audioRecorder == nil
        {
            numberOfRecords += 1 //we give a recording a number to keep track
            
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            //start Audio Recording
            do
            {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                buttonLabel.setTitle("Stop Recording", for: .normal)
            }
            catch
            {
                displayAlert(title: "Oops!", message: "Recording failed")
            }
        }
        else {
            //stopping audio recording
            
            // Stop audio recording
            buttonLabel.setTitle("Start Recording", for: .normal)
            audioRecorder.stop()
            audioRecorder = nil
            UserDefaults.standard.set(numberOfRecords,forKey: "myNumber")
            
            self.performSegue(withIdentifier: "EditRecordingSegue", sender: self)
        }
    }
    
    //sending values to EditRecordingsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editRecordingsViewController = segue.destination as! EditRecordingsViewController
        editRecordingsViewController.filename = "\(numberOfRecords).m4a"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        ref = Database.database().reference()
        
        //Setting up session
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        if let myList:[String] = UserDefaults.standard.object(forKey: "myList") as? [String]
        {
            list = myList
            print(list)
        }
        
        
        AVAudioSession.sharedInstance().requestRecordPermission {(hasPermission) in
            if hasPermission
            {
                print( "ACCEPTED")
            }
            
        }
    }
    
    //function that gets path to the directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
    //function that display an alert
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateAudio(Tag: String, Type: String, url: String, index: Int){
        let Audio = [
            "Tag": Tag,
            "Type": Type,
            "url": url
        ]
        
        self.ref?.child("Posts").child("Post\(index)").setValue(Audio)
    }
}
