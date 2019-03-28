//
//  RecordingInfoViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/25/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import AVFoundation



class RecordingInfoViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var recordingsList = [ViewController.Recording]()
    var file_no = Int()
    var currentRecording = ViewController.Recording()
    
    @IBOutlet weak var recordingInfoLabel: UILabel!
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
        let path = getDirectory().appendingPathComponent(currentRecording.filename!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch {
            
        }
//        print(recordingsList[list[file_no] - 1].AudioID!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let blogData = UserDefaults.standard.data(forKey: "myRecordingsList"){
            print("why")
            recordingsList = try! JSONDecoder().decode([ViewController.Recording].self, from: blogData)
        }
        print(list)
        print("file Number is: \(file_no)")
        print("recording list count is \(recordingsList.count)")
        print("working with index \(list[file_no] - 1)")
        currentRecording = recordingsList[list[file_no] - 1]
        
        recordingInfoLabel.numberOfLines = 0
        recordingInfoLabel.text = "Audio ID: " + currentRecording.AudioID! +
            "\nTime Created: " +  currentRecording.Date! + " " + currentRecording.Time! +
            "\nLength: " + currentRecording.Length! +
            "\nSize: " + currentRecording.Size! +
            "\nRecording type: " + currentRecording.SoundType! +
            "\nAudio tag" + currentRecording.Tag!
//            "\nRecording type" + currentRecording.SoundType!
        // Do any additional setup after loading the view.
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
