//
//  PreferencesViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource {
  
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var kosherBtn: UIButton!
    @IBOutlet weak var priceContainer: UIView!
    
    @IBOutlet weak var distanceContainer: UIView!
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pricePicker: UIPickerView!
   
    @IBOutlet weak var slider: UISlider!

    let prices = ["All" , "$", "$$" ,"$$$", "$$$$"]
    var priceChosen : Int = 0
    var isKosherChecked : Bool = false
    var hasDeliveryChecked: Bool = false
    var user : User?
    var distanceValue : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.getInstance()
        
        pricePicker.delegate = self
        pricePicker.dataSource = self
        
        isKosherChecked = (user?.isUserWantKosher())!
        hasDeliveryChecked = (user?.isUserWantDelivery())!
        priceChosen = (user?.getPrefferedPrice())!
        distanceValue = user?.getPrefferedDistance()
        
        setPicker(value: priceChosen)
        setDistanceText(dist: distanceValue!)
        toggleDeliveryButton(hasDelivery: hasDeliveryChecked)
        toggleKosherButton(hasKosher: isKosherChecked)
        
        pricePicker.setValue(UIColor.white, forKey: "textColor")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let color = UIColor(red: 245, green: 245, blue: 222).cgColor
        applyBtn.addBorderLine(color: color)
        cancelBtn.addBorderLine(color: color)
        
        priceContainer.addBorderLine(color: color)
        distanceContainer.addBorderLine(color: color)
 
       
    }

   
    @IBAction func distanceSliderChanged(_ sender: UISlider) {
        distanceValue = Int(sender.value)
        setDistanceText(dist: distanceValue!)
    }
    
    func setPicker(value : Int) {
            pricePicker.selectRow(value, inComponent: 0, animated: true)
    }
    
    func setDistanceText(dist : Int) {
        let distanceText = "Restaurants \(String(dist)) Kilometers from you!"
        distanceLabel.text = distanceText
        slider.setValue(Float(dist), animated: true)
    }
    
    @IBAction func applyBtnPressed(_ sender: UIButton) {
        
        if user?.isUserWantKosher() != isKosherChecked {
            user?.setKosher(isKosher: isKosherChecked)
        }
        
        if user?.isUserWantDelivery() != hasDeliveryChecked {
            user?.setDelivery(wantDelivery: hasDeliveryChecked)
        }
        
        if user?.getPrefferedDistance() != distanceValue {
            user?.setDistance(distance: distanceValue!)
        }
        
        user?.setPrice(prefferedPrice: priceChosen)
        
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
    
    @IBAction func kosherBtnPressed(_ sender: UIButton) {
        if isKosherChecked {
            toggleKosherButton(hasKosher: false)
        }else {
            animate(sender: sender)
            toggleKosherButton(hasKosher: true)
        }
    }
    
    @IBAction func deliveryBtnPressed(_ sender: UIButton) {
        
        if hasDeliveryChecked {
            toggleDeliveryButton(hasDelivery: false)
        }else {
            animate(sender: sender)
            toggleDeliveryButton(hasDelivery: true)
            
        }
        
    }
  
    func animate(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in ()   }
        )
    }
    
 
    func toggleKosherButton(hasKosher : Bool) {
        if hasKosher {
            isKosherChecked = true
            kosherBtn.showsTouchWhenHighlighted = true
            kosherBtn.dropShadow()
        }else {
            isKosherChecked = false
            kosherBtn.showsTouchWhenHighlighted = false
            kosherBtn.clearShadow()
        }
        
    }
    
    func toggleDeliveryButton(hasDelivery : Bool) {
        if hasDelivery {
            hasDeliveryChecked = true
            deliveryBtn.showsTouchWhenHighlighted = true
            deliveryBtn.dropShadow()
            
        }else {
            hasDeliveryChecked = false
            deliveryBtn.showsTouchWhenHighlighted = false
            deliveryBtn.clearShadow()
            
        }
    }
   
    
 
}
