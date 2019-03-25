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

class EditRecordingsViewController: UIViewController {
    var ref:  DatabaseReference?
    var audioPlayer:AVAudioPlayer!
    var filename = String()
    var filesize = String()
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
            
            let path = getDirectory().appendingPathComponent(filename)
            
            let uploadAudioReference = audioReference.child(filename)
            
            let uploadTask = uploadAudioReference.putFile(from: path, metadata: nil)
            
            uploadTask.resume()
            print("Audio/\(filename)")
            
            let forestRef = Storage.storage().reference().child("Audio/\(filename)")
            forestRef.getMetadata { metadata, error in
                if error != nil {
                    print ("Metadata error")
                } else {
                    //TODO: Add Metadata to firebase
                    
                    self.filesize = ViewController.Units(bytes: metadata!.size).getReadableUnit()
                }
            }
            
            
            forestRef.downloadURL { url, error in
                if error != nil {
                    print ("download url error")
                    // Handle any errors
                } else {
                    print(tag)
                    print(self.filesize)
                    print("\(url!)")
                    self.updateAudio(UID: Auth.auth().currentUser!.uid, Tag: tag, Size: self.filesize, Type: "Sound", url: "\(url!)")
                }
            }
            
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
        super.viewDidLoad()
        ref = Database.database().reference()
        let path = getDirectory().appendingPathComponent(filename)
        
        let uploadAudioReference = audioReference.child(filename)
        
        let uploadTask = uploadAudioReference.putFile(from: path, metadata: nil)
        
        uploadTask.resume()
        // Do any additional setup after loading the view.
    }
    
    
    //TODO:
    func updateAudio(UID: String, Tag: String, Size: String, Type: String, url: String){
        let Audio = [
            "Tag": Tag,
            "Size": Size,
            "Type": Type,
            "url": url
        ]
        let UserAudio = [
            "User": UID,
            "Tag": Tag,
            "Size": Size,
            "Type": Type,
            "url": url
        ]
        self.ref?.child("User Audio Recordings").child(UID).setValue(Audio)
        self.ref?.child("All Audio Recordings").setValue(UserAudio)
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
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
