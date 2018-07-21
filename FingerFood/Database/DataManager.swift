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
    
   // var restsRef : DatabaseReference
    var usersRef: DatabaseReference
    var userLikesRef: DatabaseReference
    var databaseHandle : DatabaseHandle!
    
    var userID : String
    
    private init(){
        userID = (Auth.auth().currentUser?.uid)!
       
       // restsRef = Database.database().reference().child(<#T##pathString: String##String#>)
        usersRef = Database.database().reference().child(USERS)
        userLikesRef = usersRef.child(userID).child(LIKES)
    }
    
    func getUserLikedCards() -> [Card] {
        var userLikedCards = [Card]()
        databaseHandle = userLikesRef.observe(.value, with: {(data) in
            if (data.exists()) {
                for ds in data.children {
                  /*
                    let cardID : String = ""
                    let restID : String = ""
                    let restName : String = ""
                    let imageURL : String = ""
                    
                    let card = Card(cardID, restID, restName , imageURL)
                    userLikedCards.append(card)
 */
                }
            }
            
        })
        return userLikedCards
    }
    
    
}
