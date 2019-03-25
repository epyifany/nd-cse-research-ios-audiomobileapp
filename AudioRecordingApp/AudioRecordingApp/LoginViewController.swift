//
//  LoginViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/13/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in

                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                print("login success!")
                self.performSegue(withIdentifier: "loginToTabSegue", sender: self)
            }
        }
    }
    @IBAction func loginBackButton(_ sender: UIButton) {
        print("~from Login back to start ")
        self.dismiss(animated: true, completion: nil)
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
