//
//  CreateAccountViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/13/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var languageProfTextField: UITextField!
    
    var ref:  DatabaseReference?
    
    @IBAction func backButton(_ sender: Any) {
        print("~from Create Account back to start ")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createAccountTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let age = ageTextField.text, let gender = genderTextField.text, let language = languageTextField.text, let proficiency = languageProfTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                print("register success!")
                
                self.updateProfile(UID: Auth.auth().currentUser!.uid, Email: email, Password: password, Name: name, Age: age, Gender : gender, Language : language, Proficiency : proficiency)
                
                self.performSegue(withIdentifier: "createAccountToTabSegue", sender: self)

            }
            
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    func updateProfile(UID: String, Email: String, Password: String, Name: String, Age: String, Gender: String, Language: String, Proficiency: String){
        let profile = [
            "Email": Email,
            "Password": Password,
            "Name": Name,
            "Age": Age,
            "Gender": Gender,
            "Language": Language,
            "Proficiency": Proficiency
        ]
        print(UID)
        print(Password)
        print(Email)
        print(Name)
        print(Age)
        
        
        self.ref?.child("User Profiles").child(UID).setValue(profile)
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
