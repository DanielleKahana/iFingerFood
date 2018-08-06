//
//  PopUpViewController.swift
//  FingerFood
//
//  Created by Mac on 06/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SafariServices

class PopUpViewController: UIViewController , SFSafariViewControllerDelegate {

    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var imagePresented: UIImageView!
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var image : UIImage?
    var card: Card?
    var restName : String = ""
    var allRests : [Restaurant]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopUpView.roundedCorners(radius: 10)
        PopUpView.dropShadow()

        allRests = DataManager.getInstance().getAllRestaurants()
        
        imagePresented.image = image
        restNameLabel.text  = card?.getRestName()
        let address = findAddress()
        addressLabel.text = address
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func findAddress() -> String{
        
        for rest in allRests {
            if rest.getId() == card?.getRestId() {
                return rest.getAddress()
            }
        }
        return ""
    }
    
    @IBAction func dissmissPopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func disslikeBtnPressed(_ sender: Any) {
        User.getInstance().removeCardFromLikes(card: card!)
        parent?.view.reloadInputViews()
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func callBtnPressed(_ sender: Any) {
        for rest in allRests {
            if rest.getId() == card?.getRestId() {
                let phoneNumber = rest.getPhone()
                if let url = URL(string: "tel://\(phoneNumber)"){
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    @IBAction func webBtnPressed(_ sender: Any) {
        let website = "http://www.google.com"
        let requestUrl = URL(string: website)
        let svc : SFSafariViewController = SFSafariViewController(url: requestUrl!)
        svc.delegate = self
        present(svc, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UIView {
    func roundedCorners(radius : Int){
        layer.cornerRadius = CGFloat(radius)
    }
    
    func dropShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10.0
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
}
