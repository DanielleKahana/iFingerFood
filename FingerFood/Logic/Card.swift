//
//  Card.swift
//  FingerFood
//
//  Created by Mac on 21/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

class Card : Hashable{
    var hashValue: Int {
        return cardID.hashValue
    }
    
   
    
    private var cardID : String
    private var restID : String
    private var restName : String
    private var imageURL : String

    
    
    public init(cardID : String , restID: String , restName : String , imageURL: String){
        self.cardID = cardID
        self.restID = restID
        self.restName = restName
        self.imageURL = imageURL
    }
    
    func getID() -> String {
        return cardID
    }
    
    func setCardID(id : String){
        self.cardID = id
    }
    
    func getCardURL() -> URL {
        let url = URL(string: self.imageURL.trimmingCharacters(in: .whitespaces))
        return url!
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.cardID == rhs.cardID
    }
}
