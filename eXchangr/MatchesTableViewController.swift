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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchCell", forIndexPath: indexPath) as! MatchTableViewCell
        let index = indexPath.row
        configureLeftContent(cell, index: index)
        configureRightContent(cell, index: index)
        return cell
    }

    func configureLeftContent(cell: MatchTableViewCell, index: Int) {
        if exchanges![index].itemsLikedByTheOtherUser.count > 1 {
            cell.leftItemNameLabel.text = "Matched \(exchanges![index].itemsLikedByTheOtherUser.count) items"
        } else {
            cell.leftItemNameLabel.text = exchanges![index].itemsLikedByTheOtherUser[0].name
        }
        for item in exchanges![index].itemsLikedByTheOtherUser {
            cell.leftItemsStackView.constraints[0].constant += 40
            let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 40, height: 40))
            image.image = item.pictures[0].asUIImage()
            ViewCustomizers.makeRoundedView(image)
            cell.leftItemsStackView.addArrangedSubview(image)
        }
    }

    func configureRightContent(cell: MatchTableViewCell, index: Int) {
        if exchanges![index].otherUserItemsThatILike.count > 1 {
            cell.rightItemNameLabel.text = "Matched \(exchanges![index].otherUserItemsThatILike.count) items"
        } else {
            cell.rightItemNameLabel.text = exchanges![index].otherUserItemsThatILike[0].name
        }
        for item in exchanges![index].otherUserItemsThatILike {
            cell.rightItemsStackView.constraints[1].constant += 40
            let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 40, height: 40))
            image.image = item.pictures[0].asUIImage()
            ViewCustomizers.makeRoundedView(image)
            cell.rightItemsStackView.addArrangedSubview(image)
        }
        cell.rightItemsUserName.text = exchanges![index].otherUser.name
        cell.rightItemDistanceLabel.text = "\(exchanges![index].distance) miles"
        ServerInterface.sharedInstance.getUserCoordinates(exchanges![index].otherUser) { (coordinates) in
            let clg = CLGeocoder()
            let cll = CLLocation(latitude: CLLocationDegrees(floatLiteral: coordinates.latitude), longitude: CLLocationDegrees(floatLiteral: coordinates.longitude))
            clg.reverseGeocodeLocation(cll, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                cell.rightItemLocationLabel.text = "\(placeMark!.addressDictionary!["City"]!), \(placeMark!.addressDictionary!["State"]!)"
            })
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("BrowseDetailsViewController") as! BrowseDetailsViewController
        vc.otherUserDistance = exchanges![indexPath.row].distance
        vc.exchange = exchanges![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
