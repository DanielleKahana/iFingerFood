//
//  UserData.swift
//  FingerFood
//
//  Created by Mac on 24/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

class User {
    
    let USER_FIRST_NAME : String = "firstName"
    let USER_LAST_NAME : String = "lastName"
    let DEFAULT_PREF_DISTANCE : Int = 15
    
    private static var sharedData : User? = nil
    
    private var userId : String!
    private var username : String!
    private var likedCards : [Card]!
    private var dataHandler : DataManager? = nil
    private var usersRef : DatabaseReference
    
    private var prefferedDistance: Int!
    private var deliveryPrefference: Bool!
    private var kosherPrefferecne : Bool!
    
    private init() {
        usersRef = Database.database().reference().child("users")
        userId = Auth.auth().currentUser?.uid
        readUsername()
        setAllLikes()
        
        setDistance(distance: DEFAULT_PREF_DISTANCE)
        setKosher(isKosher: false)
        setDelivery(wantDelivery: false)
    
    }
    
    
 
    
    class func getInstance() -> User {
        if sharedData == nil {
            sharedData = User()
        }
        return sharedData!
    }
    
    
    
    
    func addCardToLikes(card : Card){
        if likedCards.contains(card) {
            return
        }
        likedCards.append(card)
        dataHandler?.writeCardToLikes(userId: userId , card: card)
    }
    
   
    
    func getUsername() -> String {
        return username
    }
  
    
    
    func setAllLikes(){
     
        likedCards = [Card]()
        
        if !likedCards.isEmpty {return}
    
        usersRef.child(userId).child("likes").observeSingleEvent(of: .value, with: {(snapshot) in
        
        //usersRef.child(userId).child("likes").observe(.value, with: {(snapshot) in
                
                if (!snapshot.exists()) {return}
                
                for child in snapshot.children {
                    if let cardData = child as? DataSnapshot {
                        let cardId = cardData.key
                        print(cardId)
                        if let cardDict = cardData.value as? [String:String] {
                            print("LIKED cards!!!")
                            print(cardDict)
                            let restId = cardDict["restID"]
                            let imageUrl = cardDict["imageURL"]
                            let restName = cardDict["restName"]
                            
                            let card : Card = Card(cardID: cardId, restID: restId!, restName: restName!, imageURL: imageUrl!)
                            self.likedCards.append(card)
                        }
                    }
                }
            })
        
        }
    
    
    func removeCardFromLikes(card: Card) {
        
    }
    
    func setKosher(isKosher : Bool) {
        kosherPrefferecne = isKosher
    }
    
    func setDelivery(wantDelivery : Bool) {
        deliveryPrefference = wantDelivery
    }
    
    func isUserWantKosher() -> Bool {
        return kosherPrefferecne
    }
    
    func isUserWantDelivery() -> Bool {
        return deliveryPrefference
        
    }
    
    func getPrefferedDistance() -> Int {
        return prefferedDistance
    }
    
    func setDistance(distance : Int) {
         prefferedDistance = distance
    }
    
    func readUsername() {
        usersRef.child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            if (!snapshot.exists()) {return}
            
            let firstname = snapshot.childSnapshot(forPath: self.USER_FIRST_NAME).value as! String
            let lastname = snapshot.childSnapshot(forPath: self.USER_LAST_NAME).value as! String
            
            self.username = firstname + " " + lastname
        })
    }
    
 
    
    func getAllLikes() -> [Card] {
        return likedCards
    }
    
    func clearData() {
        User.sharedData = nil
    }
    
}



