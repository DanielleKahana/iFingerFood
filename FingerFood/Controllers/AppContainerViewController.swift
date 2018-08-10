//
//  AppContainerViewController.swift
//  FingerFood
//
//  Created by Mac on 10/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AppContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
    }
    

}
