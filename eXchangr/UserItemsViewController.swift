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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell") as! ItemTableViewCell
        cell.editItemButton.addTarget(self, action: #selector(editButtonTapped), forControlEvents: .TouchUpInside)
        return cell
    }
    
    func editButtonTapped() {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("EditItemViewController") as! EditItemViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
