//
//  PreferencesViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource {
  

    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var kosherView: UIView!
    @IBOutlet weak var slider: UISlider!

    let prices = ["All" , "$", "$$" ,"$$$", "$$$$"]
    var priceChosen : Int!
    var isKosherChecked : Bool!
    var hasDeliveryChecked: Bool!
    var user : User?
    var distanceValue : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.getInstance()
        
        pricePicker.delegate = self
        pricePicker.dataSource = self
        
        priceChosen = 0
        isKosherChecked = user?.isUserWantKosher()
        hasDeliveryChecked = user?.isUserWantDelivery()
       // pricePreffernce = user?.getPricePrefference()
        distanceValue = user?.getPrefferedDistance()
        
        setDistanceText(dist: distanceValue!)
        toggleDeliveryView(hasDelivery: hasDeliveryChecked!)
        toggleKosherView(hasKosher: isKosherChecked!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
       
    }
    
    @IBAction func distanceSliderChanged(_ sender: UISlider) {
        distanceValue = Int(sender.value)
        setDistanceText(dist: distanceValue)
    }
    
    
    func setDistanceText(dist : Int) {
        let distanceText = "Restaurants \(String(dist)) Kilometers from you!"
        distanceLabel.text = distanceText
        slider.setValue(Float(dist), animated: true)
    }
    
    @IBAction func applyBtnPressed(_ sender: Any) {
        if user?.isUserWantKosher() != isKosherChecked {
            user?.setKosher(isKosher: isKosherChecked)
        }
        
        if user?.isUserWantDelivery() != hasDeliveryChecked {
            user?.setDelivery(wantDelivery: hasDeliveryChecked)
        }
        
        if user?.getPrefferedDistance() != distanceValue {
            user?.setDistance(distance: distanceValue)
        }
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prices.count
    }
    
  
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        priceChosen = row
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func kosherBtnPressed(_ sender: Any) {
        if isKosherChecked {
            isKosherChecked = false
            kosherView.backgroundColor = UIColor.white
        }else {
            isKosherChecked = true
            kosherView.backgroundColor = UIColor.black
        }
    }
    
    func toggleDeliveryView(hasDelivery : Bool) {
        if hasDelivery {
            deliveryView.backgroundColor = UIColor.black
        }else {
            deliveryView.backgroundColor = UIColor.white
        }
    }
    
    func toggleKosherView(hasKosher : Bool) {
        if hasKosher {
            kosherView.backgroundColor = UIColor.black
        }else {
            kosherView.backgroundColor = UIColor.white
        }
        
    }
    
    @IBAction func deliveryBtnPressed(_ sender: Any) {
        if hasDeliveryChecked {
            hasDeliveryChecked = false
            deliveryView.backgroundColor = UIColor.white
        }else {
            hasDeliveryChecked = true
             deliveryView.backgroundColor = UIColor.black
        }
    }
}
