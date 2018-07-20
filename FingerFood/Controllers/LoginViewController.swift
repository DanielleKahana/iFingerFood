//
//  LoginViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            //show alert
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            //show alert
            return
        }
        
        showSpinner {
            // [START headless_email_auth]
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // [START_EXCLUDE]
                self.hideSpinner {
                    if let error = error {
                        self.showMessagePrompt(error.localizedDescription)
                        return
                    }
                    //self.navigationController!.popViewController(animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier:  "MainViewController")
                    navigationController?.pushViewController(viewController, animated: true)
                }
                // [END_EXCLUDE]
            }
            // [END headless_email_auth]
        }
        
        
        
    }
    
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "ForgotPasswordViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "RegisterViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    


}
