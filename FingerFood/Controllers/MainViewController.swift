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
   
    private var allEligbleCards : [Card] = []
    private var cardToShowImages : [UIImage] = []
    private var cardsToShow : [Card] = []
    private var userData : UserData? = nil
    private var dataHandler : DataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = UserData.getInstance()
        dataHandler = DataManager.getInstance()
        
        allRestaurants = (dataHandler?.getAllRestaurants())!
        //allLikedCards = (userData?.getAllLikes())!
        
        setCardToShow()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
  
    }
    
   
    
  
    func isEligble(restaurant : Restaurant) -> Bool {
        if allEligbleCards.count >  3 {
        return false
        }
        else {
        return true
        }
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
        
        allLikedCards = (userData?.getAllLikes())!
        let cardsToRemove = Set(allLikedCards)
        cardsToShow = Array(Set(allEligbleCards).subtracting(cardsToRemove))
        
        print("all likedCards = \(allLikedCards.count)")
        print("all egible = \(allEligbleCards.count)")
        print("all rests = \(allRestaurants.count)")
        print("all cardsToRemove = \(cardsToRemove.count)")
         print("all cardstoshow = \(cardsToShow.count)")
        
        //if cardsToShow.count < 5 {
        
            for card in cardsToShow {
                let url = card.getCardURL()
                let data = try? Data(contentsOf: url)
                let image = UIImage(data: data!)
                self.cardToShowImages.append(image!)
            }
        
        print("all cardstoshowImage = \(cardToShowImages.count)")
        //}
            
       /* else {
            loadTopNCards(n: 5)
            
            //load rest of cards asynchrony
            for card in cardsToShow.dropFirst(5) {
                let url = card.getCardURL()
                URLSession.shared.dataTask(with: url) {
                    data,response, error in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.cardToShowImages.append(image!)
                    }
                    }.resume()
            }
    }*/
    }
    
    func loadTopNCards(n : Int) {
        for card in cardsToShow.dropFirst(cardsToShow.count - n) {
            let url = card.getCardURL()
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                self.cardToShowImages.append(image!)
            }
        }
    }
    
    
    
    
   
    @IBAction func likeBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    
    
    func printCard(index: Int) {
        print(cardsToShow[index].getID())
        print(cardsToShow[index].getRestName())
    }
    
    func saveCardToLikes(card : Card) {
        
    }
    
    
    @IBAction func disslikeBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.left)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return cardToShowImages.count
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: cardToShowImages[index])
    }
   
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print(kolodaView.currentCardIndex)
        print(cardsToShow[kolodaView.currentCardIndex].getID())
        print(cardsToShow[kolodaView.currentCardIndex].getRestName())
    }
    
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        switch direction {
        case .left:
            printCard(index: koloda.currentCardIndex-1)
             //remove from images array and from card to show array
           
        case .right:
            let card = cardsToShow[koloda.currentCardIndex-1]
            userData?.addCardToLikes(card: card)
            //remove from images array and from card to show array
            
        
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

}



