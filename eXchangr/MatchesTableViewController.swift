//
//  MatchesTableViewController.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 4/30/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {

    var exchanges: [Exchange]?

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.requestExchangesList { [unowned self] (exchanges) in
            self.exchanges = exchanges
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchanges != nil ? exchanges!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
