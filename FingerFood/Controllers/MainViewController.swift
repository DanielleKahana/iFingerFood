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

private var numOfCards : Int = 5


class MainViewController: UIViewController , KolodaViewDataSource , KolodaViewDelegate {
    

    @IBOutlet weak var restLabel: UILabel!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
  
    
    private var allRestaurants : [Restaurant] = []
    private var allLikedCards : [Card] = []
    private var currentLikedCardsIndexes : [Int] = []
    private var allEligbleCards : [Card] = []
    //private var cardToShowImages : [UIImage] = []
    private var cardsToShow : [Card] = []
    private var userHandler : User? = nil
    private var dataHandler : DataManager? = nil
    
    private var threeCards : [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userHandler = User.getInstance()
        dataHandler = DataManager.getInstance()

        ImageCache.default.maxMemoryCost = 5 * 1024 * 1024
        
        allRestaurants = (dataHandler?.getAllRestaurants())!
        allLikedCards = (userHandler?.getAllLikes())!
        
        setCardToShow()
    
 
//        kolodaView.countOfVisibleCards = 1
      
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    func isEligble(restaurant : Restaurant) -> Bool {
        /*
        if allEligbleCards.count >  15 {
        return false
        }
        else {
 */
        return true
   //     }
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
            if isEligble(restaurant: rest) {
                allEligbleCards.append(contentsOf: rest.getAllCards())
            }
        }

        let cardsToRemove = Set(allLikedCards)
        cardsToShow = Array(Set(allEligbleCards).subtracting(cardsToRemove))
        
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
        kolodaView.reloadData()
    }

    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        restLabel.text = cardsToShow[index].getRestName()
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        print("card Index in koloda \(index)")
        
        let imageView = UIImageView()

//        DispatchQueue.global().async { [weak self] in
//            guard let url = self?.cardsToShow[index].getCardURL() else { return }
//            guard let data = try? Data(contentsOf: url) else { return }
//            let image = UIImage(data: data)
//            DispatchQueue.main.async {
//                imageView.image = image
//            }
//        }
        //imageView.contentMode = .scaleAspectFill
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
            print("Disliked CARD:")
            print(cardsToShow[index].getID())
            print(cardsToShow[index].getRestName())
            
             //remove from images array and from card to show array
           
        case .right:
            currentLikedCardsIndexes.append(index)
            print("LIKED CARD:")
            print(cardsToShow[index].getID())
            print(cardsToShow[index].getRestName())
           
            //userHandler?.addCardToLikes(card: cardsToShow[index])
            
            
        
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


