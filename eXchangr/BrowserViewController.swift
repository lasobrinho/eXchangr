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

    override func viewDidLoad() {
        super.viewDidLoad()
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //navigationController?.pushViewController(UserItemsViewController(), animated: true)
    }

    @IBAction func MyItemBarButtonTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("UserItemsViewController") as! UserItemsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func LogOutButtonTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func ExchangeButtonTapped(sender: AnyObject) {
        // Code to Exchange an item
        // Shows a new item to the user
    }
    @IBAction func IgnoreButtonTapped(sender: AnyObject) {
        // Code to Ignore an item
        // Shows a new item to the user
    }
}
