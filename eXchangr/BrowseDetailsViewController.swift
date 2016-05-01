//
//  BrowseDetailsViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class BrowseDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    weak var item: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            nameLabel.text = item.name
            descriptionLabel.text = item.description
            imageView.image = item.pictures[0].asUIImage()
            ServerInterface.sharedInstance.requestDistanceForItem(item, callback: { [unowned self] (distance) in
                self.distanceLabel.text = "\(distance) miles"
            })
        }
    }

}
