//
//  MenuViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/30/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit
import MapKit

class MenuViewController: UIViewController {
    
    var mainStoryboard: UIStoryboard!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    var placemark: CLPlacemark? {
        didSet {
            userLocationLabel.text = "\(placemark!.addressDictionary!["City"]!), \(placemark!.addressDictionary!["State"]!)"
        }
    }
    var coordinates: (latitude: Double, longitude: Double)? {
        didSet {
            let clg = CLGeocoder()
            let cll = CLLocation(latitude: CLLocationDegrees(floatLiteral: coordinates!.latitude), longitude: CLLocationDegrees(floatLiteral: coordinates!.longitude))
            clg.reverseGeocodeLocation(cll, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                self.placemark = CLPlacemark(placemark: placeMark)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        configureUserInformationLabels()
    }
    
    func configureUserInformationLabels() {
        let currentUser = ServerInterface.sharedInstance.getAuthenticatedUser()
        userNameLabel.text = currentUser.name
        ServerInterface.sharedInstance.getUserCoordinates(currentUser) { (coordinates) in
            self.coordinates = coordinates
        }
    }

    @IBAction func LogoutButtonTapped() {
        ServerInterface.sharedInstance.performUserLogout()
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("removeMenu", object: nil, userInfo: nil)
    }
    
    @IBAction func matchesButtonTapped(sender: AnyObject) {
        let matchesController = mainStoryboard.instantiateViewControllerWithIdentifier("MatchesTableViewController")
        NSNotificationCenter.defaultCenter().postNotificationName("pushControllerAndRemoveMenu", object: nil, userInfo: ["targetController" : matchesController])
    }
}
