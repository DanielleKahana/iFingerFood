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
import CoreLocation


class LoginViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var dataHandler : DataManager? = nil
    
    //default values - afeka tel aviv
    var latitude : Double = 32.113619
    var longitude : Double = 34.818165
 
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectionManager.shared.startMonitoring()
        
        if ConnectionManager.shared.isNetworkAvailable {
            dataHandler = DataManager.getInstance()
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else {
            goToNetworkErrorVC()
        }
    }
    

    func goToNetworkErrorVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "NetworkUnavailableViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setUpButtons()
        User.getInstance().setLocation(latitude: self.latitude, longitude: self.longitude)

        if Auth.auth().currentUser != nil {
            SVProgressHUD.show()
            let userId = Auth.auth().currentUser?.uid
            login(id: userId!)
        }
 
        let emailImage = UIImage(named: "ic_email")
        addLeftImageToTextField(txtField: emailTextField, image: emailImage!)
        
        let lockImage = UIImage(named: "ic_lock")
        addLeftImageToTextField(txtField: passwordTextField, image: lockImage!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

 
    
    func addLeftImageToTextField(txtField : UITextField , image : UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImage.image = image
        txtField.leftView = leftImage
        txtField.leftViewMode = .always
    }
    
    @IBAction func passwordTextFieldEdit(_ sender: UITextField) {
        clearTextField(tf: passwordTextField)
    }
    
    @IBAction func emailTextFieldEdit(_ sender: UITextField) {
        clearTextField(tf: emailTextField)
    }
    
    func clearTextField(tf : UITextField) {
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0
        tf.layer.cornerRadius = 5
    }
    
    func HighlightErrorTextField(textField : UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = 5
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        
        animate(sender: sender)
  
        if ConnectionManager.shared.isNetworkAvailable == false  { goToNetworkErrorVC() }
        
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
            
            if error != nil {
                SVProgressHUD.dismiss()
                self.view.makeToast("Couldn't sign in.. Please make sure you entered the right email and password", duration: 4.0 , position: .bottom)
                print("error creating user = \(String(describing: error))")
            }
            else {
                
                if let userId = user?.user.uid {
                    self.login(id: userId)
                }
            }
            })
        }
    
    
    func login(id : String) {
        
        User.getInstance().setUserID(userId: id)
        self.dataHandler = DataManager.getInstance()
        self.dataHandler?.readUserName(userId: id)
        self.dataHandler?.readData(userId: id, callback: {
            SVProgressHUD.dismiss()
            self.goToMainVC()
        })
    }

    func goToMainVC() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier:  "MainViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
  
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "ForgotPasswordViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "RegisterViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            User.getInstance().setLocation(latitude: latitude, longitude: longitude)

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.view.makeToast("Location Unavailable")
    }
    
    func setUpButtons(){
        let signInColor = UIColor(red: 149, green: 174, blue: 212).cgColor
        let registerColor = UIColor(red: 230, green: 233, blue: 239).cgColor
        signinBtn.addBorderLine(color: signInColor)
        registerBtn.addBorderLine(color: registerColor)
    }
    
    func animate(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in ()   }
        )
    }
    
    
}

extension UIView {
    func addBorderLine(color: CGColor){
        layer.borderColor = color
        layer.borderWidth = 2
        roundedCorners(radius: 10)
    }
}



extension UITextField{
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

extension UIColor{
    convenience init(red: Int, green: Int, blue : Int){
        let newRed = CGFloat(red)/225
        let newGreen = CGFloat(green)/225
        let newBlue = CGFloat(blue)/225
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

