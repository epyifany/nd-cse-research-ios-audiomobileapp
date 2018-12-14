//
//  ViewController.swift
//  APP TEST TWO
//
//  Created by John Smith on 11/14/18.
//  Copyright © 2018 John Smith. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase

var list = Array(repeating: "Edit Tag", count: 100)
var soundType = Array(repeating: "Sound", count: 100)

var tempInt = 0


class ViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource{
    var ref:  DatabaseReference?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var numberOfRecords: Int = 0
    var audioReference: StorageReference {
        return Storage.storage().reference().child("Audio")
    }
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    
    
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
        else{
            //stopping audio recording
            
            // Stop audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.set(numberOfRecords,forKey: "myNumber")
            myTableView.reloadData()
            
           buttonLabel.setTitle("Start Recording", for: .normal)
        
            
            //buttonLabel.setTitle("Start", for: .normal)
        }
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
        
        
        
        AVAudioSession.sharedInstance().requestRecordPermission {(hasPermission) in
            if hasPermission
            {
                print( "ACCEPTED")
            }
            
        }
    }

//    func uploadFileToFirebaseStorage(data: NSData, ){
//        let storageRef = Storage.storage().referenceWithPath("Audio/")
//    }
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
        

    
    //Setting Up Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfRecords
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)


        cell.textLabel?.text = String("\(indexPath.row + 1). " + list[indexPath.row])
        
        
        return cell
    }
    func updateAudio(Tag: String, Type: String, url: String, index: Int){
        let Audio = [
            "Tag": Tag,
            "Type": Type,
            "url": url
            ]
        
        self.ref?.child("Posts").child("Post\(index)").setValue(Audio)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
            
            let uploadAudioReference = audioReference.child("\(indexPath.row + 1).m4a")

//            print(getDirectory())
//            let uploadMetadata = StorageMetadata()
//            uploadMetadata.contentType = "audio/m4a"
            
            let uploadTask = uploadAudioReference.putFile(from: path, metadata: nil)

            

            let forestRef = Storage.storage().reference().child("Audio/\(indexPath.row + 1).m4a")
                
            forestRef.getMetadata { metadata, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
//                   print(metadata)
                }
            }
            forestRef.downloadURL { url, error in
                if let error = error {
                    // Handle any errors
                } else {
//                  print(url)
            
                self.updateAudio(Tag: list[indexPath.row], Type: soundType[indexPath.row], url: "\(url!)", index: indexPath.row)
                }
            }
           

//            self.ref?.child("Posts").childByAutoId().setValue(list[indexPath.row])
            uploadTask.resume()
            
            
            
        }
            
        catch {
            
        }
    }
    


}


