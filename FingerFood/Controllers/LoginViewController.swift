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
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var dataHandler : DataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataHandler = DataManager.getInstance()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func HighlightErrorTextField(textField : UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = 5
    }
    
    
    @IBAction func passwordTextFieldEdit(_ sender: UITextField) {
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 0
        passwordTextField.layer.cornerRadius = 5
    }
    
    
    @IBAction func emailTextFieldEdit(_ sender: UITextField) {
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 0
        emailTextField.layer.cornerRadius = 5
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            HighlightErrorTextField(textField: emailTextField)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            HighlightErrorTextField(textField: passwordTextField)
            return
        }
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if !pred.evaluate(with: email) || password.count < 6 {
            self.view.makeToast("email or password inccorect!", duration: 3.0 , position: .bottom)
            return
        }
        
        
        SVProgressHUD.show()
            
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                self.view.makeToast("Couldn't sign in.. Please make sure you entered the right email and password", duration: 4.0 , position: .bottom)
                print("error creating user = \(String(describing: error))")
            }
            else {
                if user?.user.uid != nil {
                    let userId = user!.user.uid
                    self.dataHandler?.readUserLikesFromFirebase(userId: userId)
                    
                    let _ = UserData.getInstance()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier:  "MainViewController")
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }
                
            })
       
        
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
