//
//  CardViewCell.swift
//  FingerFood
//
//  Created by Mac on 30/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    
    private var card : Card? = nil
    private var index: Int = -1
    
    func setCard(card: Card) {
        self.card = card
    }
    
    func getCard() -> Card {
        return card!
    }
    func setIndex(index: Int) {
        self.index = index
    }
    
    func getIndex() -> Int {
        return index
    }
    
    
    func setCardImage(image : UIImage) {
        cellImage.image = image
    }
    
    func getImage() -> UIImage {
        return cellImage.image!
    }
}
