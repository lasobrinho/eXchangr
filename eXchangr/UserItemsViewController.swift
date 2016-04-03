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


        let img1 = UIImagePNGRepresentation(UIImage(named: "img1")!)!
        let img2 = UIImagePNGRepresentation(UIImage(named: "img2")!)!
        let img3 = UIImagePNGRepresentation(UIImage(named: "img3")!)!
        let img4 = UIImagePNGRepresentation(UIImage(named: "img4")!)!

        let pic1 = Picture(id: nil, bytes: img1)
        let pic2 = Picture(id: nil, bytes: img2)
        let pic3 = Picture(id: nil, bytes: img3)
        let pic4 = Picture(id: nil, bytes: img4)

        ServerInterface.sharedInstance.performItemAddition(Item(
            id: nil,
            name: "MyNewItem",
            description: "NewItemDescription",
            active: true,
            pictures: [pic1, pic2, pic3, pic4]))
    }

    func update(result: ItemAdditionResult) {
        print(result)
    }

}
