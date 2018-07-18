//
//  ForgotPasswordViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    


}
