//
//  SettingsTabViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/20/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTabViewController: UIViewController {

    @IBAction func logoutButtonTapped(_ sender: Any) {
        //Firebase logout
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            //Return to login/Create account page
            self.dismiss(animated: true, completion: nil)
            //self.performSegue(withIdentifier: "logoutSegue", sender: self)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
