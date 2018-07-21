//
//  Restaurant.swift
//  FingerFood
//
//  Created by Mac on 21/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

class Restaurant{
    private var id : String
    private var name : String
    private var webSiteURL : String
    private var phone : String
    private var address : String
    private var latitude : Double
    private var longtitude : Double
    private var isKosher : Bool
    private var hasDelivery : Bool
    private var price : Int
    private var cardList : [Card]
    
    init(id : String , name : String , webSiteURL : String , phone : String , address: String , latitude : Double , longtitude : Double , isKosher: Bool , hasDelivery : Bool , price : Int  ){
        self.id = id
        self.name = name
        self.webSiteURL = webSiteURL
        self.phone = phone
        self.address = address
        self.latitude = latitude
        self.longtitude = longtitude
        self.isKosher = isKosher
        self.hasDelivery = hasDelivery
        self.price = price
        cardList = [Card]()
        }
    
}
