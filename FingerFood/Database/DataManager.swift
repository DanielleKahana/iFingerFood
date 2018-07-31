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
    
    let USERS : String = "users"
    let RESTAURANTS : String = "restaurants"

    let LIKES : String = "likes"
    let REST_ID : String = "restID"
    let IMAGE_URL : String = "imageURL"
    let REST_NAME : String = "restName"
    let KOSHER : String = "isKosher"
    let DELIVARY : String = "hasDelivery"
    let LATITUDE : String = "latitude"
    let LONGITUDE : String = "longtitude"
    let WEBSITE : String = "website"
    let PHONE : String = "PhoneNumber"
    let ADDRESS : String = "Address"
    let PRICE : String = "Price"
    let USER_FIRST_NAME : String = "firstName"
    let USER_LAST_NAME : String = "lastName"
    
    private static var sharedDatabase : DataManager? = nil
    
    var restsRef : DatabaseReference
    var usersRef: DatabaseReference

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
                        let address = restDict[self.ADDRESS] as! String
                        let phoneNumber = restDict[self.PHONE] as! String
                        let website = restDict[self.WEBSITE] as! String
                        let price = restDict[self.PRICE] as! Int
                        let isKosher = restDict[self.KOSHER] as! Bool
                        let hasDelivery = restDict[self.DELIVARY] as! Bool
                        let latitude = restDict[self.LATITUDE] as! Double
                        let longtitude = restDict[self.LONGITUDE] as! Double
                        
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
    
   
    
    func getAllRestaurants() -> [Restaurant] {
        return self.allRestaurants
    }
    
    func getAllUserLikedCards() -> [Card] {
        return self.userLikedCards
    }
    
    

    
    func readUserLikesFromFirebase(userId : String){
       if !userLikedCards.isEmpty {return}
        
        usersRef.child(userId).child(LIKES).observe(.value, with: {(snapshot) in
            
            if (!snapshot.exists()) {return}
            
            for child in snapshot.children {
                if let cardData = child as? DataSnapshot {
                    let cardId = cardData.key
                    print(cardId)
                    if let cardDict = cardData.value as? [String:String] {
                        print("LIKED cards!!!")
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
    
    func addNewUserToData(uid: String , firstName : String , lastName : String) {
        let newUserRef = usersRef.child(uid)
        
        newUserRef.child(USER_FIRST_NAME).setValue(firstName)
        newUserRef.child(USER_LAST_NAME).setValue(lastName)
        newUserRef.child(LIKES).setValue(0)
    }
    
    
    
}
