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

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var resetEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        CAGradientLayer().addGradientLayer(view: view)
        
        
        let emailImage = UIImage(named: "email")
        addLeftImageToTextField(txtField: resetEmailTextField, image: emailImage!)
        
        let resetColor = UIColor(red: 245, green: 245, blue: 222).cgColor
        resetBtn.addBorderLine(color: resetColor)

    }
    
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in ()   }
        )

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
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func addLeftImageToTextField(txtField : UITextField , image : UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImage.image = image
        txtField.leftView = leftImage
        txtField.leftViewMode = .always
    }
 
    


}
