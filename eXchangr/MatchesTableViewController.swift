//
//  MatchesTableViewController.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 4/30/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit
import MapKit

class MatchesTableViewController: UITableViewController {

    var mainStoryboard: UIStoryboard!
    var exchanges: [Exchange]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        ServerInterface.sharedInstance.requestExchangesList { [unowned self] (exchanges) in
            self.exchanges = exchanges
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchanges != nil ? exchanges!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Match", forIndexPath: indexPath) as! MatchTableViewCell
        cell.leftItemImage.image = exchanges![indexPath.row].itemsLikedByTheOtherUser[0].pictures[0].asUIImage()
        cell.leftItemNameLabel.text = exchanges![indexPath.row].itemsLikedByTheOtherUser[0].name
        cell.rightItemImage.image = exchanges![indexPath.row].otherUserItemsThatILike[0].pictures[0].asUIImage()
        cell.rightItemDistanceLabel.text = "\(exchanges![indexPath.row].distance) miles"
        ServerInterface.sharedInstance.getUserCoordinates(exchanges![indexPath.row].otherUser) { (coordinates) in
            let clg = CLGeocoder()
            let cll = CLLocation(latitude: CLLocationDegrees(floatLiteral: coordinates.latitude), longitude: CLLocationDegrees(floatLiteral: coordinates.longitude))
            clg.reverseGeocodeLocation(cll, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                cell.rightItemLocationLabel.text = "\(placeMark!.addressDictionary!["City"]!), \(placeMark!.addressDictionary!["State"]!)"
            })
        }
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("BrowseDetailsViewController") as! BrowseDetailsViewController
        vc.item = exchanges![indexPath.row].otherUserItemsThatILike[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
