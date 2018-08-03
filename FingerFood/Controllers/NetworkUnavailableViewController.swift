//
//  NetworkUnavailableViewController.swift
//  FingerFood
//
//  Created by Mac on 03/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class NetworkUnavailableViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func retryBtnPressed(_ sender: Any) {
        if ConnectionManager.shared.isNetworkAvailable {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            self.view.makeToast("network unavailable, please check device settings.", duration: 3.0 , position: .center)
        }
        
    }
   
    

}
