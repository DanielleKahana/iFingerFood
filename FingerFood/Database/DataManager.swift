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
    static let sharedDatabase = DataManager()
    let USERS = "users"
    let RESTAURANTS = "restaurants"
    let LIKES = "likes"
    
    var restsRef : DatabaseReference
    var usersRef: DatabaseReference
    //var userLikesRef: DatabaseReference
    //var databaseHandle : DatabaseHandle!
    private var allRestaurants = [Restaurant]()
    //var userID : String
    
    private init(){
       // userID = DataManager.shared.getuser..
       
        restsRef = Database.database().reference().child(RESTAURANTS)
        print(restsRef)
        usersRef = Database.database().reference().child(USERS)
        print(usersRef)
        //userLikesRef = usersRef.child(userID).child(LIKES)
        setRestsFromDB()
    }
    
    func setRestsFromDB() -> Void {
        
        restsRef.observe(.value, with: {(snapshot) in
            if (!snapshot.exists()) {return}
 
            for child in snapshot.children {
                if let restData = child as? DataSnapshot{
                    let restId = restData.key
                    if let restDict = restData.value as? [String:Any] {
                        let restName = restDict["restName"] as! String
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
    
    func getAllRestaurants() -> [Restaurant] {
        return self.allRestaurants
    }
    
    /*
    func getUserLikedCards() -> [Card] {
        var userLikedCards = [Card]()
        databaseHandle = userLikesRef.observe(.value, with: {(data) in
        if (!data.exists()) {return}
            
            for ds in data.children {
     
                    let cardID : String = ""
                    let restID : String = ""
                    let restName : String = ""
                    let imageURL : String = ""
                    
                    let card = Card(cardID, restID, restName , imageURL)
                    userLikedCards.append(card)
 
                }
            }
            
        })
        return userLikedCards
    }
    */
    
}
