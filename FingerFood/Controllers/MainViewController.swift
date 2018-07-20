//
//  MainViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Koloda
import Firebase
import FirebaseAuth

private var numOfCards : Int = 5


class MainViewController: UIViewController , KolodaViewDataSource , KolodaViewDelegate {
    


    @IBOutlet weak var kolodaView: KolodaView!
    
    
    private var dataSource : [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numOfCards {
            array.append(UIImage(named: "Image\(index + 1)")!)
        }
        return array
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    
/* let user = Auth.auth().currentUser
 // [END get_user_profile]
 // [START user_profile]
 if let user = user {
 // The user's ID, unique to the Firebase project.
 // Do NOT use this value to authenticate with your backend server,
 // if you have one. Use getTokenWithCompletion:completion: instead.
 let uid = user.uid
 let email = user.email
 let photoURL = user.photoURL
 */

    @IBAction func likeBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func disslikeBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.left)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        print("index = \(index)")
        return UIImageView(image: dataSource[index])
    }
   
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {

        switch direction {
        case .left:
            print("left")
        case .right:
            print("right")
        default:
            print("error")
        }
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
    

}

