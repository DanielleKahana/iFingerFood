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
            showAlert()
            return
        }
        guard let LastName = passwordTextField.text, !LastName.isEmpty else {
            showAlert()
            return
        }
        guard let email = passwordTextField.text, !email.isEmpty else {
            showAlert()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert()
            return
        }
        showSpinner()
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            self.hideSpinner();
            if user != nil {
                print("registered successfully!")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("error creating user!")
            }
           
        })
    }
    
    func showSpinner(){
        print("spinnnn")
    }
    
    func hideSpinner(){
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Oops!", message: "Please fill out all the fields in order to register", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
