//
//  PreferencesViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

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
        let startColor = UIColor(red: 245/255, green: 245/255 , blue: 220/255 , alpha: 1)
        let endColor = UIColor(red: 247/255, green: 247/255 , blue: 227/255 , alpha: 1)
        background.colors = [startColor.cgColor, endColor.cgColor]
        self.view.layer.insertSublayer(background, at: 0)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
