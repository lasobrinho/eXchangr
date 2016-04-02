//
//  UserItemsViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class UserItemsViewController: UIViewController, ItemAdditionObserver {

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addItemAdditionObserver(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        ServerInterface.sharedInstance.performItemAddition(Item(id: nil, name: "MyNewItem", description: "NewItemDescription", active: true, pictures: [UIImage]()))
    }

    func update(result: ItemAdditionResult) {
        print(result)
    }

}
