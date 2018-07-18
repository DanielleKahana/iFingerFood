//
//  LoginViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        //check cardentials()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "MainViewController")
        navigationController?.pushViewController(viewController, animated: true)
        
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
