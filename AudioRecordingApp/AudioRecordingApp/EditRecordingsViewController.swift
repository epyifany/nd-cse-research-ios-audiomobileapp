//
//  EditRecordingsViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/21/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import CoreMedia


var recordingsList = [ViewController.Recording]()

class EditRecordingsViewController: UIViewController {
    var ref:  DatabaseReference?
    var audioPlayer:AVAudioPlayer!
    var filename = String()
    var filesize = String()
    var filedate = String()
    var filetime = String()
    var audioReference: StorageReference {
        return Storage.storage().reference().child("Audio")
    }
    
    @IBOutlet weak var tagTextField: UITextField!

    @IBAction func discardButtonTapped(_ sender: Any) {
        //TODO: Delete Audio File
    
        //Return to Record View Controller
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        //TODO: check if tag is empty
        
        //if tag
        if let tag = tagTextField.text{
            //Upload Audio Fille
            
            let path = getDirectory().appendingPathComponent(filename) //find audio filee URL
            let uploadAudioReference = audioReference.child(filename)  //prepare uploading
            let uploadTask = uploadAudioReference.putFile(from: path, metadata: nil)
            
            //Uploading files
            uploadTask.resume()
            print("Audio/\(filename)")
            let forestRef = Storage.storage().reference().child("Audio/\(filename)")
            
            //Obtain metadata from uploading the files
            forestRef.getMetadata { metadata, error in
                if error != nil {
                    print ("Metadata error")
                } else {

                    //find file size
                    print(metadata!.size)
                    self.filesize = ViewController.Units(bytes: metadata!.size).getReadableUnit()
                    print(self.filesize)

                    //find file uploaded time
                    let date = DateFormatter()
//                    dfs.dateStyle = .short
//                    dfs.timeStyle = .medium
//                    dfs.dateFormat = "MM/dd/yyyy HH:mm:ss"
                    date.dateFormat = "MM/dd/yyyy"
                    date.locale = Locale(identifier: "en_US_POSIX")
                    self.filedate = date.string(from: metadata!.timeCreated!)
                    let timefs = DateFormatter()
                    timefs.dateFormat = "HH:mm:ss"
                    timefs.locale = Locale(identifier: "en_US_POSIX")
                    self.filetime = timefs.string(from: metadata!.timeCreated!)
                }
            }
            
            //
            forestRef.downloadURL { url, error in
                if error != nil {
                    print ("download url error")
                    // Handle any errors
                } else {
                    let audioAsset = AVURLAsset.init(url: path, options: nil)
                    let duration = audioAsset.duration
                    //            let durationInSeconds = CMTimeGetSeconds(duration)
                    print(duration.timeString)
                    
                    //Upload into to firebase database
                    self.uploadAudioInfo(UID: Auth.auth().currentUser!.uid, Tag: tag, Length: duration.timeString, Size: self.filesize, Type: "Audio", url: "\(url!)", Date: self.filedate, Uptime: self.filetime)
                    self.saveAudioInfo(UID: Auth.auth().currentUser!.uid, Tag: tag, Length: duration.timeString, Size: self.filesize, Type: "Audio", url: "\(url!)", Date: self.filedate, Uptime: self.filetime, Filename: self.filename)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

                }
            }
            
            //Obtain audio duration
            
            
            list.append(numberOfRecords)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            UserDefaults.standard.set(list, forKey: "myList")
            print(list)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    

    @IBAction func replayButtonTapped(_ sender: Any) {
        print("replayButtonTapped")
        print(filename)
        
        let path = getDirectory().appendingPathComponent(filename)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch {
            
        }
    }
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        //Upload File
        ref = Database.database().reference()
        let path = getDirectory().appendingPathComponent(filename)
        let uploadAudioReference = audioReference.child(filename)
        let uploadTask = uploadAudioReference.putFile(from: path, metadata: nil)
        uploadTask.resume()
        
        if let blogData = UserDefaults.standard.data(forKey: "myRecordingsList"){
            print("Loading my recoding list in EditRecordingViewController")
            recordingsList = try! JSONDecoder().decode([ViewController.Recording].self, from: blogData)
        }
    }
    
    func saveAudioInfo(UID: String, Tag: String, Length: String, Size: String, Type: String, url: String, Date: String, Uptime: String, Filename: String){
        
        let audioID = getAudioID(UID: UID)
        var thisRecording = ViewController.Recording()
        thisRecording.filename = Filename
        thisRecording.AudioID = audioID
        thisRecording.Tag = Tag
        thisRecording.Length = Length
        thisRecording.Size = Size
        thisRecording.SoundType = Type
        thisRecording.url = url
        thisRecording.Date = Date
        thisRecording.Time = Uptime
        
        recordingsList.append(thisRecording)
        
        print("Count of the recording list: \(recordingsList.count)")
        
        if let encoded = try? JSONEncoder().encode(recordingsList) {
            UserDefaults.standard.set(encoded, forKey: "myRecordingsList")
        }
        //https://stackoverflow.com/questions/19720611/attempt-to-set-a-non-property-list-object-as-an-nsuserdefaults
        //https://stackoverflow.com/questions/32536227/converting-custom-class-object-into-nsdata
        //https://stackoverflow.com/questions/26469457/saving-custom-swift-class-with-nscoding-to-userdefaults

    }
    
    func uploadAudioInfo(UID: String, Tag: String, Length: String, Size: String, Type: String, url: String, Date: String, Uptime: String){
        
        //Find Audio ID
        let audioID = getAudioID(UID: UID)
        
        //Create JSONish audio data
        let Audio = [
            "AudioID": audioID,
            "Tag": Tag,
            "Length": Length,
            "Size": Size,
            "Type": Type,
            "url": url,
            "Date": Date,
            "Time": Uptime
        ]
        let UserAudio = [
            "User": UID,
            "Tag": Tag,
            "Length": Length,
            "Size": Size,
            "Type": Type,
            "url": url,
            "Date": Date,
            "Time": Uptime
        ]
        //Upload to firebase
        self.ref?.child("User Audio Recordings").child(UID).child(audioID).setValue(Audio)
        self.ref?.child("All Audio Recordings").child(audioID).setValue(UserAudio)
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func getAudioID(UID: String) -> String {
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        var numberOfRecordsStr = "\(1000 + numberOfRecords)"
        numberOfRecordsStr.remove(at: numberOfRecordsStr.startIndex)
        let audioID = UID + numberOfRecordsStr
        return audioID
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CMTime {
    var timeString: String {
        let sInt = Int(seconds)
        let s: Int = sInt % 60
        let m: Int = (sInt / 60) % 60
        let h: Int = sInt / 3600
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    var timeFromNowString: String {
        let d = Date(timeIntervalSinceNow: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        return dateFormatter.string(from: d)
    }
}
