//
//  AppManager.swift
//  FingerFood
//
//  Created by Mac on 10/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class AppManager {
    static let shared  = AppManager()
    
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: AppContainerViewController!
    
    private init() {}
    
    
    func showApp() {
        var viewController: UIViewController
        if Auth.auth().currentUser == nil {
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        }
        appContainer.present(viewController, animated: true, completion: nil)
    }
    
    func logout() {
        
    }
}
