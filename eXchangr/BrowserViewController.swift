//
//  BrowserViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    var mainStoryboard: UIStoryboard!

    @IBOutlet weak var noMoreItems: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!



    @IBOutlet weak var imageXConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageYConstraint: NSLayoutConstraint!
    @IBOutlet weak var ignoreBtnYConstraint: NSLayoutConstraint!
    @IBOutlet weak var exchangeBtnYConstraint: NSLayoutConstraint!

    var browseItems = [Item]()

    var currentItem: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        toggleInterface(true)
        refreshData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAnimation()
    }

    func prepareForAnimation() {
        imageYConstraint.constant = -view.center.y - image.frame.height/3
        ignoreBtnYConstraint.constant += view.frame.height * 3
        exchangeBtnYConstraint.constant += view.frame.height * 3
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        imageYConstraint.constant = 8
        self.ignoreBtnYConstraint.constant = 8
        self.exchangeBtnYConstraint.constant = 8
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func refreshData() {
        ServerInterface.sharedInstance.requestElegibleItemsList { [unowned self] (items) in
            self.browseItems = items
            self.loadUIElements()
        }
    }

    @IBAction func MyItemBarButtonTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("UserItemsViewController") as! UserItemsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func MenuButtonTapped(sender: AnyObject) {
        let menuController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController")
        NSNotificationCenter.defaultCenter().postNotificationName("showMenu", object: nil, userInfo: ["menuController" : menuController])
    }
    @IBAction func ExchangeButtonTapped(sender: AnyObject) {
        performReaction(interested: true)
    }

    @IBAction func IgnoreButtonTapped(sender: AnyObject) {
        performReaction(interested: false)
    }

    private func performReaction(interested interested: Bool) {
        if currentItem != nil {
            ServerInterface.sharedInstance.reactToItem(currentItem, interested: interested, callback: increaseCurrentIndexCallback)
        }
    }

    func increaseCurrentIndexCallback(success: Bool) {
        if success {
            let duration: NSTimeInterval = 0.3
            imageXConstraint.constant -= view.frame.width
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                }, completion: {
                    _ in
                    self.loadUIElements()
                    self.imageXConstraint.constant = self.view.center.x + self.view.frame.width
                    self.view.layoutIfNeeded()
                    self.imageXConstraint.constant = 0
                    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [], animations: {
                        self.view.layoutIfNeeded()
                        }, completion: nil)
            })
        }
    }

    func loadUIElements() {
        if browseItems.count > 0 {
            toggleInterface(false)
            currentItem = browseItems.popLast()
            image.image = currentItem.pictures[0].asUIImage()
            name.text = currentItem.name
            descriptionText.text = currentItem.description
            ServerInterface.sharedInstance.requestDistanceForItem(currentItem, callback: { (distance) in
                self.distance.text = "\(distance) miles"
            })
        } else {
            image.image = nil
            toggleInterface(true)
        }
    }

    func toggleInterface(hidden: Bool) {
        descriptionText.hidden = hidden
        image.hidden = hidden
        name.hidden = hidden
        ignoreButton.hidden = hidden
        exchangeButton.hidden = hidden
        distance.hidden = hidden
        noMoreItems.hidden = !hidden
    }
}
