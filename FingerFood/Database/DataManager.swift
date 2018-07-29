//
//  DataManager.swift
//  FingerFood
//
//  Created by Mac on 21/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth


public class DataManager {
    
    private static var sharedDatabase : DataManager? = nil
    
   // static let sharedDatabase = DataManager()
    let USERS = "users"
    let RESTAURANTS = "restaurants"
    let LIKES = "likes"
    let REST_ID = "restID"
    let IMAGE_URL = "imageURL"
    let REST_NAME = "restName"
    
    
    var restsRef : DatabaseReference
    var usersRef: DatabaseReference
    //var userLikesRef: DatabaseReference
    
    private var allRestaurants = [Restaurant]()
    private var userLikedCards = [Card]()
    //var userID : String
    
    private init(){
       // userID = DataManager.shared.getuser..
       
        restsRef = Database.database().reference().child(RESTAURANTS)
        usersRef = Database.database().reference().child(USERS)
        
        readRestsFromFirebase()
      
    }
    
    class func getInstance() -> DataManager {
        if sharedDatabase == nil {
            sharedDatabase = DataManager()
        }
        return sharedDatabase!
    }
    
    
    func readRestsFromFirebase()  {
        if !allRestaurants.isEmpty {return}
        restsRef.observe(.value, with: {(snapshot) in
            if (!snapshot.exists()) {return}
            
            for child in snapshot.children {
                if let restData = child as? DataSnapshot {
                    let restId = restData.key
                    if let restDict = restData.value as? [String:Any] {
                        let restName = restDict[self.REST_NAME] as! String
                        let address = restDict["Address"] as! String
                        let phoneNumber = restDict["PhoneNumber"] as! String
                        let website = restDict["website"] as! String
                        let price = restDict["Price"] as! Int
                        let isKosher = restDict["isKosher"] as! Bool
                        let hasDelivery = restDict["hasDelivery"] as! Bool
                        let latitude = restDict["latitude"] as! Double
                        let longtitude = restDict["longtitude"] as! Double
                        
                        let rest = Restaurant(id: restId, name: restName, webSiteURL: website, phone: phoneNumber, address: address, latitude: latitude, longtitude: longtitude, isKosher: isKosher, hasDelivery: hasDelivery, price: price)
                       
                        let cards = restData.childSnapshot(forPath: "Cards")
                    
                        for card in cards.children {
                            if let cardData = card as? DataSnapshot{
                                let cardID = cardData.key
                                let cardUrl = cardData.value as! String
                                let restCard = Card(cardID: cardID, restID: restId, restName: restName, imageURL: cardUrl)
                                rest.addCardToList(card: restCard)
                            }
                        }
                         self.allRestaurants.append(rest)
                    }
                }
                
            }
        })
        
    }
    
    func getUsername(userId: String) -> String {
            return "aa"
    }
    
    
    func getAllRestaurants() -> [Restaurant] {
        return self.allRestaurants
    }
    
    func getAllUserLikedCards() -> [Card] {
        return self.userLikedCards
    }
    
    func readUserLikesFromFirebase(userId : String) {
        let userLikedCardsRef = usersRef.child(userId).child(LIKES)
        
        userLikedCardsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if (!snapshot.exists()) {return}
            
            for child in snapshot.children {
                if let cardData = child as? DataSnapshot {
                    let cardId = cardData.key
                    print(cardId)
                    if let cardDict = cardData.value as? [String:String] {
                         print(cardDict)
                        let restId = cardDict[self.REST_ID]
                        let imageUrl = cardDict[self.IMAGE_URL]
                        let restName = cardDict[self.REST_NAME]
                        
                        let card : Card = Card(cardID: cardId, restID: restId!, restName: restName!, imageURL: imageUrl!)
                        self.userLikedCards.append(card)
                    }
                }
                }
            
            })
    }
        
    
    
    func writeCardToLikes(userId : String , card : Card) {
        usersRef.child(userId).child(LIKES).child(card.getID()).child(REST_ID).setValue(card.getRestId())
        usersRef.child(userId).child(LIKES).child(card.getID()).child(IMAGE_URL).setValue(card.getImageURL())
        usersRef.child(userId).child(LIKES).child(card.getID()).child(REST_NAME).setValue(card.getRestName())
        
    }
    
    
    
}
