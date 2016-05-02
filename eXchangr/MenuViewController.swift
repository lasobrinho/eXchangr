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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        activityIndicator.startAnimating()
        configureUserInformationLabels()
    }

    func configureUserInformationLabels() {
        let currentUser = ServerInterface.sharedInstance.getAuthenticatedUser()
        userNameLabel.text = currentUser.name
        ServerInterface.sharedInstance.getUserCoordinates(currentUser) { (coordinates) in
            let clg = CLGeocoder()
            let cll = CLLocation(latitude: CLLocationDegrees(floatLiteral: coordinates.latitude), longitude: CLLocationDegrees(floatLiteral: coordinates.longitude))
            clg.reverseGeocodeLocation(cll, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                self.activityIndicator.stopAnimating()
                self.userLocationLabel.text = "\(placeMark!.addressDictionary!["City"]!), \(placeMark!.addressDictionary!["State"]!)"
                self.userLocationLabel.hidden = false
            })
        }
    }

    @IBAction func LogoutButtonTapped() {
        ServerInterface.sharedInstance.performUserLogout()
    }

    @IBAction func matchesButtonTapped(sender: AnyObject) {
        let matchesController = mainStoryboard.instantiateViewControllerWithIdentifier("MatchesTableViewController")
        NSNotificationCenter.defaultCenter().postNotificationName("pushControllerAndRemoveMenu", object: nil, userInfo: ["targetController" : matchesController])
    }
}
