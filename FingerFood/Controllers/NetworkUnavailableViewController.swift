//
//  NetworkUnavailableViewController.swift
//  FingerFood
//
//  Created by Mac on 03/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class NetworkUnavailableViewController: UIViewController {

    
    @IBOutlet weak var retryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let retryColor = UIColor(red: 245, green: 245, blue: 222).cgColor
        retryBtn.addBorderLine(color: retryColor)
        CAGradientLayer().addGradientLayer(view: view)
    }
    

    
    @IBAction func retryBtnPressed(_ sender: UIButton) {
        
        animate(sender: sender)
        
        if ConnectionManager.shared.isNetworkAvailable {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            self.view.makeToast("network unavailable, please check device settings.", duration: 3.0 , position: .center)
        }
        
    }
    
    
    func animate(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in ()   }
        )
    }
   
    

}
