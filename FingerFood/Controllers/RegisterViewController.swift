//
//  RegisterViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientBackground()
    }
    
    func createGradientBackground() {
        let background = CAGradientLayer()
        background.frame = self.view.bounds
        let startColor = UIColor(red: 27/255, green: 51/255 , blue: 89/255 , alpha: 1)
        let endColor = UIColor.white
        background.colors = [startColor.cgColor, endColor.cgColor]
        self.view.layer.insertSublayer(background, at: 0)
    }
    

    @IBAction func registerBtnPressed(_ sender: Any) {
        
        guard let firstName = emailTextField.text, !firstName.isEmpty else {
            //show alert
            return
        }
        guard let LastName = passwordTextField.text, !LastName.isEmpty else {
            //show alert
            return
        }
        guard let email = passwordTextField.text, !email.isEmpty else {
            //show alert
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            //show alert
            return
        }
        
        self.showSpinner {
            // [START create_user]
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // [START_EXCLUDE]
            self.hideSpinner {
                guard let email = authResult?.user.email, error == nil else {
                    self.showMessagePrompt(error!.localizedDescription)
                    return
                }
                print("\(email) created")
                self.navigationController!.popViewController(animated: true)
            }
            // [END_EXCLUDE]
        }
        
        
    }
    
   
    

}
