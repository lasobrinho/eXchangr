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
    var items = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            ServerInterface.sharedInstance.removeItemAdditionObserver(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        ServerInterface.sharedInstance.addItemAdditionObserver(self)
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUserItems()
    }
    
    func loadUserItems() {
        ServerInterface.sharedInstance.fetchAuthenticatedUserItemsList { [unowned self] (retrievedItems) in
            self.items = retrievedItems
            self.tableView.reloadData()
        }
    }
    
    override func removeFromParentViewController() {
        items = []
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            ServerInterface.sharedInstance.requestItemRemoval(items[indexPath.row]) { (success) in
                if success {
                    self.items.removeAtIndex(indexPath.row)
                } else {
                    print("Error deleting item \(self.items[indexPath.row])")
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell") as! ItemTableViewCell
        let item = items[indexPath.row]
        let bytes = item.pictures[0].bytes
        cell.itemImage.image = UIImage(data: bytes)
        cell.itemNameLabel.text = item.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("EditItemViewController") as! EditItemViewController
        vc.item = items[indexPath.row]
        vc.isEditingItem = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func BackButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddItemButtonTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("EditItemViewController") as! EditItemViewController
        vc.isEditingItem = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func update(result: ItemAddOrUpdateResult) {
        
    }

}
