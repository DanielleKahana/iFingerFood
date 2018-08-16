//
//  PopUpViewController.swift
//  FingerFood
//
//  Created by Mac on 06/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SafariServices

protocol PopupDelegate : class {
    func deleteCard(card : Card, indexPath : IndexPath)
}


class PopUpViewController: UIViewController , SFSafariViewControllerDelegate {

    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var imagePresented: UIImageView!
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var delegate : PopupDelegate?
    
    var image : UIImage?
    var card: Card?
    var restName : String = ""
    var allRests : [Restaurant]?
    var cellIndexPath : IndexPath?

    
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
        
        for rest in allRests! {
            if rest.getId() == card?.getRestId() {
                return rest.getAddress()
            }
        }
        return ""
    }
    
    @IBAction func dissmissPopUp(_ sender: Any) {
         self.view.removeFromSuperview()
       
    }
    
    @IBAction func disslikeBtnPressed(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.allowUserInteraction,  animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: { Void in (self.removeLikedCard())   }
        )

    }
    
    
    func removeLikedCard() {
        User.getInstance().removeCardFromLikes(card: card!)
        parent?.view.reloadInputViews()
        self.view.removeFromSuperview()
        
        delegate?.deleteCard(card: card!, indexPath: cellIndexPath!)
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        var latitude : Double = 0
        var longitude : Double = 0
        
        for rest in allRests! {
            if rest.getId() == card?.getRestId() {
                 latitude = rest.getLatitude()
                 longitude = rest.getLongitude()
            }
        }
        viewController.latitude = latitude
        viewController.longitude = longitude

        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func callBtnPressed(_ sender: UIButton) {        
        for rest in allRests! {
            if rest.getId() == card?.getRestId() {
                let phoneNumber = rest.getPhone()
                if let url = URL(string: "tel://\(phoneNumber)"){
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    @IBAction func webBtnPressed(_ sender: Any) {
        var website : String = ""
        for rest in allRests! {
            if rest.getId() == card?.getRestId() {
                 website = rest.getWebsiteUrl()
            }
        }
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
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10.0
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
    
    func clearShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 0.0    }
}
