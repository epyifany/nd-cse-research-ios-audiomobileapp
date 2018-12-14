//
//  ComposeViewController.swift
//  APP TEST TWO
//
//  Created by John Smith on 12/12/18.
//  Copyright © 2018 John Smith. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var ref:  DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Segment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            soundType[tempInt] = "Sound"
        }
        else{
            soundType[tempInt] = "Voice"
        }
        print(soundType)
    }
    
    @IBAction func addPost(_ sender: Any) {
//    self.ref?.child("Posts").childByAutoId().setValue(textView.text)

        list[tempInt] = textView.text
        tempInt = tempInt+1
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        
    }
    @IBAction func cancelPost(_ sender: Any) {
            presentingViewController?.dismiss(animated: true, completion: nil)
        
      
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
