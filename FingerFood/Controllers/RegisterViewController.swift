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
    @IBOutlet weak var registerBtn: UIButton!
    
    private var dataHandler: DataManager? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataHandler = DataManager.getInstance()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let emailImage = UIImage(named: "email")
        addLeftImageToTextField(txtField: emailTextField, image: emailImage!)
        
        let lockImage = UIImage(named: "password")
        addLeftImageToTextField(txtField: passwordTextField, image: lockImage!)
        
        let profileImage = UIImage(named: "user")
        addLeftImageToTextField(txtField: firstNameTextField, image: profileImage!)
        addLeftImageToTextField(txtField: lastNameTextField, image: profileImage!)
        
        CAGradientLayer().addGradientLayer(view: view)
        let registerColor = UIColor(red: 245, green: 245, blue: 222).cgColor
        registerBtn.addBorderLine(color: registerColor)
        
    }
    
  
    func addLeftImageToTextField(txtField : UITextField , image : UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImage.image = image
        txtField.leftView = leftImage
        txtField.leftViewMode = .always
    }

    @IBAction func registerBtnPressed(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in ()   }
        )

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
                if let userId = user?.user.uid{
                    User.getInstance().setUserID(userId: userId)
                    self.dataHandler?.addNewUserToData(uid: userId, firstName: firstName, lastName: LastName)
                    self.dataHandler?.readUserName(userId: userId)
                    self.dataHandler?.readData(userId: userId, callback: {
                        SVProgressHUD.dismiss()
                        self.showWelcomeMessage()
                    })
                    
                }
            }
           
        })
    }
    
   
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
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
    


