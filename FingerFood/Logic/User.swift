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

    let DEFAULT_PREF_DISTANCE : Int = 15
    let DEFAULT_PREF_PRICE : Int = 0
    
    private static var sharedData : User? = nil
    
    private var userId : String!
    private var username : String!
    private var likedCards : [Card] = [Card]()
    private var dataHandler : DataManager? = nil
    
    private var latitude : Double!
    private var longitude : Double!
    private var prefferedPrice : Int!
    private var prefferedDistance: Int!
    private var deliveryPrefference: Bool!
    private var kosherPrefferecne : Bool!
    
    private init() {
        dataHandler = DataManager.getInstance()
        
        setPrice(prefferedPrice: DEFAULT_PREF_PRICE)
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
    
   
    func setUserID(userId : String) {
        self.userId = userId
    }
    
    func getUsername() -> String {
        return username
    }
  
    func setLikedCards(cards : [Card]) {
        self.likedCards = cards
    }
    
    func removeCardFromLikes(card: Card) {
        if likedCards.contains(card){
            let i = likedCards.index(of: card)
            likedCards.remove(at: i!)
        }
        dataHandler?.removeCardFromLikes(userId: userId , card: card) 
    }
    
    func setKosher(isKosher : Bool) {
        kosherPrefferecne = isKosher
    }
    
    func setDelivery(wantDelivery : Bool) {
        deliveryPrefference = wantDelivery
    }
    
    func setLocation(latitude : Double , longitude : Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func setPrice(prefferedPrice : Int ) {
        self.prefferedPrice = prefferedPrice
    }
    
    func setDistance(distance : Int) {
        prefferedDistance = distance
    }
    
    func setUserName(username: String) {
        self.username = username
    }

    func getLatitude() -> Double {
        return latitude
    }
    
    func getLongitude() -> Double {
        return longitude
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
    
    func getPrefferedPrice() -> Int {
        return prefferedPrice
    }
    
    func getAllLikes() -> [Card] {
        return likedCards
    }
    
    func clearData() {
        User.sharedData = nil
    }
    
}



