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
import Kingfisher
import CoreLocation


class MainViewController: UIViewController , KolodaViewDataSource , KolodaViewDelegate {
    

    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var kolodaView: KolodaView!
    
  
    
    private var allRestaurants : [Restaurant] = []
    private var allLikedCards : [Card] = []
    private var currentLikedCardsIndexes : [Int] = []
    private var allEligbleCards : [Card] = []
    private var cardsToShow : [Card] = []
    private var userHandler : User? = nil
    private var dataHandler : DataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in didload!")
        userHandler = User.getInstance()
        dataHandler = DataManager.getInstance()
        ImageCache.default.maxMemoryCost = 5 * 1024 * 1024
        
        allRestaurants = (dataHandler?.getAllRestaurants())!
        allLikedCards = (userHandler?.getAllLikes())!
        
        setCardToShow()
      
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
      
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        print("in will appear!")
        
        allLikedCards = (userHandler?.getAllLikes())!
        setCardToShow()
        self.kolodaView.reloadData()
    }
    
    
    func isEligble(rest : Restaurant) -> Bool {
   
        let userPrefferedDistance = userHandler?.getPrefferedDistance()
        let userWantsKosher = userHandler?.isUserWantKosher()
        let userWantsDelivery = userHandler?.isUserWantDelivery()
        let userPrefferedPrice = userHandler?.getPrefferedPrice()
       
        let distance = getUserDistanceFromRest(rest: rest)
        
        print("Distance in km = \(distance)")
        
        if distance > Double(userPrefferedDistance!) {
            return false
        }
        
        if userWantsKosher! && !rest.getIsKosher() {
            return false
        }
        
        if userWantsDelivery! && !rest.getHasDelivery() {
            return false
        }
    
        if userPrefferedPrice != 0 {
            if userPrefferedPrice != rest.getPrice() {
                return false
            }
        }
    
        return true
    }
    
    func getUserDistanceFromRest(rest: Restaurant) -> Double{
        
        let userLocation = CLLocation(latitude: (userHandler?.getLatitude())!, longitude: (userHandler?.getLongitude())!)
        let restLocation = CLLocation(latitude: rest.getLatitude(), longitude: rest.getLongitude())
        
        let distanceInMeters = userLocation.distance(from: restLocation)
        let distanceInKm = distanceInMeters/1000
        return distanceInKm
    }
    
    
    @IBAction func preferencesBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "PreferencesViewController")
        navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    
    @IBAction func likesBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:  "ProfileViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc
    func setCardToShow() -> Void {
        
        for rest in allRestaurants {
            if isEligble(rest: rest) {
                allEligbleCards.append(contentsOf: rest.getAllCards())
            }
        }

        //let cardsToRemove = Set(allLikedCards)
        cardsToShow = Array(Set(allEligbleCards).subtracting(Set(allLikedCards)))
        
       // cardsToShow.shuffle()
    
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
        return cardsToShow.count
    }
    
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        cardsToShow = (dataHandler?.getAllUserLikedCards())!
        setCardToShow()
        kolodaView.reloadData()
    }

    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        restLabel.text = cardsToShow[index].getRestName()
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imageView = UIImageView()
        imageView.kf.setImage(with: cardsToShow[index].getCardURL())
        return imageView

    }
   
   
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    }
    
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        switch direction {
        case .left:
            print(cardsToShow[index].getID())
            print(cardsToShow[index].getRestName())
           
        case .right:
            currentLikedCardsIndexes.append(index)
            print(cardsToShow[index].getID())
            print(cardsToShow[index].getRestName())
            userHandler?.addCardToLikes(card: cardsToShow[index])
        
        default:
            print("error in dragging card")
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
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }

}
extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else {return}
        
        for (firstUnshuffled , unshuffledCount) in zip(indices , stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled , offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}


