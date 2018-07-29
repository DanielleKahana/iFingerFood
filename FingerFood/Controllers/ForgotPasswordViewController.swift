//
//  ForgotPasswordViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var resetEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        
        guard let resetEmail = resetEmailTextField.text?.trimmingCharacters(in: .whitespaces), !resetEmail.isEmpty else {
            self.view.makeToast("Please enter email for reset instructions", duration: 3.0 , position: .bottom)
            return
        }
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if !pred.evaluate(with: resetEmail) {
            self.view.makeToast("email is in bad format!", duration: 3.0 , position: .bottom)
            return
        }
        
    
        SVProgressHUD.show()
        
        Auth.auth().sendPasswordReset(withEmail: resetEmail, completion: {(error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if error != nil {
                    self.view.makeToast("failed to reset password", duration: 3.0 , position: .bottom)
                    print("error = \(String(describing: error))")
                } else {
                    self.view.makeToast("reset email sent successfully!", duration: 3.0 , position: .bottom)
                }
            }
        })
        
    }
    
 
    


}
