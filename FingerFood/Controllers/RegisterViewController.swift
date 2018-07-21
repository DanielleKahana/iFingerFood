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
import Toast_Swift
import SVProgressHUD

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
        removeHighlightFromAllTextFields()
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showMissingFieldAlert(textField: firstNameTextField)
            HighlightErrorTextField(textField: firstNameTextField)
            return
        }
        guard let LastName = lastNameTextField.text, !LastName.isEmpty else {
            showMissingFieldAlert(textField: lastNameTextField)
            HighlightErrorTextField(textField: lastNameTextField)
            return
        }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            showMissingFieldAlert(textField: emailTextField)
            HighlightErrorTextField(textField: emailTextField)
            return
        }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces), !password.isEmpty else {
            showMissingFieldAlert(textField: passwordTextField)
            HighlightErrorTextField(textField: passwordTextField)
            return
        }
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                print("registered successfully!")
                self.showWelcomeMessage()
            }
            else {
                self.view.makeToast("Couldn't create user.. Please make sure you entered a valid details", duration: 4.0 , position: .bottom)
                print("error creating user = \(String(describing: error))")
            }
           
        })
    }
    
   
    
    func HighlightErrorTextField(textField : UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = 5
    }
    
    func removeHighlightFromAllTextFields() {
        firstNameTextField.layer.borderColor = UIColor.gray.cgColor
        firstNameTextField.layer.borderWidth = 0
        firstNameTextField.layer.cornerRadius = 5
        
        lastNameTextField.layer.borderColor = UIColor.gray.cgColor
        lastNameTextField.layer.borderWidth = 0
        lastNameTextField.layer.cornerRadius = 5
        
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 0
        emailTextField.layer.cornerRadius = 5
        
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 0
        passwordTextField.layer.cornerRadius = 5
    }
    
    
    func showMissingFieldAlert(textField : UITextField){
        self.view.makeToast("Please fill out your \(textField.placeholder!) in order to register", duration: 3.0 , position: .center)
 }
    
    
    func showWelcomeMessage() {
        let alert = UIAlertController(title: "Welcome!", message: "Your user registered successfully!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier:  "MainViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

  
}
    


