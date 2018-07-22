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
    
  
    
    private var allRestaurants : [Restaurant] = []
    private var allLikedCards : [Card] = []
    private var cardsToShow : [Card] = []
    private var allEligbleCards : [Card] = []
    private var cardToShowImages : [UIImage] = []
    
    private var dataSource : [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numOfCards {
            array.append(UIImage(named: "Image\(index + 1)")!)
        }
        return array
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        allRestaurants = DataManager.sharedDatabase.getAllRestaurants()
        setCardToShow()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
      
        
    }
    
  
    func isEligble(restaurant : Restaurant) -> Bool {
        return true
    }
    
    
    
    @objc
    func setCardToShow() -> Void {
        for rest in allRestaurants {
            if isEligble(restaurant: rest) {
                allEligbleCards.append(contentsOf: rest.getAllCards())
            }
        }
        
        let cardsToRemove = Set(allLikedCards)
        cardsToShow = Array(Set(allEligbleCards).subtracting(cardsToRemove))
        for card in cardsToShow {
            let url = card.getCardURL()
            
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                self.cardToShowImages.append(image!)
            }
            /*
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.cardToShowImages.append(image!)
                    }
                }
            }*/
        }
        
    }
    
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func disslikeBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.left)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        //return dataSource.count
        
        print(cardToShowImages.count)
        return cardToShowImages.count

    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        print(index)
        return UIImageView(image: cardToShowImages[index])
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
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
    }))
        self.present(alert, animated: true)
        
    }
    
    
    
    
    
    

}

