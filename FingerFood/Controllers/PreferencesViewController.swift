//
//  PreferencesViewController.swift
//  FingerFood
//
//  Created by Mac on 18/07/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource {
  

    @IBOutlet weak var pricePicker: UIPickerView!
    
    let prices = ["All" , "$", "$$" ,"$$$", "$$$$"]
    var priceChosen : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pricePicker.delegate = self
        pricePicker.dataSource = self
        priceChosen = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    
    
    @IBAction func applyBtnPressed(_ sender: Any) {
        
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

}
