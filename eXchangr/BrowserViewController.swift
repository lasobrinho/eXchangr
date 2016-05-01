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

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!

    var browseItems = [Item]()

    var currentItem: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
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
        performReaction(true)
    }

    @IBAction func IgnoreButtonTapped(sender: AnyObject) {
        performReaction(false)
    }

    private func performReaction(interested: Bool) {
        if currentItem != nil {
            ServerInterface.sharedInstance.reactToItem(currentItem, interested: interested, callback: increaseCurrentIndexCallback)
        }
    }

    func increaseCurrentIndexCallback(success: Bool) {
        if success {
            loadUIElements()
        }
    }

    func loadUIElements() {
        if browseItems.count > 0 {
            currentItem = browseItems.popLast()

            image.image = currentItem.pictures[0].asUIImage()
            name.text = currentItem.name
            ServerInterface.sharedInstance.requestDistanceForItem(currentItem, callback: { (distance) in
                self.distance.text = "\(distance) miles"
            })
        } else {
            image.image = nil
            name.text = "Nothing to show"
            self.distance.text = ""
        }
    }
}
