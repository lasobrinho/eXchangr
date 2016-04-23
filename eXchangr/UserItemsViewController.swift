//
//  UserItemsViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class UserItemsViewController: UITableViewController, ItemAdditionObserver {

    var mainStoryboard: UIStoryboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addItemAdditionObserver(self)
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell") as! ItemTableViewCell
        
    }

    @IBAction func BackButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddItemButtonTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("EditItemViewController") as! EditItemViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func update(result: ItemAdditionResult) {
        print("Addition Result")
        print(result)
    }

}
