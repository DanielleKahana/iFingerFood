//
//  UserData.swift
//  FingerFood
//
//  Created by Mac on 24/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserData {
    
    
    private static var sharedData : UserData? = nil
    
    private var userId : String!
    private var username : String!
    private var likedCards : [Card]!
    private var dataHandler : DataManager? = nil
    
    private init() {
        userId = Auth.auth().currentUser?.uid
        dataHandler = DataManager.getInstance()
        
        username = dataHandler?.getUsername(userId: userId)
        likedCards = dataHandler?.getAllUserLikedCards()
        
     
    }
    
    class func getInstance() -> UserData {
        if sharedData == nil {
            sharedData = UserData()
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
    
    
    func setFullName() {
        
    }
    
    func getUsername() -> String {
        let name = dataHandler?.getUsername(userId: userId)
        return name!
    }
  
    func removeCardFromLikes(card: Card) {
        
    }
    
    func getAllLikes() -> [Card] {
        return likedCards
    }
    
    func clearData() {
        UserData.sharedData = nil
    }
    
}
