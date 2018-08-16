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
    private var allEligbleCards : [Card] = []
    private var cardsToShow : [Card] = []
    private var userHandler : User? = nil
    private var dataHandler : DataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.roundedCorners(radius: 10)
        kolodaView.countOfVisibleCards = 3
        ImageCache.default.maxMemoryCost = 5 * 1024 * 1024
        kolodaView.dataSource = self
        kolodaView.delegate = self
    
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
      
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        userHandler = User.getInstance()
        dataHandler = DataManager.getInstance()
        
        allRestaurants = (dataHandler?.getAllRestaurants())!
        allLikedCards = (userHandler?.getAllLikes())!
        setCardToShow()
        
        if !allEligbleCards.isEmpty {
            allEligbleCards.removeAll()
        }
        
        allLikedCards = (userHandler?.getAllLikes())!
        setCardToShow()
        kolodaView.resetCurrentCardIndex()
        kolodaView.reloadData()
    }
    
    
    func isEligble(rest : Restaurant) -> Bool {
   
        let userPrefferedDistance = userHandler?.getPrefferedDistance()
        let userWantsKosher = userHandler?.isUserWantKosher()
        let userWantsDelivery = userHandler?.isUserWantDelivery()
        let userPrefferedPrice = userHandler?.getPrefferedPrice()
       
        let distance = getUserDistanceFromRest(rest: rest)
        
        
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
        cardsToShow = Array(Set(allEligbleCards).subtracting(Set(allLikedCards)))
        if (cardsToShow.isEmpty) {
            restLabel.text = "Sorry, no restaurents found 😔"
        }
        else {cardsToShow.shuffle()}
        
    
    }
 
  
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        animate(sender: sender)
        kolodaView?.swipe(.right)
       
    }
    

    @IBAction func disslikeBtnPressed(_ sender: UIButton) {
        animate(sender: sender)
        kolodaView?.swipe(.left)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return cardsToShow.count
    }
    
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        allLikedCards = (userHandler?.getAllLikes())!
        setCardToShow()
        kolodaView.resetCurrentCardIndex()
        kolodaView.reloadData()
    }

    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) { // This method is called after a card has been shown, after animation is complete
        restLabel.text = cardsToShow[index].getRestName()
    }
    

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView { //Return a view to be displayed at the specified index in the KolodaView.
        let imageView = UIImageView()
        imageView.kf.setImage(with: cardsToShow[index].getCardURL())
        imageView.roundedCorners(radius: 10)
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView

    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if (direction == .right) {
            userHandler?.addCardToLikes(card: cardsToShow[index])
        }
    }
    
    func animate(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in ()   }
        )
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                
                User.getInstance().clearData()
                DataManager.getInstance().clearData()
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



extension Array
{
    mutating func shuffle() {
        for _ in 0..<count
        {
            sort { (_,_) in arc4random() < arc4random()}
        }
    }
}

extension CAGradientLayer {
    func addGradientLayer(view: UIView){
        colors = [UIColor.black.cgColor, UIColor.init(red: 27, green: 51, blue: 89).cgColor]
        frame = view.frame
        
        view.layer.insertSublayer(self, at: 0)
        
    }
}


