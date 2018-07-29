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
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        
        
        if !pred.evaluate(with: email) {
            self.view.makeToast("email is in bad format!", duration: 3.0 , position: .bottom)
            HighlightErrorTextField(textField: emailTextField)
            return
        }
        
        if  password.count < 6 {
            self.view.makeToast("password must be longer then 6 characters!", duration: 3.0 , position: .bottom)
            HighlightErrorTextField(textField: passwordTextField)
            return
        }
        
       
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                self.view.makeToast("Couldn't create user.. Please make sure you entered a valid details", duration: 4.0 , position: .bottom)
                print("error creating user = \(String(describing: error))")
                
            }
            else {
                print("unable to register")
                self.showWelcomeMessage()
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
    


