//
//  ProfileViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    private var userData : UserData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = UserData.getInstance()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUserName() {
        if let name = userData?.getUsername() {
            usernameLabel.text = name
        }else {
            print("error getting name")
        }
        
    }
    
    
  

}
