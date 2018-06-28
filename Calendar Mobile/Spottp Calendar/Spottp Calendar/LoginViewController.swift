//
//  LoginViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/28/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,  password: passwordTextField.text!) {
            (user, error) in
            print("We tried to sign in")
            
            if error != nil {
                print("error!")
                
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {
                    (user, error) in print ("We tried to create a user")
                    
                    if error != nil {
                        print("We have an error \(error!)")
                    } else {
                        print("Created user successfully!")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                })
            } else {
                print("Signed in successfully!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
}


