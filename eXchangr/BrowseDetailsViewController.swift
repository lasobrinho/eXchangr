//
//  BrowseDetailsViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit
import MapKit

class BrowseDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var otherUserNameLabel: UILabel!
    @IBOutlet weak var otherUserEmailLabel: UILabel!
    @IBOutlet weak var otherUserPhoneLabel: UILabel!
    @IBOutlet weak var myItemsStackView: UIStackView!
    @IBOutlet weak var otherUserLocationLabel: UILabel!
    @IBOutlet weak var otherUserDistanceLabel: UILabel!
    
    @IBOutlet weak var yourItemsTitleLabel: UILabel!
    @IBOutlet weak var yourItemsStackView: UIStackView!

    @IBOutlet weak var otherUserItemsTitleLabel: UILabel!
    @IBOutlet weak var otherUserItemsTableView: UITableView!
    
    @IBOutlet weak var matchDetailsView: UIView!
    @IBOutlet weak var yourItemsView: UIView!
    @IBOutlet weak var otherUserItemsView: UIView!
    
//    var leftSwipeRecognizer: UISwipeGestureRecognizer
//    var rightSwipeRecognizer: UISwipeGestureRecognizer
    
    var exchange: Exchange?
    var otherUserDistance: Double!
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMatchDetailsView()
        configureYourItemsView()
        configureOtherUserItemsView()
        
        otherUserItemsTableView.delegate = self
        otherUserItemsTableView.dataSource = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
//        leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftImageSwipe))
//        rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightImageSwipe))
//        
//        leftSwipeRecognizer.direction = .Left
//        rightSwipeRecognizer.direction = .Right
    }
    
    func configureMatchDetailsView() {
        setShadowForView(matchDetailsView)
        
        otherUserNameLabel.text = "Name: \(exchange!.otherUser.name)"
        otherUserEmailLabel.text = "Email: \(exchange!.otherUser.email)"
        otherUserPhoneLabel.text = "Phone Number: \(exchange!.otherUser.phone)"
        
        ServerInterface.sharedInstance.getUserCoordinates(exchange!.otherUser) { (coordinates) in
            let clg = CLGeocoder()
            let cll = CLLocation(latitude: CLLocationDegrees(floatLiteral: coordinates.latitude), longitude: CLLocationDegrees(floatLiteral: coordinates.longitude))
            clg.reverseGeocodeLocation(cll, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                self.otherUserLocationLabel.text = "\(placeMark!.addressDictionary!["City"]!), \(placeMark!.addressDictionary!["State"]!)"
            })
        }
        otherUserDistanceLabel.text = "\(otherUserDistance) miles"
    }
    
    func configureYourItemsView() {
        setShadowForView(yourItemsView)
        
        yourItemsTitleLabel.text = "Your Items that \(exchange!.otherUser.name) is interested"
        for item in exchange!.itemsLikedByTheOtherUser {
            yourItemsStackView.constraints[1].constant += 60
            let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 60, height: 60))
            image.image = item.pictures[0].asUIImage()
            ViewCustomizers.makeRoundedView(image)
            yourItemsStackView.addArrangedSubview(image)
        }
    }
    
    func configureOtherUserItemsView() {
        setShadowForView(otherUserItemsView)
        otherUserItemsTitleLabel.text = "Items from \(exchange!.otherUser.name) that you want"
    }
    
    func setShadowForView(selectedView: UIView) {
        selectedView.layer.shadowColor = UIColor.blackColor().CGColor
        selectedView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        selectedView.layer.shadowRadius = 5.0
        selectedView.layer.shadowOpacity = 0.25
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchange!.otherUserItemsThatILike.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OtherUserItemCell", forIndexPath: indexPath) as! OtherUserItemsTableViewCell
        cell.itemNameLabel.text = exchange!.otherUserItemsThatILike[indexPath.row].name
        cell.itemImageView.image = exchange!.otherUserItemsThatILike[indexPath.row].pictures[0].asUIImage()
        ViewCustomizers.makeRoundedView(cell.itemImageView)
//        cell.itemImageView.addGestureRecognizer(leftSwipeRecognizer)
//        cell.itemImageView.addGestureRecognizer(rightSwipeRecognizer)
        cell.itemDescriptionTextView.text = exchange!.otherUserItemsThatILike[indexPath.row].description
        
        configureCellTextField(cell)
        return cell
    }
    
    func configureCellTextField(cell: OtherUserItemsTableViewCell) {
        cell.itemDescriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        cell.itemDescriptionTextView.layer.borderWidth = 1.0
        cell.itemDescriptionTextView.layer.cornerRadius = 5
        cell.itemDescriptionTextView.editable = false
    }


//    let swipeAnimationDuration: NSTimeInterval = 0.15
//    func leftImageSwipe(sender: UISwipeGestureRecognizer) {
//        if currentIndex < item.pictures.count - 1 {
//            currentIndex += 1
//            UIView.animateWithDuration(swipeAnimationDuration, animations: {
//                self.imageView.center.x = -self.view.center.x
//                }, completion: { (success) in
//                    self.imageView.center.x = self.view.frame.width + self.view.center.x
//                    UIView.animateWithDuration(self.swipeAnimationDuration, animations: {
//                        self.imageView.image = self.item.pictures[self.currentIndex].asUIImage()
//                        self.imageView.center.x = self.view.center.x
//                        }, completion: nil)
//            })
//        }
//    }
//    
//    func rightImageSwipe(sender: UISwipeGestureRecognizer) {
//        if currentIndex > 0 {
//            currentIndex -= 1
//            UIView.animateWithDuration(swipeAnimationDuration, animations: {
//                self.imageView.center.x = self.view.frame.width + self.view.center.x
//                }, completion: { (success) in
//                    self.imageView.center.x = -self.view.center.x
//                    UIView.animateWithDuration(self.swipeAnimationDuration, animations: {
//                        self.imageView.image = self.item.pictures[self.currentIndex].asUIImage()
//                        self.imageView.center.x = self.view.center.x
//                        }, completion: nil)
//            })
//        }
//    }
//    
//    func swipeGesture(sender: UISwipeGestureRecognizer) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }

}
